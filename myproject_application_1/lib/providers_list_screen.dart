import 'package:flutter/material.dart';

import 'provider_profile.dart';

class ProvidersListScreen extends StatefulWidget {
  final String categoryName; // Accept categoryName as a parameter

  const ProvidersListScreen({super.key, required this.categoryName});

  @override
  State<ProvidersListScreen> createState() => _ProvidersListScreenState();
}

class _ProvidersListScreenState extends State<ProvidersListScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName), // Use the passed categoryName
      ),
      body: ListView.builder( 
        itemCount: 5,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push( 
                MaterialPageRoute(builder:(context){ 
                  return const ProviderProfile(); 
                })
              );
            },
            child: Container( 
              margin: const EdgeInsets.all(10),
              width: 300,
              height: 200,
              // color: Colors.amber,
              decoration: BoxDecoration( 
                color: Colors.amber,
                borderRadius: BorderRadius.circular(14)
              ),
              child: Row( 
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [ 
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset( 
                          "assets/man.png"
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Column( 
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [ 
                        Text("Pablo Escobar"),
                        Text("Jobs : 20"),
                     
                        Text("Rating * 4.9")
                    
                      ],
                    ),
                  )
            
                ],
              ),
              
            ),
          );
        },
      )
    );
  }
}
