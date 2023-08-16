import 'package:flutter/material.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
              vertical: 8), // Adjust vertical padding as needed
          child: Text(
            'WELCOME TO LOCATE ME',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Center(
          child: Column(
            children: [
              Image.asset(
                'assets/intropage1.jpg', // Replace with your image file path
                width: 450,
                height: 250,
              ),
              const SizedBox(
                  height: 30), // Adds spacing between the image and paragraph
              const Text(
                'Welcome to the LocateMe application, where no one can escape from the mentor. \n'
                ' All the students are spectated by their respective mentors each and every second.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
