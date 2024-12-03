import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaamkar_application1/provider%20side/manage_avaliability_provider.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController serviceCategoryController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController servicesController = TextEditingController();
  final TextEditingController costController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedFile;

  final _formKey = GlobalKey<FormState>();

  final List<String> serviceCategories = [
    'Cleaning',
    'Plumbing',
    'Electrician',
    'Hair & Beauty',
    
  ];

  String? selectedCategory;

  bool isNewUser = true;

  @override
  void initState() {
    super.initState();
    _fetchIsNewUserFlag();
  }

  Future<void> _fetchIsNewUserFlag() async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get();
      if (userDoc.exists) {
        setState(() {
          isNewUser = userDoc.data()?['isNewUser'] ?? true;
        });
      }
    } catch (e) {
      print('Error fetching isNewUser flag: $e');
    }
  }

  Future<void> _updateIsNewUserFlag() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw 'User not logged in';
      }
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'isNewUser': false,
      });
      print('isNewUser flag updated successfully');
    } catch (e) {
      print('Error updating isNewUser flag: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.grey[100],
      hintText: '',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile Setup',
          style: GoogleFonts.sourceSans3(fontSize: 28, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xffD7CFFE),
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xffD7CFFE),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        _selectedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
                        setState(() {});
                      },
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: const Color(0xffCAF0C6),
                        backgroundImage: _selectedFile != null ? FileImage(File(_selectedFile!.path)) : null,
                        child: _selectedFile == null
                            ? const Icon(Icons.camera_alt, size: 30)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  sectionTitle('Basic Information'),
                  formField('Full Name', 'Enter Your Name', nameController, inputDecoration),
                  const SizedBox(height: 16),
                  dropdownField('Service Category', serviceCategories),
                  const SizedBox(height: 16),
                  formField('Experience', 'e.g., 5+ years', experienceController, inputDecoration),
                  const SizedBox(height: 16),
                  formField('Cost in Rupees per Hour', 'e.g., 500', costController, inputDecoration),
                  const SizedBox(height: 16),
                  formField('About Me/Service', 'Briefly describe your service', servicesController, inputDecoration, maxLines: 3),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                // Save profile to Firestore and get document ID
                                final documentId = await saveProfileToFirestore();

                                // Update 'isNewUser' flag in Firestore
                                await _updateIsNewUserFlag();

                                // Get current user ID
                                final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

                                // Navigate to Manage Availability screen
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => ManageAvailabilityScreen(documentId: documentId, userId: userId),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: const Color(0xffCAF0C6),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Save and Continue',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget formField(String label, String hint, TextEditingController controller, InputDecoration decoration, {int? maxLines}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines ?? 1,
      decoration: decoration.copyWith(
        labelText: label,
        hintText: hint,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget dropdownField(String label, List<String> items) {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      onChanged: (value) {
        setState(() {
          selectedCategory = value;
        });
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100],
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      items: items.map<DropdownMenuItem<String>>((String category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a category';
        }
        return null;
      },
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: GoogleFonts.sourceSans3(fontSize: 24, fontWeight: FontWeight.w500),
      ),
    );
  }

 Future<String> saveProfileToFirestore() async {
  try {
    // Get the current user's UID
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw 'User is not logged in';
    }

    // Update the user's document only for new fields without altering the role
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'name': nameController.text.trim(),
      'email': FirebaseAuth.instance.currentUser?.email ?? '',
      'isNewUser': true, // Set isNewUser flag to true
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true)); // Use merge to avoid overwriting the role

    // Get the reference to the 'profiles' collection using the user's UID
    DocumentReference docRef = FirebaseFirestore.instance.collection('profiles').doc(userId);

    // Prepare the profile data to be saved
    Map<String, dynamic> profileData = {
      'fullName': nameController.text.trim(),
      'serviceCategory': selectedCategory ?? '',
      'experience': experienceController.text.trim(),
      'costPerHour': costController.text.trim(),
      'aboutService': servicesController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
      'serviceRequests': [],
    };

    // If a profile image is selected, add it to the profile data
    if (_selectedFile != null) {
      profileData['profileImage'] = _selectedFile!.path;
    }

    // Save the profile data to Firestore under the user's UID
    await docRef.set(profileData);

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved successfully!')),
    );

    // Return the document ID (which is the same as userId)
    return docRef.id;
  } catch (e) {
    // Show an error message if saving fails
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to save profile: $e')),
    );
    rethrow;
  }
}

}
