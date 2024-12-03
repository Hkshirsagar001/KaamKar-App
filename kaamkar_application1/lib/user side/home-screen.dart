
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:kaamkar_application1/login_screen.dart';
import 'package:kaamkar_application1/user%20side/profilepage.dart';

import 'notification_screen.dart';
import 'providers_list_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
   late List<Widget> _screens; // Declare as late to initialize later

  @override
void initState() {
  super.initState();
  // Initialize screens that do not depend on BuildContext
  _screens = [
    Container(), // Placeholder for Home content; dynamically returned during build
     const BookingsScreen(),
     const ProfilePage()
  ];
}


  bool _showMore = false;

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: _currentIndex == 0 ? _buildHomeContent() : _screens[_currentIndex],
    bottomNavigationBar: buildBottomNavigationBar(),
  );
}


  Widget _buildHomeContent() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff6D60AF),
            Color(0xffD7CFFE),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              _buildUserProfile(context),
              const SizedBox(height: 20),
              Text(
                "Find suitable services",
                style: GoogleFonts.sourceSans3(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildSectionTitle("Categories"),
              _buildCategoryGrid(),
              const SizedBox(height: 20),
              _buildShowMoreButton(),
              const SizedBox(height: 20),
              _buildSectionTitle("Popular Services"),
              const SizedBox(height: 20),
              _buildPopularServices(),
              const SizedBox(height: 20),
              _buildSectionTitle("Ongoing Deals"),
              _buildCarousel(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ));
          },
          child: Container(
            width: 55,
            height: 55,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage("assets/man.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          widget.username, // Display the username passed from LoginScreen
          style: GoogleFonts.sourceSans3(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationScreen(),
              ),
            );
          },
          child: const Icon(
            Icons.notifications_none_outlined,
            size: 30,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return const TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search, color: Colors.grey),
        hintText: "Search",
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.sourceSans3(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        _buildCategoryContainer("Cleaning", "assets/cleaning.png", () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const ProvidersListScreen(categoryName: "Cleaning"),
            ),
          );
        }),
        _buildCategoryContainer("Electrician", "assets/electrician.png", () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const ProvidersListScreen(categoryName: "Electrician"),
            ),
          );
        }),
        _buildCategoryContainer("Hair & Beauty", "assets/hair.png", () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const ProvidersListScreen(categoryName: "Hair & Beauty"),
            ),
          );
        }),
        if (_showMore) ...[
          _buildCategoryContainer("Plumbing", "assets/plumbing.png", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const ProvidersListScreen(categoryName: "Plumbing"),
              ),
            );
          }),
          _buildCategoryContainer("Carpentry", "assets/hand-saw.png", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const ProvidersListScreen(categoryName: "Carpentry"),
              ),
            );
          }),
          _buildCategoryContainer("Gardening", "assets/trimming.png", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const ProvidersListScreen(categoryName: "Gardening"),
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _buildShowMoreButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showMore = !_showMore;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _showMore ? "Show Less" : "Show More",
            style: GoogleFonts.sourceSans3(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: const Color(0xfFCAF0C6),
            ),
          ),
          Icon(
            _showMore ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: const Color(0xfFCAF0C6),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularServices() {
    return SizedBox(
      height: 220, // Increased height for better spacing
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildServiceCard(
            serviceName: "Home Cleaning",
            providerName: "CleanPro",
            rating: 4.8,
            availability: "Mon-Sat",
            price: 1500,
            imageAsset: "assets/freepik__upload__59570.jpeg", // New image asset
          ),
          _buildServiceCard(
            serviceName: "Plumbing",
            providerName: "FixIt",
            rating: 4.6,
            availability: "24/7",
            price: 1200,
            imageAsset: "assets/freepik__upload__53156.jpeg", // New image asset
          ),
          _buildServiceCard(
            serviceName: "Electrician",
            providerName: "PowerFix",
            rating: 4.9,
            availability: "Sun-Sat",
            price: 1800,
            imageAsset: "assets/freepik__upload__41407.jpeg", // New image asset
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard({
    required String serviceName,
    required String providerName,
    required double rating,
    required String availability,
    required int price,
    required String imageAsset, // Add image parameter
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xffcaf0c6),
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(14)),
                child: Image.asset(
                  imageAsset, // Use the new image asset
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                serviceName,
                style: GoogleFonts.sourceSans3(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                providerName,
                style: GoogleFonts.sourceSans3(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    "$rating",
                    style: GoogleFonts.sourceSans3(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    "₹$price",
                    style: GoogleFonts.sourceSans3(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Availability: $availability",
                style: GoogleFonts.sourceSans3(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return CarouselSlider(
      items: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              "assets/cleanin_Discount.jpeg",
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              "assets/plumbin_Discount.jpeg",
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.8,
        aspectRatio: 16 / 9,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
      ),
    );
  }

  /// Function to build the BottomNavigationBar
  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Bookings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}

Widget _buildCategoryContainer(
    String title, String imagePath, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xfFCAF0C6),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 50,
            height: 50,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.sourceSans3(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xff6D60AF)),
          ),
        ],
      ),
    ),
  );
}


class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  Future<void> _markAsCompleted(String bookingId) async {
    try {
      await FirebaseFirestore.instance
          .collection('service_requests')
          .doc(bookingId)
          .update({'status': 'completed'});
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  Future<void> _provideFeedback(BuildContext context, String bookingId) async {
    TextEditingController feedbackController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Provide Feedback',
            style: TextStyle(color: Color(0xff6D60AF)),
          ),
          content: TextField(
            controller: feedbackController,
            decoration: InputDecoration(
              hintText: 'Enter your feedback here',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xff6D60AF)),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff6D60AF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('service_requests')
                      .doc(bookingId)
                      .update({'feedback': feedbackController.text.trim()});
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Feedback submitted successfully'),
                      backgroundColor: Color(0xff6D60AF),
                    ),
                  );
                } catch (e) {
                  print('Error submitting feedback: $e');
                }
              },
              child: const Text('Submit',style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff6D60AF),
            Color(0xffD7CFFE),
          ],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bookings'),
          backgroundColor: const Color(0xff6D60AF),
        ),
        body: Container(
          color: const Color(0xffB19CD9), // Set the background color here
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('service_requests')
                .where('status', isEqualTo: 'accepted')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xff6D60AF)),
                );
              }
      
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Error fetching bookings'),
                );
              }
      
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No booking found'),
                );
              }
      
              final bookings = snapshot.data!.docs;
      
              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  final data = booking.data() as Map<String, dynamic>;
                  final bookingId = booking.id;
      
                  return Card(
                    margin: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date: ${data['selected_day'] ?? 'N/A'}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff6D60AF),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Slot: ${data['slots'] ?? 'N/A'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Address: ${data['address'] ?? 'N/A'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Contact: ${data['contact'] ?? 'N/A'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 129, 247, 116),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () => _markAsCompleted(bookingId),
                                icon: const Icon(Icons.done, color: Colors.white),
                                label: const Text('Mark as Completed'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffA08ED6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () => _provideFeedback(context, bookingId),
                                icon: const Icon(Icons.feedback, color: Colors.white),
                                label: const Text('Feedback', style: TextStyle(color: Colors.white),),
                              ),
                            ],
                          ),
                          if (data['feedback'] != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Feedback: ${data['feedback']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
