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
    return OutlinedButton(
      onPressed: () {
        print("ok");
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        padding: EdgeInsets.all(50),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(40),
        ),
      ),
      child: Text(
        "Haha",
        style: TextStyle(fontSize: 28),
      ),
    );
  }
}
