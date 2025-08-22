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
      color: Colors.blue,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            10.0,
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 40,
                color: Colors.red,
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      "Nguyen Van Thanh",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),
                    Text(
                      "Chuong Duong, Ha Noi",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 60,
                height: 40,
                color: Colors.green,
              ),

              const SizedBox(width: 10),

              Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 40,
                    color:
                        Colors.yellow,
                  ),
                  Text("20"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
