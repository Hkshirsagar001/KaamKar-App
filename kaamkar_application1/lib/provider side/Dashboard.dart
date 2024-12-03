import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Dashboard extends StatefulWidget {
  final String userId;

  const Dashboard({super.key, required this.userId});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isLoading = true;
  String? profileImage;
  String? userName;
  String? role;
  String? email;
  String? localProfileImage;

  List<Map<String, dynamic>> upcomingTasks = [];

  Future<void> fetchData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        userName = userData['name'];
        role = userData['role'];
        email = userData['email'];
      }

      DocumentSnapshot profileDoc = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(widget.userId)
          .get();

      if (profileDoc.exists) {
        Map<String, dynamic> profileData =
            profileDoc.data() as Map<String, dynamic>;
        profileImage = profileData['profileImage'];
        localProfileImage = profileImage;
      }

      QuerySnapshot serviceRequests = await FirebaseFirestore.instance
          .collection('service_requests')
          .where('service_provider_id', isEqualTo: widget.userId)
          .where('status', isEqualTo: 'accepted')
          .get();

      if (serviceRequests.docs.isNotEmpty) {
        setState(() {
          upcomingTasks = serviceRequests.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
        });
      }
    } catch (e) {
      print("Failed to fetch data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color(0xffB19CD9),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Section
                  Container(
                    padding: const EdgeInsets.all(16),
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
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: localProfileImage != null &&
                                  File(localProfileImage!).existsSync()
                              ? FileImage(File(localProfileImage!))
                              : null,
                          child: localProfileImage == null ||
                                  !File(localProfileImage!).existsSync()
                              ? const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (userName != null)
                              Text(
                                userName!,
                                style: GoogleFonts.sourceSans3(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            if (role != null)
                              Text(
                                role!,
                                style: GoogleFonts.sourceSans3(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            if (email != null)
                              Text(
                                'Email: $email',
                                style: GoogleFonts.sourceSans3(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Upcoming Tasks Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Upcoming Tasks",
                          style: GoogleFonts.sourceSans3(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (upcomingTasks.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: upcomingTasks.length,
                            itemBuilder: (context, index) {
                              var task = upcomingTasks[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task['user_name'] ?? 'Unknown',
                                        style: GoogleFonts.sourceSans3(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Date: ${task['selected_day'] ?? 'N/A'}',
                                            style: GoogleFonts.sourceSans3(
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Slot: ${task['slots'] ?? 'N/A'}',
                                            style: GoogleFonts.sourceSans3(
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.phone,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Contact: ${task['contact'] ?? 'N/A'}',
                                            style: GoogleFonts.sourceSans3(
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Address: ${task['address'] ?? 'N/A'}',
                                              style: GoogleFonts.sourceSans3(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        else
                          Column(
                            children: [
                              Lottie.asset( 
                                "assets/animations/notfound.json"
                              ),
                              const Text( 
                                "No upcoming tasks",style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18
                                ),
                              )
                            ],
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
