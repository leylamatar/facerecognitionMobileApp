import 'package:facerecognition/src/utils/color_utils.dart';
import 'package:facerecognition/src/widgets/widgets.dart';

import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            hexStringToColor("08596A"),
            hexStringToColor("287F9A"),
            hexStringToColor("549DB4")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            
            mainAxisAlignment: MainAxisAlignment.start,
            
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 180,
                height: 200,
              ),
              const SizedBox(
                height: 10,
              ),
              
              const Text.rich(
                TextSpan(
                  text: 'TAKE ATTENDANCE WITH FACE ID \n',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Welcome back ! Login with your account',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              reusableTextField(
                "Enter User Name",
                Icons.person_outline,
                false,
                _emailTextController,
              ),
              const SizedBox(
                height: 20,
                
              ),
              reusableTextField(
                "Enter User password",
                Icons.lock_outline,
                true,
                _passwordTextController,
              )
            ],
          ),
        ),
      ),
    );
  }
}
