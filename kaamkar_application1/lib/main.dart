import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kaamkar_application1/landing_screen.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


dynamic globalDatabase;
dynamic dataEntryID;  

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: const FirebaseOptions(apiKey: "", appId: "", messagingSenderId: ":::", projectId: "-"));
    log("Firebase successfully!");
     globalDatabase = await openDatabase( 
   join(await getDatabasesPath(),"firebaseDB.db"),
   version: 1,
   onCreate: (db, version) {
     db.execute( 
      ''' 
        CREATE TABLE firebaseData( 

          uid INT PRIMARY KEY, 
          userame TEXT,
          providerName TEXT,
          slot TEXT,
          status TEXT,

        )
      '''
     );
   }
  ); 
    log("sqflite successfully!");
  } catch (e) {
    print("Firebas ecxeption: $e");
  }
   
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingScreen()
    );
  }
}
