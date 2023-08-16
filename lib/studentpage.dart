import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(StudentDashboardPage());
}

class StudentDashboardPage extends StatefulWidget {
  @override
  _StudentDashboardPageState createState() => _StudentDashboardPageState();
}

class _StudentDashboardPageState extends State<StudentDashboardPage> {
  String? studentName;
  String? email;
  String? mobileNumber;
  List<String> joinedGroups = [];
  bool isGpsEnabled = false;
  late File _imageFile;
  bool isImageSelected = false;

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit'),
            content: const Text('Do you want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => exit(0),
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
    checkGpsStatus();
    _imageFile = File(''); // Provide a default empty image file
  }

  void checkGpsStatus() async {
    bool gpsEnabled = await Geolocator.isLocationServiceEnabled();
    setState(() {
      isGpsEnabled = gpsEnabled;
    });
  }

  void enableGps() async {
    if (await Geolocator.openLocationSettings()) {
      checkGpsStatus();
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
        isImageSelected = true;
      }
    });
  }

  void joinGroup(String groupCode) {
    if (groupCode.isNotEmpty) {
      setState(() {
        joinedGroups.add(groupCode);
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please enter a valid Group ID.'),
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
    }
  }

  void showJoinGroupDialog(BuildContext context) async {
    bool gpsEnabled = await Geolocator.isLocationServiceEnabled();
    if (!gpsEnabled) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Enable GPS'),
            content: const Text('Please enable GPS to join a new group.'),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Enable'),
                onPressed: () async {
                  if (await Geolocator.openLocationSettings()) {
                    // GPS enabled, proceed to join a new group
                    Navigator.of(context).pop();
                    _joinGroupWithGPS(context);
                  } else {
                    // GPS not enabled, close the application
                    exit(0);
                  }
                },
              ),
            ],
          );
        },
      );
    } else {
      _joinGroupWithGPS(context);
    }
  }

  void _joinGroupWithGPS(BuildContext context) async {
    bool gpsEnabled = await Geolocator.isLocationServiceEnabled();
    if (!gpsEnabled) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Enable GPS'),
            content: const Text('Please enable GPS to join a new group.'),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Enable'),
                onPressed: () async {
                  if (await Geolocator.openLocationSettings()) {
                    // GPS enabled, proceed to join a new group
                    Navigator.of(context).pop();
                    _joinGroup(context);
                  } else {
                    // GPS not enabled, close the application
                    exit(0);
                  }
                },
              ),
            ],
          );
        },
      );
    } else {
      _joinGroup(context);
    }
  }

  void _joinGroup(BuildContext context) {
    String groupCode = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Join New Group'),
          content: TextField(
            onChanged: (value) {
              groupCode = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter Group Code',
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
              child: const Text('Join'),
              onPressed: () {
                if (groupCode.isNotEmpty) {
                  joinGroup(groupCode);
                  Navigator.of(context).pop();
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Please enter a valid Group ID.'),
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
                }
              },
            ),
          ],
        );
      },
    );
  }

  void changeImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: MaterialApp(
        title: 'Student Dashboard',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Student Dashboard'),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    // Implement logout functionality here
                    // For example, you can navigate back to the login page
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                  },
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (!isImageSelected)
                              IconButton(
                                icon: const Icon(Icons.add_a_photo),
                                onPressed: _pickImage,
                              ),
                            if (isImageSelected)
                              GestureDetector(
                                onTap: changeImage,
                                child: CircleAvatar(
                                  backgroundImage: _imageFile.existsSync()
                                      ? FileImage(_imageFile)
                                      : null,
                                  radius: 60,
                                ),
                              ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome ${studentName ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Email:',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  email ?? '',
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Mobile Number:',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  mobileNumber ?? '',
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Joined Groups:',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: joinedGroups.length,
                    itemBuilder: (context, index) {
                      final group = joinedGroups[index];
                      return Card(
                        child: ListTile(
                          title: Text(group),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Join New Group:',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        showJoinGroupDialog(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
