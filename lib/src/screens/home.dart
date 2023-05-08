import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'addstudent.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

ButtonStyle sharedButtonStyle = ButtonStyle(
  backgroundColor:
      MaterialStateProperty.all<Color>(Color.fromARGB(255, 255, 255, 255)),
  foregroundColor:
      MaterialStateProperty.all<Color>(Color.fromARGB(255, 0, 22, 68)),
  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
  fixedSize: MaterialStateProperty.all(Size(290, 60)),
  textStyle: MaterialStateProperty.all<TextStyle>(
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          padding: EdgeInsets.only(top: 30),
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
                SizedBox(height: 30.0),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Take Attendance'),
                  style: sharedButtonStyle,
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Student List'),
                  style: sharedButtonStyle,
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Course List'),
                  style: sharedButtonStyle,
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Attendance Sheet'),
                  style: sharedButtonStyle,
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddStudentPage()),
                    );
                  },
                  child: Text('Add New Student'),
                  style: sharedButtonStyle,
                ),
                SizedBox(height: 40.0),
                ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  child: Text('Log Out'),
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 15),
                    backgroundColor: Color.fromARGB(255, 4, 1, 37),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
