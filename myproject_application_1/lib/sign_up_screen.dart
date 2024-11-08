import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myproject_application_1/home-screen.dart';



class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool rememberMe = false;
  bool isObscure = true; // Controls password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Sign In",
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 32, // Title font size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox( 
                          height: 10,
                        ),
                        Text(
                          "Welcome Back!",
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 28, // Subtitle font size
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "To keep connected with us, please login with your personal info",
                          style: GoogleFonts.lato(
                            color: Colors.grey,
                            fontSize: 16, // Body text font size
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.02),
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.25),
                                  offset: const Offset(0, 4),
                                  
                                ),
                              ],
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Email Address",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.all(16.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                           color: Colors.grey.withOpacity(0.02),
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.25),
                                offset: const Offset(0, 4),
                                
                              ),
                            ],
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Password",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isObscure ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isObscure = !isObscure;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.all(16.0),
                            ),
                            obscureText: isObscure,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Transform.scale(
                              scale: 1.4, // Increase the size of the checkbox by 40%
                              child: Checkbox(
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value ?? false;
                                  });
                                },
                              ),
                            ),
                             Text("Remember me",
                            style: GoogleFonts.lato()),
                            const Spacer(),
                            TextButton(
                              onPressed: () {},
                              child:  Text(
                                "Forgot Password",
                                style: GoogleFonts.lato( 
                                  color: Colors.teal
                                ),
                                // style: TextStyle(
                                //   color: Colors.teal,
                                // ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () { 
                                //sign in button
                               Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder:(context){ 
                                  return const HomeScreen();
                                }),
                                (route){ 
                                  return false;
                                }
                               );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                fixedSize: const Size(340, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 8, // Adding shadow
                              ),
                              child: Text(
                                "Sign In",
                                style: GoogleFonts.lato(
                                  fontSize: 20, // Button text font size
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                              ),
                              Text(
                                "OR CONNECT WITH",
                                style: GoogleFonts.lato(
                                  color: Colors.grey,
                                  fontSize: 14, // Small label font size
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 300,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      offset: const Offset(0, 4),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: SignInButton(
                                  Buttons.Google,
                                  onPressed: () {},
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                width: 300,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      offset: const Offset(0, 4),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: SignInButton(
                                  Buttons.FacebookNew,
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
