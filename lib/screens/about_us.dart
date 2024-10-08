import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import for URL launching

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Developer 1
            const Text(
              'Developer 1: John Doe',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () => _launchURL('https://twitter.com/johndoe'), // Replace with actual URL
              child: const Text(
                'Twitter: @johndoe',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
            SizedBox(height: 20),

            // Developer 2
            const Text(
              'Developer 2: Jane Smith',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () => _launchURL('https://github.com/janesmith'), // Replace with actual URL
              child: const Text(
                'GitHub: janesmith',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
            SizedBox(height: 20),

            // Developer 3
            const Text(
              'Developer 3: Alex Johnson',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () => _launchURL('https://linkedin.com/in/alexjohnson'), // Replace with actual URL
              child: const Text(
                'LinkedIn: alexjohnson',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}