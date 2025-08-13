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
      child: TextButton.icon(
        onPressed: () {
          print("Button Pressed");
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.pink,
          backgroundColor: Colors.green,
          padding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
                  18,
                ),
          ),
          elevation: 20,
          shadowColor: Colors.blue
              .withOpacity(0.5),
        ),
        icon: Icon(Icons.add, size: 30),
        label: const Text(
          "Text Button",
          style: TextStyle(
            fontSize: 28,
          ),
        ),
      ),
    );
  }
}
