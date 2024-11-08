import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticket_clippers/ticket_clippers.dart';

class Trial extends StatefulWidget {
  const Trial({super.key});

  @override
  State<Trial> createState() => _TrialState();
}

class _TrialState extends State<Trial> {
  @override
  Widget build(BuildContext context) {
    return Column( 
      mainAxisAlignment: MainAxisAlignment.center,
      children: [ 
        Center(
          child: TicketClipper(
            clipper: TicketRoundedEdgeClipper( 
              edge: Edge.horizontal,
              position: 100,
              radius: 25
            ),
            child:Container( 
              width: 350,
              height: 200,
              color: Colors.amber,
              child: Row( 
                children: [ 
                  TicketClipper(
                    clipper: PointedEdgeClipper(
                      edge: Edge.right,
                      points: 10,
                      depth: 5
                    ),
                    child: Container( 
                      width: 105,
                      height: 200,
                      color: Colors.white,
                      child: Center(
                        child: Transform.rotate(
                          angle: pi/2,
                          child: Text( 
                            "30%",
                            style: GoogleFonts.lato( 
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.red
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container()
                ],
              ),
            )
          )
        )
      ],
    );
  }
}