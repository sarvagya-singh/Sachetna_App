import 'package:flutter/material.dart';
import '../widgets/course_tile.dart';
import '../widgets/club_tile.dart';
import 'package:sachetana_firebase/widgets/section_header.dart';
import 'package:sachetana_firebase/widgets/tab_button.dart';
class UpskillScreen extends StatefulWidget {
  const UpskillScreen({super.key});

  @override
  _UpskillScreenState createState() => _UpskillScreenState();
}

class _UpskillScreenState extends State<UpskillScreen> {
  bool isCoursesSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/home.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Texts placed at the top of the screen
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100), // Space for the top of the screen
                // Center "Upskill Yourself" Text
                Text(
                  'Upskill Yourself',
                  style: TextStyle(fontFamily: 'DMSans', fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 40), // Space between titles
                // Two-line "Check out these clubs & courses" text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Check out these',
                      style: TextStyle(fontFamily: 'DMSans', fontSize: 25, color: Colors.white),
                    ),
                    Text(
                      'clubs & courses',
                      style: TextStyle(fontFamily: 'DMSans', fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 20), // Space before white rectangle
              ],
            ),
          ),

          // Curved white rectangle
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.67, // Adjust height as needed
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0), // Adjust the radius as needed
                  topRight: Radius.circular(15.0), // Adjust the radius as needed
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30), // Space for the top of the rectangle

                    // Left-aligned Courses and Clubs buttons with padding between them
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TabButton(
                            title: 'Courses',
                            isSelected: isCoursesSelected,
                            onTap: () {
                              setState(() {
                                isCoursesSelected = true;
                              });
                            },
                          ),
                          const SizedBox(width: 8), // Padding between buttons
                          TabButton(
                            title: 'Clubs',
                            isSelected: !isCoursesSelected,
                            onTap: () {
                              setState(() {
                                isCoursesSelected = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    Expanded(
                      child:
                      isCoursesSelected ? _buildCoursesSection() : _buildClubsSection(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesSection() {
    return ListView(
      children: [
        const SectionHeader(title: 'Study Skills'),
        const SizedBox(height: 15),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'YouTube'),
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'YouTube'),
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'YouTube'),
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'YouTube'),
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'YouTube'),
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'YouTube'),
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'YouTube'),
            ],
          ),
        ),
        const SizedBox(height: 50),
        const SectionHeader(title: 'Coping Skills'),
        const SizedBox(height: 15),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'TedX'),
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'TedX'),
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'TedX'),
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'TedX'),
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'TedX'),
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'TedX'),
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'TedX'),
            ],
          ),
        ),
        const SizedBox(height: 50),
        const SectionHeader(title: 'Social Skills'),
        const SizedBox(height: 15),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'YouTube'),
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'YouTube'),
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'YouTube'),
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'YouTube'),
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'YouTube'),
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'YouTube'),
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'YouTube'),
            ],
          ),
        ),
        const SizedBox(height: 50),
        const SectionHeader(title: 'Relationship Issues'),
        const SizedBox(height: 15),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'YouTube'),
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'YouTube'),
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'YouTube'),
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'YouTube'),
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'YouTube'),
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'YouTube'),
              CourseTile(courseTitle: 'TedX: How to be happy when you can’t be', platform: 'YouTube'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClubsSection() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return ClubTile(clubTitle: ['MRC', 'TTM', 'NSS'][index % 3]);
      },
    );
  }
}

