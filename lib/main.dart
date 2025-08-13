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
      margin: EdgeInsets.all(10),
      child: ElevatedButton.icon(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          minimumSize: Size(240, 80),
          padding: EdgeInsets.all(20),
          disabledBackgroundColor:
              Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
                  10,
                ),
          ),
        ),
        icon: Icon(
          Icons.add_card,
          size: 30,
        ),
        label: const Text(
          'Hihi',
          style: TextStyle(
            fontSize: 28,
          ),
        ),
      ),
    );
  }
}
