import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaamkar_application1/provider%20side/drower.dart';

import 'signup_screen.dart'; // Replace with actual path
import 'user side/home-screen.dart'; // Replace with actual path
import 'provider side/provider_Info_screen.dart'; // Replace with actual path

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isObscure = true; // Controls password visibility
  bool isLoading = false; // Controls loading indicator
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  void toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void showSnackbar(String message, {Color backgroundColor = Colors.red}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16.0),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool validateFields() {
    if (_emailTextEditingController.text.trim().isEmpty) {
      showSnackbar("Email is required");
      return false;
    }
    if (!_emailTextEditingController.text.contains('@')) {
      showSnackbar("Enter a valid email address");
      return false;
    }
    if (_passwordTextEditingController.text.trim().isEmpty) {
      showSnackbar("Password is required");
      return false;
    }
    if (_passwordTextEditingController.text.length < 6) {
      showSnackbar("Password must be at least 6 characters");
      return false;
    }
    return true;
  }

  Future<void> loginUser() async {
    if (!validateFields()) return;

    toggleLoading();
    try {
      // Sign in user
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: _emailTextEditingController.text.trim(),
        password: _passwordTextEditingController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        // Fetch user data from Firestore
        DocumentSnapshot userDoc = await _firebaseFirestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          log("User document: ${userDoc.data()}");

          String role = userDoc['role'];
          String username = (userDoc['name'] as String?) ?? "User"; // Handle null
          bool isNewUser = userDoc['isNewUser'] ?? true;

          log("User role: $role, isNewUser: $isNewUser");

          Future.delayed(const Duration(milliseconds: 200), () {
            if (role == 'User') {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => HomeScreen(username: username)),
              );
            } else if (role == 'Service Provider') {
              if (isNewUser) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const ProfileSetupScreen()),
                );
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => MenuScreen(userId: user.uid)),
                        // builder: (context) => Dashboard(userId: user.uid)),
                );
              }
            } else {
              showSnackbar("Unknown role: $role");
            }
          });

          showSnackbar("Login successful!", backgroundColor: Colors.green);
        } else {
          showSnackbar("User not found in Firestore");
        }
      }
    } on FirebaseAuthException catch (e) {
      showSnackbar(e.message ?? "Authentication error");
    } catch (e) {
      showSnackbar("An unexpected error occurred: $e");
    } finally {
      toggleLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xffB19CD9), // Soft lavender
                    Color(0xff6D60AF), // Dark purple
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 120,),
                    Center(
                      child: SizedBox(
                        width: 230,
                        child: Image.asset(
                          "assets/kaamkar-high-resolution-logo-transparent.png"
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            color: Color.fromARGB(255, 255, 251, 251),
                          ),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  "Welcome Back!",
                                  style: GoogleFonts.sourceSans3(
                                    color: Colors.black,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "To keep connected with us, please login with your personal info",
                                  style: GoogleFonts.sourceSans3(
                                    color: Colors.grey[700],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                buildTextField(
                                  _emailTextEditingController,
                                  "Email Address",
                                  false,
                                ),
                                const SizedBox(height: 10),
                                buildTextField(
                                  _passwordTextEditingController,
                                  "Password",
                                  true,
                                ),
                                const SizedBox(height: 10),
                                buildLoginButton(),
                                buildSignupPrompt(context),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildTextField(
      TextEditingController controller, String hintText, bool isPassword) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(16.0),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                )
              : null,
        ),
        obscureText: isPassword && isObscure,
      ),
    );
  }

  Widget buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Center(
        child: ElevatedButton(
          onPressed: loginUser,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff6D60AF),
            elevation: 6,
            shadowColor: Colors.black38,
            fixedSize: const Size(340, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            "Login",
            style: GoogleFonts.sourceSans3(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSignupPrompt(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const SignupScreen()),
        );
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Don’t have an account?",
                  style: GoogleFonts.sourceSans3(fontSize: 18),
                ),
                TextSpan(
                  text: " Sign up",
                  style: GoogleFonts.sourceSans3(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff6D60AF),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
