/* *****************************************************************************
NAME : HARSH KSHIRSAGAR. 
DEADLINE  : 28-10-2024   6.00 PM

figma  :   https://www.figma.com/design/rziJdbQVG6OEmON9guoMuf/KaamKar-UI?node-id=0-1&node-type=canvas&t=DeVmQnJD9nhLG0TK-0 


****************************************************************************** */





import 'package:flutter/material.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  @override
  Widget build(BuildContext context) {
    return  Center( 
      child: Container( 
          width: 300,
          height: 300,
          color: Colors.amber,
      ),
    );
  }
}