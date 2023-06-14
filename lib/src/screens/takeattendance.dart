import 'dart:io';
import 'package:excel/excel.dart';
import 'package:facerecognition/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
//import 'package:intl/intl.dart';
import '../../ML/Recognition.dart';
import '/ML/Recognizer.dart';
import 'attendanceSheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class TakeAttendancePage extends StatefulWidget {
  const TakeAttendancePage({super.key});

  @override
  State<TakeAttendancePage> createState() => _TakeAttendancePageState();
}

class _TakeAttendancePageState extends State<TakeAttendancePage> {
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

  String _getFormattedDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void saveAttendanceToSheet(List<Recognition> recognitions) async {
    Directory? appDocumentsDirectory;
    if (Platform.isAndroid || Platform.isIOS) {
      appDocumentsDirectory = await getApplicationDocumentsDirectory();
    } else {
      // Handle other platforms as needed
    }

    if (appDocumentsDirectory != null) {
      final currentDate = _getFormattedDate(DateTime.now());
      final filePath =
          '${appDocumentsDirectory.path}/attendance_$currentDate.csv';
      final file = File(filePath);

      // Check if the file with today's date already exists
      if (!await file.exists()) {
        // Create a new file with the header
        await file.writeAsString('Name,Date\n');
      }

      String csvContent = '';

      // Append the new attendance data to the content
      for (Recognition recognition in recognitions) {
        if (recognition.name != 'Unknown') {
          csvContent += '${recognition.name},$currentDate\n';
        }
      }

      try {
        // Write the attendance data to the file
        await file.writeAsString(csvContent, mode: FileMode.append);
        print('Attendance saved successfully.');
        print('File path: $filePath');
      } catch (e) {
        print('Failed to save attendance: $e');
      }
    }
  }

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

//make a list for recognized faces
  List<Recognition> recognitions = [];
  //crop faces
  performFaceREcognition() async {
    _image = await removeRotation(_image!);
    //conver image to byts
    image = await _image?.readAsBytes();
    image = await decodeImageFromList(image);
    //
    recognitions.clear();
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
          recognizer.recognize(imgFace!, face.boundingBox); //comparing faces
      if (recognition.distance > 1) {
        recognition.name = "Unknown";
      }
      recognitions.add(recognition);
      saveAttendanceToSheet(recognitions);
      print(recognition.name + " " + recognition.distance.toString());
    }

    setState(() {
      _image;
    });
    drawRectangleAroundFaces();
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
      recognitions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 24, 56, 82),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 14, 56, 90),
        title: const Text("Take Attendance"),
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
                        painter: FacePainter(
                            facesList: recognitions, imageFile: image),
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
  List<Recognition> facesList;
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

    for (Recognition face in facesList) {
      canvas.drawRect(face.location, p);

      TextSpan span = TextSpan(
          style: TextStyle(color: Colors.white, fontSize: 50),
          text: "${face.name} ${face.distance.toStringAsFixed(2)} ");
      TextPainter painter = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      painter.layout();
      painter.paint(canvas, Offset(face.location.left, face.location.top));
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
