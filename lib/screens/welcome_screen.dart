import 'package:flutter/material.dart';
import 'package:sachetana_firebase/screens/loginSignup/signup_screen.dart';
import 'getting_started_modal.dart'; // Import your modal here

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/mainbg.png'), // Replace with your actual image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sachetana text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  'Sachetana',
                  style: TextStyle(
                    fontFamily: 'Tangerine',
                    color: Colors.white,
                    fontSize: 90,


                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  '- we will do our best so that\nyou can make the best of your time',
                  textAlign: TextAlign.left, // Aligning subtext to left
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 16,
                    fontFamily: 'DMSans'
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Buttons: About Us and Get Started
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // About Us button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/about'); // Replace with your about route
                    },
                    child: Text('About Us', style: TextStyle(color: Colors.white, fontFamily: 'DMSans')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    ),
                  ),
                  SizedBox(width: 20),
                  // Get Started button
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return GettingStartedModal(); // The modal defined in getting_started_modal.dart
                        },
                      );
                    },
                    child:
                    Text('Getting Started', style: TextStyle(color: Colors.white, fontFamily: 'DMSans')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: EdgeInsets.symmetric(horizontal: 40,  vertical: 20),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40), // Space at the bottom
            ],
          ),
          // Circular Logos on the top left corner
          Positioned(
            top: 70, // Adjust as needed
            left: 30, // Adjust as needed
            child: Row(
              children: [
                ClipOval( // Circular logo for the first logo
                  child: Image.asset(
                    'assets/images/gerbera.png', // Replace with your actual logo path
                    height: 50, // Adjust size as needed
                    width: 50, // Adjust size as needed
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 15), // Space between logos
                ClipOval( // Circular logo for the second logo
                  child: Image.asset(
                    'assets/images/mitlogo.png', // Replace with your actual logo path
                    height: 55, // Adjust size as needed
                    width: 55, // Adjust size as needed
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}