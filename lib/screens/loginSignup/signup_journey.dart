// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:sachetana_firebase/screens/loginSignup/signup_screen.dart'; // Ensure this import is correct

class SignupJourney extends StatefulWidget {
  const SignupJourney({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<SignupJourney> {
  final LiquidController liquidController = LiquidController();
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    // Initialize pages without using MediaQuery here
    pages = [
      _buildImagePage('assets/images/aggresive.jpg', 'for all\nyour anger\nissues', 'aggressive-nature, frustration and many more'),
      _buildImagePage('assets/images/confusion.jpg', 'for the\nconfused &\ncloudy', "mental confusion or simple last night's hangover"),
      _buildImagePage('assets/images/therapy.jpg', 'who needs\na dedicated listener', 'for all your variety of issues'),
      _buildImagePage('assets/images/ducks.jpg', 'or simply\nsitting ducks', 'monitor your fun'),
    ];
  }

  // Helper method to create an image page with text overlay
  Widget _buildImagePage(String imagePath, String title, String description) {
    return SizedBox(
      height: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Icon(Icons.error)); // Handle image loading errors
            },
          ),
          Builder(
            builder: (context) {
              return Positioned(
                top: MediaQuery.of(context).size.height * 0.55, // Adjust this value as needed
                left: 20, // Shift text to the left
                right: 20,
                bottom: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 55, // Increase font size for title
                        fontFamily: 'DMSerifDisplay',
                      ),
                      textAlign: TextAlign.left, // Align title to the left
                    ),
                    const SizedBox(height: 10), // Space between title and description
                    Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15, // Increase font size for description
                        fontFamily: 'DMSans',
                      ),
                      textAlign: TextAlign.left, // Align description to the left
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Function to navigate to the SignUpModal after a short delay
  void _navigateToSignUpModal() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignUpModal()), // Ensure SignUpModal is defined
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidSwipe(
        pages: pages,
        waveType: WaveType.circularReveal,
        slideIconWidget: const Icon(Icons.arrow_back_ios, color: Colors.white),
        positionSlideIcon: 0.8,
        liquidController: liquidController,
        onPageChangeCallback: (page) {
          // When user reaches the last page, navigate to SignUpModal on the next swipe
          if (page == pages.length - 1) {
            _navigateToSignUpModal(); // Trigger the navigation on the last page
          }
        },
      ),
    );
  }
}
