import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: MyWidget(),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        print("Button Pressed");
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.pink,
        backgroundColor: Colors.green,
      ),
      child: const Text(
        "Text Button",
        style: TextStyle(fontSize: 28),
      ),
    );
  }
}
