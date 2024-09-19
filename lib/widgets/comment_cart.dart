import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatelessWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            // Profile Picture with Placeholder
            CircleAvatar(
              backgroundImage: snap['profilePic'] != null
                  ? NetworkImage(snap['profilePic'])
                  : AssetImage('assets/placeholder.png') as ImageProvider,
              radius: 22,
            ),
            const SizedBox(width: 16),
            // Comment details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User name
                  Text(
                    snap['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Comment text
                  Text(
                    snap['text'],
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Date with user-friendly format
                  Text(
                    _getTimeDifference(snap['datePublished']),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Like Button with Icon and Count
            InkWell(
              onTap: () {
                // handle like functionality
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.favorite_border,
                    size: 18,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '12', // This can be a dynamic value for like count
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to get user-friendly time difference
  String _getTimeDifference(datePublished) {
    Duration difference = DateTime.now().difference(datePublished.toDate());
    if (difference.inDays > 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 1) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
