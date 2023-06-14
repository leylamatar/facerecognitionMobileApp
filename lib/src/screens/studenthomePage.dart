import 'package:flutter/material.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
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
                ]),
          ),
        ),
      ),
    );
  }
}
