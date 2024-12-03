import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

import 'schedule_screen.dart';

class ProviderProfile extends StatefulWidget {
  final Map<String, dynamic> profile;

  const ProviderProfile({super.key, required this.profile});

  @override
  State<ProviderProfile> createState() => _ProviderProfileState();
}

class _ProviderProfileState extends State<ProviderProfile> {
  final List<Map<String, String>> dummyReviews = [
    {
      'reviewer': 'John Doe',
      'review': 'Great service! Very professional and punctual.',
      'rating': '4.5'
    },
    {
      'reviewer': 'Jane Smith',
      'review': 'Excellent work. Highly recommended!',
      'rating': '5.0'
    },
    {
      'reviewer': 'Chris Brown',
      'review': 'Good, but there’s room for improvement.',
      'rating': '3.8'
    },
    {
      'reviewer': 'Alice Johnson',
      'review': 'Very satisfied with the service provided.',
      'rating': '4.7'
    },
  ];

  bool _isExpanded = false; // Track if reviews section is expanded

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;

    return Scaffold(
      body: Stack(
        children: [
          // Profile Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: profile['profileImage'] != null &&
                          File(profile['profileImage']).existsSync()
                      ? FileImage(File(profile['profileImage']))
                      : const AssetImage('assets/images/default_avatar.png')
                          as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
          ),

          // Back and Favorite Buttons
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.white),
              onPressed: () {
                // Add to favorite functionality
              },
            ),
          ),

          // Profile Details
          Positioned(
            top: 230,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xffD7CFFE),
                    Color(0xff6D60AF),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 5,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name & Service
                    Text(
                      profile['fullName'] ?? "Unknown",
                      style: GoogleFonts.sourceSans3(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile['serviceCategory'] ?? "Service",
                      style: GoogleFonts.sourceSans3(
                        fontSize: 18,
                        color: Colors.grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Stats Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoCard(
                          icon: Icons.money,
                          value: "₹${profile['costPerHour'] ?? '0'}/hr",
                          label: "Cost",
                          color: Colors.pink.shade400,
                        ),
                        _buildInfoCard(
                          icon: Icons.task_alt,
                          value: "${profile['jobsCompleted'] ?? '2'}",
                          label: "Jobs",
                          color: Colors.green.shade500,
                        ),
                        _buildInfoCard(
                          icon: Icons.star,
                          value: "${profile['rating'] ?? '3.0'}",
                          label: "Rating",
                          color: Colors.amber.shade500,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Bio Section
                    _buildSectionTitle("Bio"),
                    const SizedBox(height: 8),
                    _buildBioSection(profile['aboutService']),

                    const SizedBox(height: 16),

                    // Reviews Section
                    _buildSectionTitle("Reviews (${dummyReviews.length})"),
                    const SizedBox(height: 8),
                    // Display reviews based on expanded/collapsed state
                    Column(
                      children: (_isExpanded
                              ? dummyReviews
                              : dummyReviews.take(2))
                          .map((review) {
                        return _buildReviewCard(review);
                      }).toList(),
                    ),

                    // Expand/Collapse Button
                    if (dummyReviews.length > 2)
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _isExpanded = !_isExpanded; // Toggle state
                            });
                          },
                          child: Text(
                            _isExpanded ? "Show Less" : "View All Reviews",
                            style: GoogleFonts.sourceSans3(
                                fontSize: 16, color: Colors.blue),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Floating Action Button
     floatingActionButton: FloatingActionButton.extended(
  onPressed: () {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ScheduleScreen(profile: widget.profile),
    ));
  },
  backgroundColor: const Color(0xffcaf0c6),
  icon: const Icon(Icons.schedule),
  label: const Text(
    "Schedule Now",
    style: TextStyle(color: Colors.deepPurple),
  ),
  elevation: 10, // Add elevation for shadow
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
    side: const BorderSide(
      color: Colors.deepPurple, // Border color
      width: 2, // Border width
    ),
  ),
),

    );
  }

  // Helper to build info cards
  Widget _buildInfoCard(
      {required IconData icon,
      required String value,
      required String label,
      required Color color}) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 2,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.sourceSans3(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.sourceSans3(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build bio section
  Widget _buildBioSection(String? bio) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReadMoreText(
          bio ?? "No bio available.",
          trimLines: 2,
          trimMode: TrimMode.Length,
          trimCollapsedText: ' Read more',
          trimExpandedText: ' Read less',
          moreStyle: TextStyle(color: Colors.blue.shade700),
          lessStyle: TextStyle(color: Colors.blue.shade700),
        ),
      ),
    );
  }

  // Helper to build review cards
  Widget _buildReviewCard(Map<String, String> review) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple,
          child: Text(
            review['reviewer']![0],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          review['reviewer']!,
          style: GoogleFonts.sourceSans3(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(review['review']!),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.amber),
            Text(
              review['rating']!,
              style: GoogleFonts.sourceSans3(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build section titles
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.sourceSans3(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }
}
