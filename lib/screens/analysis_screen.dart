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
    // Calculate average likes and comments per post
    double avgLikesPerPost = totalPosts == 0 ? 0 : totalLikes / totalPosts;
    double avgCommentsPerPost =
        totalPosts == 0 ? 0 : totalComments / totalPosts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Data'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Your activity',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    totalPosts == 0
                        ? const Center(
                            child: Text(
                              'No posts created',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.teal.shade50,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total Posts:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                    Text(
                                      totalPosts.toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total Likes:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Text(
                                      totalLikes.toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total Comments:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Text(
                                      totalComments.toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 30),
                    // Container for average likes and comments per post
                    totalPosts == 0
                        ? const SizedBox.shrink()
                        : Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.teal.shade50,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      'Avg. Likes/Post',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      avgLikesPerPost.toStringAsFixed(2),
                                      style: const TextStyle(
                                        fontSize: 24,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'Avg. Comments/Post',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      avgCommentsPerPost.toStringAsFixed(2),
                                      style: const TextStyle(
                                        fontSize: 24,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 30),
                    totalPosts == 0
                        ? const SizedBox.shrink()
                        : Column(
                            children: [
                              const Text(
                                'Likes & Comments Comparison',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 250,
                                child: BarChart(
                                  BarChartData(
                                    barGroups: [
                                      BarChartGroupData(
                                        x: 0,
                                        barRods: [
                                          BarChartRodData(
                                            toY: totalLikes.toDouble(),
                                            color: Colors.green,
                                            width: 20,
                                            borderRadius: BorderRadius.circular(7),
                                          ),
                                        ],
                                      ),
                                      BarChartGroupData(
                                        x: 1,
                                        barRods: [
                                          BarChartRodData(
                                            toY: totalComments.toDouble(),
                                            color: Colors.blue,
                                            width: 20,
                                            borderRadius: BorderRadius.circular(7),
                                          ),
                                        ],
                                      ),
                                    ],
                                    titlesData: FlTitlesData(
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: (double value, TitleMeta meta) {
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
                                    // Enabling the animation
                                    barTouchData: BarTouchData(
                                      touchTooltipData: BarTouchTooltipData(),
                                    ),
                                    alignment: BarChartAlignment.spaceAround,
                                    maxY: (totalLikes > totalComments ? totalLikes : totalComments).toDouble(),
                                    gridData: const FlGridData(show: false),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
