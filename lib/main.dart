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
    return Container(
      margin: EdgeInsets.all(20),
      child: TextButton(
        onPressed: () {
          print("Button Pressed");
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.pink,
          backgroundColor: Colors.green,
          padding: EdgeInsets.all(10),
        ),
        child: const Text(
          "Text Button",
          style: TextStyle(
            fontSize: 28,
          ),
        ),
      ),
    );
  }
}
