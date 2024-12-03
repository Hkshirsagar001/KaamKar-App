import 'dart:developer'; // For logging
import 'dart:io'; // For File
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'provider_profile.dart'; // Replace with the correct import path

class ProvidersListScreen extends StatefulWidget {
  final String categoryName;

  const ProvidersListScreen({super.key, required this.categoryName});

  @override
  State<ProvidersListScreen> createState() => _ProvidersListScreenState();
}

class _ProvidersListScreenState extends State<ProvidersListScreen> {
  List<Map<String, dynamic>> profiles = [];
  List<Map<String, dynamic>> filteredProfiles = [];
  bool isLoading = true;

  String searchQuery = "";
  int minExperience = 0;

  @override
  void initState() {
    super.initState();
    fetchProfiles(widget.categoryName);
  }

  Future<void> fetchProfiles(String serviceCategory) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('profiles')
          .where('serviceCategory', isEqualTo: serviceCategory)
          .get();

      if (snapshot.docs.isNotEmpty) {
        profiles = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList();

        filteredProfiles = List.from(profiles); // Initialize filtered list
        log("Data fetched successfully. Number of profiles: ${profiles.length}");
      } else {
        log("No profiles found for service category: $serviceCategory");
      }
    } catch (e) {
      log("Error fetching profiles: $e", name: "Firestore Fetch");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterProfiles() {
    filteredProfiles = profiles.where((profile) {
      final fullNameMatches = profile['fullName'] != null &&
          profile['fullName'].toLowerCase().contains(searchQuery.toLowerCase());

      // Extract numeric value from "experience" string
      final experienceString = profile['experience'] ?? "0";
      final experienceValue =
          int.tryParse(experienceString.split(" ").first) ?? 0; // Extract the number part

      final experienceMatches = experienceValue >= minExperience;

      return fullNameMatches && experienceMatches;
    }).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: GoogleFonts.sourceSans3(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFFD7CFFE),
        elevation: 9,
      ),
      backgroundColor: const Color(0xFFFFFFFF),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (query) {
                    searchQuery = query;
                    filterProfiles();
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Search providers...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text("Min Experience:"),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Slider(
                        value: minExperience.toDouble(),
                        min: 0,
                        max: 20,
                        divisions: 20,
                        label: "$minExperience years",
                        onChanged: (value) {
                          minExperience = value.toInt();
                          filterProfiles();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/animations/searching.json',
                            height: 150),
                        const SizedBox(height: 10),
                        Text(
                          "Fetching providers...",
                          style: GoogleFonts.sourceSans3(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  )
                : filteredProfiles.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset('assets/animations/notfound.json',
                                height: 150),
                            const SizedBox(height: 20),
                            Text(
                              "No profiles available",
                              style: GoogleFonts.sourceSans3(
                                fontSize: 18,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredProfiles.length,
                        itemBuilder: (context, index) {
                          final profile = filteredProfiles[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProviderProfile(profile: profile),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFD7CFFE), Color(0xFFCAF0C6)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade400,
                                    blurRadius: 6,
                                    offset: const Offset(2, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Hero(
                                      tag: profile['id'],
                                      child: SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: profile['profileImage'] != null &&
                                                File(profile['profileImage'])
                                                    .existsSync()
                                            ? Image.file(
                                                File(profile['profileImage']),
                                                fit: BoxFit.cover,
                                              )
                                            : const Icon(
                                                Icons.person,
                                                size: 50,
                                                color: Colors.white,
                                              ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          profile['fullName'] ?? 'Unknown',
                                          style: GoogleFonts.sourceSans3(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Experience: ${profile['experience'] ?? '0'}",
                                          style: GoogleFonts.sourceSans3(
                                              fontSize: 14,
                                              color: Colors.black54),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: List.generate(5, (index) {
                                            return Icon(
                                              index < (profile['rating'] ?? 0)
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: Colors.amber,
                                              size: 16,
                                            );
                                          }),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "₹${profile['costPerHour']} / hr",
                                          style: GoogleFonts.sourceSans3(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.green.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
