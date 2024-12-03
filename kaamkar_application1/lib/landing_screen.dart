import 'package:flutter/material.dart';

import 'on_boarding.dart';



class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  // Animation controller to manage the animation state
  late AnimationController _controller;
  // Animation to control the fade-in effect
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller with a 3-second duration
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    // Create a fade-in animation with an ease-in curve for smooth appearance
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // Start the animation as soon as the screen is loaded
    _controller.forward();

    // Add a listener to navigate to the next page when animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //Navigate to the next screenafter the animation completes
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    // Dispose of the controller to free resources when widget is removed from the tree
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove backgroundColor, as we’ll use a gradient instead
      body: Container(
        // Apply a linear gradient background from teal to dark teal
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xffD7CFFE),
              Color(0xff6D60AF),    
              // Teal color
              // Color.fromARGB(255, 2, 46, 39),  // Dark teal color
            ],
          ),
        ),
        child: Center(
          // Center the content in the middle of the screen
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Apply fade-in effect to the logo
              FadeTransition(
                opacity: _animation, // Connect the opacity to the animation
                child: SizedBox(
                  width: 300, // Set logo width
                  height: 300, // Set logo height
                  child: Image.asset("assets/kaamkar-high-resolution-logo-transparent.png"), // Load logo asset
                ),
              ),
              const SizedBox(height: 20), // Add space between logo and tagline
              // Apply fade-in effect to the tagline
              FadeTransition(
                opacity: _animation, // Connect the opacity to the animation
                child: const Text(
                  'Expert Help, Just a Tap Away!', // Tagline text
                  style: TextStyle(
                    fontSize: 24, // Text size
                    color: Color(0xFFCAF0C6), // White text color for contrast
                    fontWeight: FontWeight.w300, // Light font weight for style
                    letterSpacing: 1.2, // Slight spacing for readability
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

