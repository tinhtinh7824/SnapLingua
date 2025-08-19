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
      color: Colors.green,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            MainAxisAlignment
                .spaceEvenly,
        crossAxisAlignment:
            CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {},
            style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.pink,
                  foregroundColor:
                      Colors.white,
                ),
            child: const Text(
              "Bottom 1",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),

          Container(
            width: 200,
            child: ElevatedButton(
              onPressed: () {},
              style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.pink,
                    foregroundColor:
                        Colors.white,
                  ),
              child: const Text(
                "Bottom 2",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ),

          ElevatedButton(
            onPressed: () {},
            style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.pink,
                  foregroundColor:
                      Colors.white,
                ),
            child: const Text(
              "Bottom 3",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
