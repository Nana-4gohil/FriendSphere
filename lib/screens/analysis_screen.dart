import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalysisScreen extends StatefulWidget {
  final String uid;
  const AnalysisScreen({super.key, required this.uid});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  int totalLikes = 0;
  int totalComments = 0;
  int totalPosts = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAnalyticsData();
  }

  Future<void> fetchAnalyticsData() async {
    try {
      // Fetch all posts by the user
      QuerySnapshot postsSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();

      // Calculate total likes, comments, and posts
      int likesCount = 0;
      int commentsCount = 0;

      for (var post in postsSnapshot.docs) {
        List<dynamic> likes = post['likes'] ?? [];
        likesCount += likes.length;

        QuerySnapshot commentsSnapshot = await FirebaseFirestore.instance
            .collection('posts')
            .doc(post.id)
            .collection('comments')
            .get();
        commentsCount += commentsSnapshot.size;
      }

      setState(() {
        totalLikes = likesCount;
        totalComments = commentsCount;
        totalPosts = postsSnapshot.docs.length;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching analytics: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Data'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Total Posts, Likes, and Comments',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  totalPosts == 0
                      ? const Center(
                          child: Text(
                            'No posts created.',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : Expanded(
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  value: totalPosts.toDouble(),
                                  color: Colors.red,
                                  title: 'Posts',
                                  radius: 60,
                                ),
                                PieChartSectionData(
                                  value: totalLikes.toDouble(),
                                  color: Colors.green,
                                  title: 'Likes',
                                  radius: 60,
                                ),
                                PieChartSectionData(
                                  value: totalComments.toDouble(),
                                  color: Colors.blue,
                                  title: 'Comments',
                                  radius: 60,
                                ),
                              ],
                              sectionsSpace: 4,
                              centerSpaceRadius: 50,
                            ),
                          ),
                        ),
                  const SizedBox(height: 30),
                  totalPosts == 0
                      ? const SizedBox.shrink()
                      : Column(
                          children: [
                            const Text(
                              'Likes and Comments Comparison',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            Expanded(
                              child: BarChart(
                                BarChartData(
                                  barGroups: [
                                    BarChartGroupData(x: 0, barRods: [
                                      BarChartRodData(
                                        toY: totalLikes.toDouble(),
                                        color: Colors.green,
                                      )
                                    ]),
                                    BarChartGroupData(x: 1, barRods: [
                                      BarChartRodData(
                                        toY: totalComments.toDouble(),
                                        color: Colors.blue,
                                      )
                                    ]),
                                  ],
                                  borderData: FlBorderData(show: false),
                                  titlesData: FlTitlesData(
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget:
                                            (double value, TitleMeta meta) {
                                          switch (value.toInt()) {
                                            case 0:
                                              return const Text('Likes');
                                            case 1:
                                              return const Text('Comments');
                                            default:
                                              return const Text('');
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
    );
  }
}
