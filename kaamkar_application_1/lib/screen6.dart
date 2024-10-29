/* *****************************************************************************
NAME : AMIT KHAMKAR & MAHESH KHAMKAR. 
DEADLINE  : 28-10-2024   6.00 PM

figma  :   https://www.figma.com/design/rziJdbQVG6OEmON9guoMuf/KaamKar-UI?node-id=0-1&node-type=canvas&t=DeVmQnJD9nhLG0TK-0 


****************************************************************************** */

import 'package:flutter/material.dart';

// ignore: camel_case_types
class kaamkarApp{
  int number;
  kaamkarApp({required this.number});
}
class Screen6 extends StatefulWidget {
  const Screen6({super.key});

  @override
  State<Screen6> createState() => _Screen6State();
}

class _Screen6State extends State<Screen6> {
  Color buttonColor=Colors.grey; final TextEditingController _controller = TextEditingController();
  bool isButtonEnabled = false;

  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        isButtonEnabled = _controller.text.length == 10;
      });
    });
  }
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  void _login() {
    // Logic for login action
    print("Login/Sign up clicked with number: ${_controller.text}");
  }
  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Center(
      child:Column(
        children: [
          SizedBox(  
            width: 375,
            height:422,
            child:Image.asset(
              "assets/logo.png",
            ),
          ),
          TextField(
                controller: _controller,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  prefixText: '+91 ',
                  hintText: 'Mobile Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              
              // Information Text
              const Text(
                'An OTP will be sent on the given phone number for verification. Standard message and data rates apply.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              
              // Login/Sign Up Button
              ElevatedButton(
                onPressed: isButtonEnabled ? _login : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isButtonEnabled ? Colors.blue : Colors.grey,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Login/Sign up'),
              ),
            ],
          /*Center(
            child: TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon:const Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text(
                    '+91',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                hintText: 'Mobile Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              controller:numberController,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'An OTP will be sent on given phone number for verification.\nStandard message and data rates apply.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey, fontSize: 12),
          ),
          SizedBox(height: 20),
            // Login/Sign up Button
          ElevatedButton(
            onPressed: () {},
            style:ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text('Login/Sign up'),
          ),*/
      ),
    );
  } 
}

//color:Color.fromARGB(1,121,116,126),
=======
    return const Placeholder();
  }
}
>>>>>>> 7ddaaccc43530411b5007de04929d61d9d63f77f
