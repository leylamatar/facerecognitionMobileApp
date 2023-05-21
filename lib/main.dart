import 'package:camera/camera.dart';
import 'package:facerecognition/src/utils/Theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:facerecognition/src/screens/attendanceWcamera.dart';
import 'src/screens/mainPage.dart';

List<CameraDescription> cameras = [];
void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error in fetching the cameras: $e');
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: TappTheme.lightTheme,
      darkTheme: TappTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MainPage(),
    );
  }
}
