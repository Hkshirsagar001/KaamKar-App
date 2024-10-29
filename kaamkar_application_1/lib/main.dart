import 'package:flutter/material.dart';
import 'screen1.dart';
import 'screen2.dart';
import 'screen3.dart';
import 'screen4.dart';
import 'screen5.dart';
import 'screen6.dart';
<<<<<<< HEAD
import 'screen7.dart';
=======
import 'Screen7.dart';

>>>>>>> 7ddaaccc43530411b5007de04929d61d9d63f77f
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
<<<<<<< HEAD
      debugShowCheckedModeBanner: false,
      home: Scaffold( 
        body: Screen6(),       // create object of your class 
=======
      home: Scaffold(
        body: Screen1(), // create object of your class
>>>>>>> 7ddaaccc43530411b5007de04929d61d9d63f77f
      ),
    );
  }
}
