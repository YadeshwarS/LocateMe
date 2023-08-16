import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GroupDetailsPage extends StatelessWidget {
  final String groupId;
  final String groupName;
  final double distanceRadius;
  final Position? facultyPosition;

  GroupDetailsPage({
    required this.groupId,
    required this.groupName,
    required this.distanceRadius,
    required this.facultyPosition,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Group ID: $groupId',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Add your desired content for the group details page here
            const Text('Group Details'),
          ],
        ),
      ),
    );
  }
}
