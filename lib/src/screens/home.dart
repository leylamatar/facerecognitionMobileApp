import 'package:facerecognition/src/screens/studentregistrationPage.dart';
import 'package:facerecognition/src/screens/studentlist.dart';
import 'package:facerecognition/src/screens/takeattendance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'addstudent.dart';
import '/ML/Recognition.dart';
import 'attendanceSheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  //to save the faces globaly we used map
  static Map<String, Recognition> registered = Map();
  @override
  State<HomePage> createState() => _HomePageState();
}

ButtonStyle sharedButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(
      const Color.fromARGB(255, 255, 255, 255)),
  foregroundColor:
      MaterialStateProperty.all<Color>(const Color.fromARGB(255, 0, 22, 68)),
  padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(15)),
  fixedSize: MaterialStateProperty.all(const Size(290, 60)),
  textStyle: MaterialStateProperty.all<TextStyle>(
    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  ),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
);

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 56, 82),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Welcome',
                  style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.white,
                      fontFamily: 'RobotoMono'),
                ),
                const SizedBox(height: 30.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TakeAttendancePage()),
                    );
                  },
                  style: sharedButtonStyle,
                  child: const Text('Take Attendance'),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const showstudentPage()),
                    );
                  },
                  style: sharedButtonStyle,
                  child: const Text('Student List'),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegistrationPage()),
                    );
                  },
                  style: sharedButtonStyle,
                  child: const Text('Course List/add student'),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AttendanceSheetPage()),
                    );
                  },
                  style: sharedButtonStyle,
                  child: const Text('Attendance Sheet'),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddStudentPage()),
                    );
                  },
                  style: sharedButtonStyle,
                  child: const Text('Add New Student'),
                ),
                const SizedBox(height: 40.0),
                ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 15),
                    backgroundColor: const Color.fromARGB(255, 4, 1, 37),
                  ),
                  child: const Text('Log Out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
