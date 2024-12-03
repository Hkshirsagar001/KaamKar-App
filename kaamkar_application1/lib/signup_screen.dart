import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaamkar_application1/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isObscure = true; // Controls password visibility

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  String selectedRole = 'User'; // Default role
  final _formKey = GlobalKey<FormState>(); // Form validation key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffD7CFFE),
              Color(0xff6D60AF),
            ],
            begin: Alignment.topRight,
            end: Alignment.topLeft,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 60),
                child: Text(
                  "Sign up",
                  style: GoogleFonts.sourceSans3(
                    color: const Color(0xffcaf0c6),
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
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
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey, // Added form key
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              "Create Account",
                              style: GoogleFonts.sourceSans3(
                                color: Colors.black,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Fill in the details below to create an account",
                              style: GoogleFonts.sourceSans3(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 20),
                            buildTextField(
                              _nameTextEditingController,
                              "Full Name",
                              false,
                              (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your full name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            buildTextField(
                              _emailTextEditingController,
                              "Email Address",
                              false,
                              (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                } else if (!RegExp(
                                        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            buildTextField(
                              _passwordTextEditingController,
                              "Password",
                              true,
                              (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                } else if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: Text(
                                "Select Role",
                                style: GoogleFonts.sourceSans3(
                                  color: Colors.grey[700],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(child: buildRoleSelector()),
                            const SizedBox(height: 20),
                            buildSignupButton(),
                          ],
                        ),
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
      TextEditingController controller, String hintText, bool isPassword, String? Function(String?) validator) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.80),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
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

  Widget buildRoleSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.40),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ToggleButtons(
        isSelected: [selectedRole == 'User', selectedRole == 'Service Provider'],
        onPressed: (index) {
          setState(() {
            selectedRole = index == 0 ? 'User' : 'Service Provider';
          });
        },
        color: Colors.black,
        selectedColor: Colors.white,
        fillColor: const Color(0xff6D60AF),
        borderRadius: BorderRadius.circular(8),
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text('User'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Service Provider'),
          ),
        ],
      ),
    );
  }

  Widget buildSignupButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xff6D60AF),
                Color.fromARGB(255, 180, 166, 241),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                try {
                  // Create user in Firebase Authentication
                  UserCredential userCredential =
                      await _firebaseAuth.createUserWithEmailAndPassword(
                    email: _emailTextEditingController.text.trim(),
                    password: _passwordTextEditingController.text.trim(),
                  );

                  // Add user data to Firestore, including isNewUser flag
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userCredential.user?.uid)
                      .set({
                    'name': _nameTextEditingController.text.trim(),
                    'email': _emailTextEditingController.text.trim(),
                    'role': selectedRole,
                    'isNewUser': true, // Set isNewUser flag to true
                    'createdAt': Timestamp.now(),
                  });

                  // Show success snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Signed up successfully!')),
                  );

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                  print("Signed up successfully: ${userCredential.user?.email}");
                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.message}')),
                  );
                } catch (e) {
                  print("Error saving data: $e");
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              fixedSize: const Size(340, 50),
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              "Sign Up",
              style: GoogleFonts.sourceSans3(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
