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
      color: Colors.orange,
      child: Row(
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
                      Colors.green,
                  foregroundColor:
                      Colors.white,
                ),
            child: const Text(
              "Button 1",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),

          Container(
            height: 100,
            child: ElevatedButton(
              onPressed: () {},
              style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green,
                    foregroundColor:
                        Colors.white,
                  ),
              child: const Text(
                "Button 2",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),

          ElevatedButton(
            onPressed: () {},
            style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.green,
                  foregroundColor:
                      Colors.white,
                ),
            child: const Text(
              "Button 3",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
