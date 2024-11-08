import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myproject_application_1/service_card.dart';
import 'providers_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showMore = false; // Track the visibility of additional categories

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Row(
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    " John Doe",
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.notifications_none_outlined,
                    size: 40,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Find suitable services",
                  style: GoogleFonts.lato(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search",
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Categories",
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Category section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCategoryContainer("Cleaning", "assets/cleaning.png", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProvidersListScreen(categoryName: "Cleaning"),
                      ),
                    );
                  }),
                  _buildCategoryContainer("Electrician", "assets/electrician.png", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProvidersListScreen(categoryName: "Electrician"),
                      ),
                    );
                  }),
                  _buildCategoryContainer("Hair & Beauty", "assets/hair.png", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProvidersListScreen(categoryName: "Hair & Beauty"),
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 10),
              // Additional categories row, visible when _showMore is true
              if (_showMore)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCategoryContainer("Plumbing", "assets/plumbing.png", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProvidersListScreen(categoryName: "Plumbing"),
                        ),
                      );
                    }),
                    _buildCategoryContainer("Carpentry", "assets/hand-saw.png", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProvidersListScreen(categoryName: "Carpentry"),
                        ),
                      );
                    }),
                    _buildCategoryContainer("Gardening", "assets/trimming.png", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProvidersListScreen(categoryName: "Gardening"),
                        ),
                      );
                    }),
                  ],
                ),
              const SizedBox(height: 10),
              // Show More button
              GestureDetector(
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
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.teal,
                      ),
                    ),
                    Icon(
                      _showMore
                          ? Icons.keyboard_arrow_up_outlined
                          : Icons.keyboard_arrow_down_outlined,
                      color: Colors.teal,
                    ),
                  ],
                ),
              ),
              Text(
                "Popular Services",
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 179,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: const [
                    ServiceCard(
                      serviceName: "Home Cleaning",
                      providerName: "CleanPro",
                      rating: 4.8,
                      availability: "Mon-Sat",
                      price: 1500,
                    ),
                    ServiceCard(
                      serviceName: "Plumbing",
                      providerName: "FixIt",
                      rating: 4.6,
                      availability: "24/7",
                      price: 1200,
                    ),
                    ServiceCard(
                      serviceName: "Electrician",
                      providerName: "PowerFix",
                      rating: 4.9,
                      availability: "Sun-Sat",
                      price: 1800,
                    ),
                    ServiceCard(
                      serviceName: "Carpentry",
                      providerName: "WoodCraft",
                      rating: 4.5,
                      availability: "Weekdays",
                      price: 2000,
                    ),
                  ],
                ),
              ),
              // Ticket Carousel
              CarouselSlider(
                items: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset("assets/Screenshot (172).png"),
                  )
                ],
                options: CarouselOptions()
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // Helper method to build a category container with specified text and image
  Widget _buildCategoryContainer(String title, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap, // Call the onTap function passed as an argument
      child: Column(
        children: [
          Container(
            width: 109,
            height: 101,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: Colors.teal[100],
            ),
            child: Center(
              child: SizedBox(
                width: 50, // Adjust width and height to fit your image
                height: 50,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Container(
            width: 109,
            height: 39,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              color: Colors.teal[700],
            ),
            child: Center(
              child: Text(
                title,
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
