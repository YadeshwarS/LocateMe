import 'package:flutter/material.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

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
            'HOW I TRACK YOU??',
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
                'assets/intropage2.jpg', // Replace with your image file path
                width: 450,
                height: 250,
              ),
              const SizedBox(
                  height: 30), // Adds spacing between the image and paragraph
              const Text(
                'Students are tracked through their GPS, \n '
                'and all of their activities are monitored using it. ',
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
