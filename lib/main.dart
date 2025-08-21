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
      color: Colors.grey,
      width: 500,
      height: 500,
      child: Stack(
        // alignment: Alignment.topRight,
        fit: StackFit.loose,
        clipBehavior: Clip.none,
        children: [
          Container(
            color: Colors.blue,
            height: 300,
            width: 300,
          ),

          Positioned(
            left: 10,
            top: 10,
            child: Container(
              color: Colors.green,
              height: 700,
              width: 200,
            ),
          ),

          Align(
            alignment:
                Alignment.bottomRight,
            child: Container(
              color: Colors.pink,
              height: 100,
              width: 100,
            ),
          ),
        ],
      ),
    );
  }
}
