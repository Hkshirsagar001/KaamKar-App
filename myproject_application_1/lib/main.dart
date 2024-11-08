import 'package:flutter/material.dart';
import 'package:myproject_application_1/landing_screen.dart';
// import 'package:myproject_application_1/trial_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold( 
        // backgroundColor: Colors.black,
        body:LandingScreen()
      ),
    );
  }
}
