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
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.red,
              height: 150,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.blue,
              height: 150,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.green,
              height: 150,
            ),
          ),
        ],
      ),
    );
  }
}
