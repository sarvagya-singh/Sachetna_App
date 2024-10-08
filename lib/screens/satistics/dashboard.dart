// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fl_chart/fl_chart.dart';
//
// class DashboardPage extends StatefulWidget {
//   @override
//   _DashboardPageState createState() => _DashboardPageState();
// }
//
// class _DashboardPageState extends State<DashboardPage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildOverviewCards(),
//               SizedBox(height: 20),
//               _buildAverageScoreChart(),
//               SizedBox(height: 20),
//               _buildCommonProblems(),
//               SizedBox(height: 20),
//               _buildRecentAssessments(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildOverviewCards() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _firestore.collection('users').snapshots(),
//       builder: (context, userSnapshot) {
//         return StreamBuilder<QuerySnapshot>(
//           stream: _firestore.collection('assessments').snapshots(),
//           builder: (context, assessmentSnapshot) {
//             if (!userSnapshot.hasData || !assessmentSnapshot.hasData) {
//               return CircularProgressIndicator();
//             }
//
//             int totalUsers = userSnapshot.data?.docs.length ?? 0;
//             int totalAssessments = assessmentSnapshot.data?.docs.length ?? 0;
//             double averageScore = 0;
//
//             if (totalAssessments > 0) {
//               try {
//                 double totalScore = assessmentSnapshot.data!.docs
//                     .map((doc) =>
//                         (doc.data() as Map<String, dynamic>)['totalScore']
//                             as num? ??
//                         0)
//                     .fold(0, (sum, score) => sum + score);
//                 averageScore = totalScore / totalAssessments;
//               } catch (e) {
//                 print('Error calculating average score: $e');
//               }
//             }
//
//             return Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildOverviewCard(
//                     'Total Users', totalUsers.toString(), Colors.blue[700]!),
//                 _buildOverviewCard('Total Assessments',
//                     totalAssessments.toString(), Colors.green[600]!),
//                 _buildOverviewCard('Avg Score', averageScore.toStringAsFixed(2),
//                     Colors.orange[600]!),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildOverviewCard(String title, String value, Color color) {
//     return Card(
//       color: color,
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Text(title, style: TextStyle(color: Colors.white)),
//             SizedBox(height: 8),
//             Text(value,
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAverageScoreChart() {
//     return Card(
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Average Scores by Test Type',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 16),
//             AspectRatio(
//               aspectRatio: 1.7,
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: _firestore.collection('assessments').snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) return CircularProgressIndicator();
//
//                   Map<String, List<double>> scoresByType = {};
//                   snapshot.data!.docs.forEach((doc) {
//                     var data = doc.data() as Map<String, dynamic>;
//                     String testType = data['testType'] as String? ?? 'Unknown';
//                     double score =
//                         (data['totalScore'] as num?)?.toDouble() ?? 0.0;
//                     if (!scoresByType.containsKey(testType)) {
//                       scoresByType[testType] = [];
//                     }
//                     scoresByType[testType]!.add(score);
//                   });
//
//                   List<BarChartGroupData> barGroups = [];
//                   scoresByType.forEach((type, scores) {
//                     double average =
//                         scores.reduce((a, b) => a + b) / scores.length;
//                     barGroups.add(BarChartGroupData(
//                       x: barGroups.length,
//                       barRods: [BarChartRodData(toY: average)],
//                     ));
//                   });
//
//                   return BarChart(
//                     BarChartData(
//                       alignment: BarChartAlignment.spaceAround,
//                       maxY: 100,
//                       titlesData: FlTitlesData(
//                         bottomTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             getTitlesWidget: (value, meta) {
//                               List<String> types = scoresByType.keys.toList();
//                               if (value.toInt() < types.length) {
//                                 return Text(types[value.toInt()][0]);
//                               }
//                               return Text('');
//                             },
//                           ),
//                         ),
//                       ),
//                       barGroups: barGroups,
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCommonProblems() {
//     return Card(
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Most Common Problems',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 16),
//             StreamBuilder<QuerySnapshot>(
//               stream: _firestore.collection('assessments').snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) return CircularProgressIndicator();
//
//                 Map<String, int> problemCounts = {};
//                 snapshot.data!.docs.forEach((doc) {
//                   var data = doc.data() as Map<String, dynamic>;
//                   List<dynamic> problems =
//                       (data['problems'] as List<dynamic>?) ?? [];
//                   problems.forEach((problem) {
//                     if (problem is String) {
//                       problemCounts[problem] =
//                           (problemCounts[problem] ?? 0) + 1;
//                     }
//                   });
//                 });
//
//                 var sortedProblems = problemCounts.entries.toList()
//                   ..sort((a, b) => b.value.compareTo(a.value));
//
//                 return Column(
//                   children: sortedProblems.take(5).map((entry) {
//                     return ListTile(
//                       title: Text(entry.key),
//                       trailing: Text(entry.value.toString()),
//                     );
//                   }).toList(),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRecentAssessments() {
//     return Card(
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Recent Assessments',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 16),
//             StreamBuilder<QuerySnapshot>(
//               stream: _firestore
//                   .collection('assessments')
//                   .orderBy('timestamp', descending: true)
//                   .limit(5)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) return CircularProgressIndicator();
//
//                 return Column(
//                   children: snapshot.data!.docs.map((doc) {
//                     var data = doc.data() as Map<String, dynamic>;
//                     return ListTile(
//                       title: Text('User: ${data['userId'] ?? 'Unknown'}'),
//                       subtitle: Text('Test: ${data['testType'] ?? 'Unknown'}'),
//                       trailing: Text(
//                           'Score: ${data['totalScore']?.toString() ?? 'N/A'}'),
//                     );
//                   }).toList(),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80),
              Center(
                child: Text(
                  'User Statistics',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 80),
              _buildOverviewCards(),
              SizedBox(height: 20),
              _buildAverageScoreChart(),
              SizedBox(height: 20),
              _buildCommonProblems(),
              SizedBox(height: 20),
              _buildRecentAssessments(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewCards() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('users').snapshots(),
      builder: (context, userSnapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('assessments').snapshots(),
          builder: (context, assessmentSnapshot) {
            if (!userSnapshot.hasData || !assessmentSnapshot.hasData) {
              return CircularProgressIndicator();
            }

            int totalUsers = userSnapshot.data?.docs.length ?? 0;
            int totalAssessments = assessmentSnapshot.data?.docs.length ?? 0;
            double averageScore = 0;

            if (totalAssessments > 0) {
              try {
                double totalScore = assessmentSnapshot.data!.docs
                    .map((doc) =>
                (doc.data() as Map<String, dynamic>)['totalScore']
                as num? ??
                    0)
                    .fold(0, (sum, score) => sum + score);
                averageScore = totalScore / totalAssessments;
              } catch (e) {
                print('Error calculating average score: $e');
              }
            }

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildOverviewCard(
                        'Total\nUsers',
                        totalUsers.toString(),
                        Colors.blueAccent.shade700,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: _buildOverviewCard(
                        'Total\nAssessments',
                        totalAssessments.toString(),
                        Colors.blue[200]!,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                _buildOverviewCard(
                  'Avg Score',
                  averageScore.toStringAsFixed(2),
                  Colors.black,
                  fullWidth: true,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildOverviewCard(String title, String value, Color color,
      {bool fullWidth = false}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // more rounded corners
      ),
      color: color,
      child: Container(
        height: 150, // Increase height to 130
        width: fullWidth ? double.infinity : null, // Stretch to full width if required
        padding: EdgeInsets.all(16),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32, // Larger font for value
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  color: Colors.white, // White circle
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.analytics, // Example blue icon
                  color: Colors.blue,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

    Widget _buildAverageScoreChart() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Average Scores by Test Type',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 1.7,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('assessments').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();

                  Map<String, List<double>> scoresByType = {};
                  snapshot.data!.docs.forEach((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    String testType = data['testType'] as String? ?? 'Unknown';
                    double score =
                        (data['totalScore'] as num?)?.toDouble() ?? 0.0;
                    if (!scoresByType.containsKey(testType)) {
                      scoresByType[testType] = [];
                    }
                    scoresByType[testType]!.add(score);
                  });

                  List<BarChartGroupData> barGroups = [];
                  scoresByType.forEach((type, scores) {
                    double average =
                        scores.reduce((a, b) => a + b) / scores.length;
                    barGroups.add(BarChartGroupData(
                      x: barGroups.length,
                      barRods: [BarChartRodData(toY: average)],
                    ));
                  });

                  return BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 100,
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              List<String> types = scoresByType.keys.toList();
                              if (value.toInt() < types.length) {
                                return Text(types[value.toInt()][0]);
                              }
                              return Text('');
                            },
                          ),
                        ),
                      ),
                      barGroups: barGroups,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildCommonProblems() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // more rounded corners
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Most Common Problems',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('assessments').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();

                Map<String, int> problemCounts = {};
                snapshot.data!.docs.forEach((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  List<dynamic> problems =
                      (data['problems'] as List<dynamic>?) ?? [];
                  problems.forEach((problem) {
                    if (problem is String) {
                      problemCounts[problem] =
                          (problemCounts[problem] ?? 0) + 1;
                    }
                  });
                });

                var sortedProblems = problemCounts.entries.toList()
                  ..sort((a, b) => b.value.compareTo(a.value));

                return Column(
                  children: sortedProblems.take(5).map((entry) {
                    return ListTile(
                      title: Text(entry.key),
                      trailing: Text(entry.value.toString()),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAssessments() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // more rounded corners
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Assessments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('assessments')
                  .orderBy('timestamp', descending: true)
                  .limit(5)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();

                return Column(
                  children: snapshot.data!.docs.map((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    String userName = data['userName'] as String? ?? 'Unknown';
                    double score =
                        (data['totalScore'] as num?)?.toDouble() ?? 0.0;
                    Timestamp timestamp =
                        data['timestamp'] as Timestamp? ?? Timestamp.now();
                    DateTime date = timestamp.toDate();

                    return ListTile(
                      title: Text(userName),
                      subtitle: Text('Score: ${score.toStringAsFixed(2)}'),
                      trailing: Text('${date.month}/${date.day}/${date.year}'),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

