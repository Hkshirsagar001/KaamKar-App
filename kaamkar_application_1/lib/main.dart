import 'package:flutter/material.dart';
import 'package:kaamkar_application_1/screen1.dart';
import "screen2.dart";
import 'screen3.dart';
import 'screen4.dart';
import 'screen5.dart';
import 'screen6.dart';
import './Screen7.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Screen1(), // create object of your class
      ),
    );
  }
}
