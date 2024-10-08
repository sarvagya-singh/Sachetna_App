import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<DateTime> _months = [];
  Map<DateTime, Map<String, double>> _assessmentScores = {};
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _getMonths();
    _getAssessmentScores();
    _pageController = PageController(initialPage: 0);
  }

  void _getMonths() {
    DateTime now = DateTime.now();
    DateTime? registeredDate = _auth.currentUser?.metadata.creationTime;
    if (registeredDate == null) return;

    DateTime currentMonth = DateTime(now.year, now.month, 1);
    DateTime startMonth =
    DateTime(registeredDate.year, registeredDate.month, 1);

    while (currentMonth.isAfter(startMonth) ||
        currentMonth.isAtSameMomentAs(startMonth)) {
      _months.add(currentMonth);
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);
    }

    setState(() {});
  }

  void _getAssessmentScores() {
    final user = _auth.currentUser;
    if (user != null) {
      _firestore
          .collection('assessments')
          .where('userId', isEqualTo: user.uid)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          DateTime date = doc.get('timestamp').toDate();
          String testType = doc.get('testType');
          double score = doc.get('totalScore');

          DateTime dateKey = DateTime(date.year, date.month, date.day);
          if (!_assessmentScores.containsKey(dateKey)) {
            _assessmentScores[dateKey] = {};
          }
          _assessmentScores[dateKey]![testType] = score;
        });
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[700]!, Colors.blue[900]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Assessment Stats',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatsCard(
                        'Daily Tracker',
                        Icons.calendar_today,
                            () => _showDailyTracker(),
                      ),
                      SizedBox(height: 20),
                      _buildStatsCard(
                        'Overall Stats',
                        Icons.bar_chart,
                            () => _showOverallStats(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(String title, IconData icon, VoidCallback onTap) {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 40),
              SizedBox(width: 20),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDailyTracker() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DailyTrackerPage(
          months: _months,
          assessmentScores: _assessmentScores,
          onDayTap: _showDayScores,
        ),
      ),
    );
  }

  void _showOverallStats() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OverallStatsPage(
          assessmentScores: _assessmentScores,
        ),
      ),
    );
  }

  void _showDayScores(BuildContext context, DateTime date) {
    Map<String, double>? scores = _assessmentScores[date];
    if (scores == null || scores.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No tests taken on this day')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
          Text('Test Scores for ${DateFormat('MMM d, yyyy').format(date)}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: scores.entries.map((entry) {
              return Text('${entry.key}: ${entry.value.toStringAsFixed(2)}');
            }).toList(),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}

class MonthCard extends StatelessWidget {
  final DateTime month;
  final Map<DateTime, Map<String, double>> assessmentScores;
  final Function(DateTime) onDayTap;

  MonthCard({
    required this.month,
    required this.assessmentScores,
    required this.onDayTap,
  });

  Color _getColorShade(String testType, double? score) {
    if (score == null) {
      return Colors.grey[800]!;
    }
    double normalizedScore = _normalizeScore(testType, score);
    switch (testType) {
      case 'PHQ-9':
        return Color.lerp(
            Colors.green[700]!, Colors.red[700]!, normalizedScore)!;
      case 'GAD-7':
        return Color.lerp(
            Colors.blue[700]!, Colors.orange[700]!, normalizedScore)!;
      case 'CAGE':
        return Color.lerp(
            Colors.purple[700]!, Colors.yellow[700]!, normalizedScore)!;
      default:
        return Colors.grey[800]!;
    }
  }

  Widget _buildMonthGrid(String testType) {
    List<String> weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    int firstWeekday = DateTime(month.year, month.month, 1).weekday - 1;

    return Column(
      children: [
        Text(
          testType,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
          ),
          itemCount: 7 + daysInMonth + firstWeekday,
          itemBuilder: (context, index) {
            if (index < 7) {
              return Center(
                child: Text(
                  weekdays[index],
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              );
            }

            int dayNumber = index - 7 - firstWeekday + 1;
            if (dayNumber < 1 || dayNumber > daysInMonth) {
              return Container();
            }

            DateTime date = DateTime(month.year, month.month, dayNumber);
            double? score = assessmentScores[date]?[testType];

            return GestureDetector(
              onTap: () => onDayTap(date),
              child: Container(
                margin: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: _getColorShade(testType, score),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: score != null
                      ? Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 18,
                  )
                      : Text(
                    '$dayNumber',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            DateFormat('MMMM yyyy').format(month),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                _buildMonthGrid('PHQ-9'),
                SizedBox(height: 24),
                _buildMonthGrid('GAD-7'),
                SizedBox(height: 24),
                _buildMonthGrid('CAGE'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _normalizeScore(String testType, double score) {
    switch (testType) {
      case 'PHQ-9':
        return score / 27; // PHQ-9 max score is 27
      case 'GAD-7':
        return score / 21; // GAD-7 max score is 21
      case 'CAGE':
        return score / 4; // CAGE max score is 4
      default:
        return score;
    }
  }
}

class DailyTrackerPage extends StatelessWidget {
  final List<DateTime> months;
  final Map<DateTime, Map<String, double>> assessmentScores;
  final Function(BuildContext, DateTime) onDayTap;

  DailyTrackerPage({
    required this.months,
    required this.assessmentScores,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Tracker'),
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[700]!, Colors.blue[900]!],
          ),
        ),
        child: PageView.builder(
          itemCount: months.length,
          reverse: true,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.black,
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: MonthCard(
                month: months[index],
                assessmentScores: assessmentScores,
                onDayTap: (date) => onDayTap(context, date),
              ),
            );
          },
        ),
      ),
    );
  }
}

class OverallStatsPage extends StatelessWidget {
  final Map<DateTime, Map<String, double>> assessmentScores;

  OverallStatsPage({required this.assessmentScores});

  int getTotalAssessments() {
    return assessmentScores.values.expand((map) => map.keys).length;
  }

  int getTotalFlagsRaised() {
    int flags = 0;
    assessmentScores.values.forEach((tests) {
      if (tests['PHQ-9'] != null && tests['PHQ-9']! >= 15) flags++;
      if (tests['GAD-7'] != null && tests['GAD-7']! >= 15) flags++;
      if (tests['CAGE'] != null && tests['CAGE']! >= 2) flags++;
    });
    return flags;
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 50, color: color),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalAssessments = getTotalAssessments();
    int totalFlags = getTotalFlagsRaised();

    return Scaffold(
      appBar: AppBar(
        title: Text('Overall Stats'),
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[700]!, Colors.blue[900]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatCard(
                'Total Assessments',
                totalAssessments.toString(),
                Icons.assessment,
                Colors.blue,
              ),
              SizedBox(height: 20),
              _buildStatCard(
                'Total Flags Raised',
                totalFlags.toString(),
                Icons.flag,
                Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
