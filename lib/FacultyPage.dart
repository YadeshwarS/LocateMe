import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locatesret/loginpage.dart';
import 'student_details_page.dart';
import 'group_details_page.dart';
import 'package:flutter/services.dart';

class FacultyPage extends StatefulWidget {
  const FacultyPage({Key? key}) : super(key: key);

  @override
  _FacultyPageState createState() => _FacultyPageState();
}

class _FacultyPageState extends State<FacultyPage> {
  String facultyName = ''; // Faculty name obtained from signup page
  List<String> groups = []; // List of created group names
  String selectedGroupId = ''; // Selected group ID
  final TextEditingController _groupNameController = TextEditingController();
  List<Color> cardColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
  ];
  double distanceRadius = 0.0; // Distance radius set by the faculty
  Position? facultyPosition; // Live latitude and longitude of the faculty

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirmation'),
            content: const Text('Are you sure you want to exit?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  SystemNavigator.pop(); // Close the application
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    // Initialize faculty name and groups
    fetchFacultyDetails();
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  void fetchFacultyDetails() {
    // Simulating fetching faculty details
    // Replace with your own logic to fetch faculty details
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        facultyName = 'Yadeshwar'; // Set faculty name
      });
      fetchFacultyLocation(); // Fetch the faculty's live location
    });
  }

  void fetchFacultyLocation() async {
    // Fetch the faculty's live location using the Geolocator package
    Position? position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      facultyPosition = position;
    });
  }

  void fetchStudentsInGroup(String groupId) {
    // Simulating fetching students in a group
    // Replace with your own logic to fetch students in a group
    // You can navigate to the StudentDetailsPage passing the groupId and fetch the student details there
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentDetailsPage(groupId: groupId),
      ),
    );
  }

  bool validateGroupName(String groupName) {
    // Validate the group name
    if (groupName.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please enter a group name.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return false;
    }

    if (groupName.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content:
                const Text('Group name should not contain special characters.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return false;
    }

    return true;
  }

  void createNewGroup() {
    String groupName = _groupNameController.text.trim();

    if (!validateGroupName(groupName)) {
      return;
    }

    // Generate a 4-digit group ID
    String newGroupId = generateGroupID();

    // Check if any groups with the same ID exist
    bool groupExists = groups.contains(newGroupId);

    if (groupExists) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('A group with the same ID already exists.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    // Add the new group to the list of groups
    setState(() {
      groups.add(newGroupId);
    });

    _groupNameController.clear();

    // Navigate to the GroupDetailsPage passing the new group ID and group name
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupDetailsPage(
          groupId: newGroupId,
          groupName: groupName,
          distanceRadius: distanceRadius,
          facultyPosition: facultyPosition,
        ),
      ),
    );
  }

  String getGroupNameFromId(String _groupNameController) {
    // Replace this with your own logic to fetch the group name based on the group ID
    // For now, let's assume the group name is the same as the group ID
    return _groupNameController;
  }

  String generateGroupID() {
    // Generate a 4-digit group ID
    int min = 1000;
    int max = 9999;
    return (min + DateTime.now().microsecondsSinceEpoch % (max - min))
        .toString();
  }

  void deleteGroup(String groupName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content:
              Text('Are you sure you want to delete the group: $groupName?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                // Remove the group from the list
                setState(() {
                  groups.remove(groupName);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void logout() {
    // Add your Firebase authentication sign out logic here
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => loginpage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Faculty Page'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: logout,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Faculty: $facultyName',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Groups:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    final groupName = getGroupNameFromId(group);
                    final backgroundColor =
                        cardColors[index % cardColors.length];

                    return Card(
                      color: backgroundColor,
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Group Name: $groupName',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Group ID: $group',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          // Set the selected group ID and fetch students in the group
                          setState(() {
                            selectedGroupId = group;
                          });
                          fetchStudentsInGroup(selectedGroupId);
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _groupNameController,
                      decoration: const InputDecoration(
                        labelText: 'Group Name',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Distance Radius'),
                            content: TextFormField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                distanceRadius = double.parse(value);
                              },
                              decoration: const InputDecoration(
                                labelText: 'Distance Radius (in meters)',
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Create'),
                                onPressed: () {
                                  createNewGroup();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create Group'),
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
