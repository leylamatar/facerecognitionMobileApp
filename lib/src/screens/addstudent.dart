import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}
//not using this file 
class _AddStudentPageState extends State<AddStudentPage> {
  var globalKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _emailController = TextEditingController();


  CollectionReference students =
      FirebaseFirestore.instance.collection('students');

  void adddata() async {
    final imgurl = await uploadImage(image!);
    await students.add({
      "id": _idController.text.trim(),
      "Name": _nameController.text.trim(),
      "Email": _emailController.text.trim(),
      "Profile Picture": imgurl,
    }).whenComplete(() => displayMessage('new data added successfully'));
  }

  displayMessage(String message) {
    Fluttertoast.showToast(msg: message);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _idController.dispose();
    super.dispose();
  }

  File? image;
  late String downloadUrl;
  Future imagePicker() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print('Failed to pick image : $e');
    }
  }

  Future uploadImage(File image) async {
    String url;
    String imgId = DateTime.now().microsecondsSinceEpoch.toString();
    Reference reference =
        FirebaseStorage.instance.ref().child('images/').child('users$imgId');
    await reference.putFile(image);
    url = await reference.getDownloadURL();
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 56, 82),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 14, 56, 90),
        title: Text("Add Student "),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: [
                const SizedBox(height: 20),
                //başlık
                const Text(
                  "ADD NEW STUDENT",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      image != null
                          ? ClipOval(
                              child: Image.file(
                                image!,
                                width: 160,
                                height: 160,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset("assets/images/profile.png"),
                      const SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: () {
                            imagePicker().whenComplete(() {
                              uploadImage(image!);
                            });
                          },
                          child: const Text("Select image"))
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                //name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black12,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Student Name',
                      fillColor: const Color.fromARGB(255, 244, 247, 248),
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                //student id
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    controller: _idController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black12,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Student Id',
                      fillColor: const Color.fromARGB(255, 244, 247, 248),
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                //student email
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black12,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Student Email',
                      fillColor: const Color.fromARGB(255, 244, 247, 248),
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () {
                      adddata();
                    },
                    child: const Text('Add Data'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
