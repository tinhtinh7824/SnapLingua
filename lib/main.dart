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
    return Stack(
      children: [
        Container(color: Colors.green),

        Positioned(
          bottom: 20,
          left: 10,
          right: 10,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                    10.0,
                  ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.all(
                    10.0,
                  ),
              child: Column(
                children: [
                  Text(
                    "data",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),

                  SizedBox(height: 20),

                  Text(
                    "Hahahahhahahah ahha ahahfa fk afalfajlflafaiofha afafafd sfjow3f iwfj wfo fwf wfowf jwof fowf wof jwofwofjw fw fowufowifow fw fwof ow fw fwif wof wo f",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
