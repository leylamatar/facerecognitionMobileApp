import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facerecognition/src/screens/attendanceWcamera.dart';
import 'package:facerecognition/src/screens/home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import '../../ML/Recognition.dart';
import '/ML/Recognizer.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late ImagePicker imagePicker;
  File? _image;
  late FaceDetector faceDetector; //declare detection
  late Recognizer recognizer;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    //initialize face detector
    final options = FaceDetectorOptions();
    faceDetector = FaceDetector(options: options);

    // initialize face recognizer
    recognizer = Recognizer();
  }

  _imageFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doFaceDetection();
      });
    }
  }

  _imageFromGallery() async {
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doFaceDetection();
      });
    }
  }

  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

//detect and save faces as a list
  List<Face> faces = [];
  var image;
  //face detection
  doFaceDetection() async {
    InputImage inputImage = InputImage.fromFile(_image!);
    faces = await faceDetector.processImage(inputImage);
    print("Count---------- = ${faces.length}");

    performFaceREcognition();
  }

  //crop faces
  performFaceREcognition() async {
    _image = await removeRotation(_image!);
    //conver image to byts
    image = await _image?.readAsBytes();
    image = await decodeImageFromList(image);

    for (Face face in faces) {
      //to not get the negative values
      num left = face.boundingBox.left < 0 ? 0 : face.boundingBox.left;
      num top = face.boundingBox.top < 0 ? 0 : face.boundingBox.top;
      num right = face.boundingBox.right > image.width
          ? image.width - 1
          : face.boundingBox.right;
      num bottom = face.boundingBox.bottom > image.height
          ? image.height - 1
          : face.boundingBox.bottom;

      num width = right - left;
      num height = bottom - top;

      File croppedFace = await FlutterNativeImage.cropImage(_image!.path,
          left.toInt(), top.toInt(), width.toInt(), height.toInt());
      var bytes = await croppedFace.readAsBytes();
      img.Image? imgFace = await img.decodeImage(bytes);
      Recognition recognition =
          recognizer.recognize(imgFace!, face.boundingBox);

      showFaceRegistrationDialogue(croppedFace, recognition);
    }
    setState(() {
      _image;
    });
    drawRectangleAroundFaces();
  }

  void saveFaceToFirestore(
      String name, Recognition recognition, String id) async {
    final imgurl = await uploadImage(_image!);

    print('ID: $id');
    firestore.collection('faces').add({
      'name': name.trim(),
      'id': id,
      "Profile Picture": imgurl,
    });
  }

  Future uploadImage(File image) async {
    String url;
   // String imgId = DateTime.now().microsecondsSinceEpoch.toString();
    String id = idEditingController.text;
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('studentsFaces/')
        .child('Student$id');
    await reference.putFile(image);
    url = await reference.getDownloadURL();
    return url;
  }

//Face Registration Dialogue
  TextEditingController textEditingController = TextEditingController();
  TextEditingController idEditingController = TextEditingController();
  showFaceRegistrationDialogue(File cropedFace, Recognition recognition) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Face Registration", textAlign: TextAlign.center),
        alignment: Alignment.center,
        scrollable: true,
        content: SizedBox(
          height: 380,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.file(
                cropedFace,
                width: 180,
                height: 180,
              ),
              SizedBox(
                width: 230,
                child: TextField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Enter Name")),
              ),
              SizedBox(
                width: 230,
                child: TextField(
                    controller: idEditingController,
                    decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Enter ID")),
              ),
              ElevatedButton(
                  onPressed: () {
                    HomePage.registered.putIfAbsent(
                        textEditingController.text, () => recognition);
                    // Save the face data to Firebase Cloud Firestore
                    saveFaceToFirestore(textEditingController.text, recognition,
                        idEditingController.text);
                    textEditingController.text = "";
                    idEditingController.text = "";
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Face Registered"),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 5, 41, 70),
                      minimumSize: const Size(200, 40)),
                  child: const Text("Register"))
            ],
          ),
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

//remove rotation of camera images
  removeRotation(File inputImage) async {
    final img.Image? capturedImage =
        img.decodeImage(await File(inputImage.path).readAsBytes());
    final img.Image orientedImage = img.bakeOrientation(capturedImage!);
    return await File(_image!.path).writeAsBytes(img.encodeJpg(orientedImage));
  }

  //draw rectangle
  drawRectangleAroundFaces() async {
    _image = removeRotation(_image!);
    image = await _image?.readAsBytes();
    image = await decodeImageFromList(image);
    print("${image.width}   ${image.height}");
    setState(() {
      image;
      faces;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 24, 56, 82),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 14, 56, 90),
        title: const Text("Add students informations"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image != null
              // ? Container(
              //   width: 300,
              //   height: 220,
              //   child: Image.file(_image!),
              //  )
              ? Container(
                  margin: const EdgeInsets.only(
                      top: 60, left: 30, right: 30, bottom: 0),
                  child: FittedBox(
                    child: SizedBox(
                      width: image.width.toDouble(),
                      height: image.width.toDouble(),
                      child: CustomPaint(
                        painter:
                            FacePainter(facesList: faces, imageFile: image),
                      ),
                    ),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: Image.asset(
                    "assets/images/profile.png",
                    width: 300,
                    height: 220,
                  ),
                ),
          Container(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AttendanceWcameraPage()),
              );
            },
            child: Text("real Time recognize with camera"),
          ),
          const Text(
            "Choose image Or Capture from Camera",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          //section which displays buttons for choosing and capturing images
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(200))),
                  child: InkWell(
                    onTap: () {
                      _imageFromGallery();
                    },
                    child: const SizedBox(
                      width: 80,
                      height: 80,
                      child: Icon(
                        Icons.image,
                        color: Color.fromARGB(255, 11, 42, 63),
                        size: 39,
                      ),
                    ),
                  ),
                ),
                Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(200))),
                  child: InkWell(
                    onTap: () {
                      _imageFromCamera();
                    },
                    child: const SizedBox(
                      width: 80,
                      height: 80,
                      child: Icon(
                        Icons.camera,
                        color: Color.fromARGB(255, 11, 42, 63),
                        size: 39,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  List<Face> facesList;
  dynamic imageFile;
  FacePainter({required this.facesList, @required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }

    Paint p = Paint();
    p.color = Colors.red;
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 3;

    for (Face face in facesList) {
      canvas.drawRect(face.boundingBox, p);
    }

    Paint p2 = Paint();
    p2.color = Colors.green;
    p2.style = PaintingStyle.stroke;
    p2.strokeWidth = 3;

    Paint p3 = Paint();
    p3.color = Colors.yellow;
    p3.style = PaintingStyle.stroke;
    p3.strokeWidth = 1;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
