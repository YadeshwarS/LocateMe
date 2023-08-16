import 'package:flutter/material.dart';

class StudentDetailsPage extends StatelessWidget {
  final String groupId;

  const StudentDetailsPage({Key? key, required this.groupId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch student details based on the groupId
    // Replace the below placeholder with your own logic to fetch student details
    List<String> students = [
      'Student 1',
      'Student 2',
      'Student 3',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Group ID: $groupId',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Students:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              itemCount: students.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(students[index]),
                  onTap: () {
                    // Show student's live location
                    // Implement your logic here to show the live location of the selected student
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Live Location'),
                          content: const Text(
                              'Display live location of the selected student here.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
