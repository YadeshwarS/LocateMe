import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'FacultyPage.dart';
import 'loginpage.dart';
import 'onboardingScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/faculty': (context) => FacultyPage(),
        '/login': (context) => loginpage(),
      },
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}
