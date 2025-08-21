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
    return Column(
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Container(
            height: 100,
            color: Colors.amber,
          ),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Container(
            color: Colors.blue,
          ),
        ),
        Flexible(
          fit: FlexFit.tight,
          child: Container(
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
