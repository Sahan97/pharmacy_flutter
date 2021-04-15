import 'package:communication/scoped_model/main.dart';
import 'package:communication/views/home_page/home_page.dart';
import 'package:communication/widgets/blackout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:scoped_model/scoped_model.dart';

class MyCalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Blackout(
      child: Center(
        child: Card(
          color: Colors.white,
          child: Container(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, right: 10),
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      child: Container(
                          height: 40, width: 30, child: Icon(Icons.close)),
                      onPressed: () {
                        ScopedModel.of<MainModel>(context)
                            .setHomePagePopup(HomePagePopups.NoPopup);
                      }),
                ),
                Container(
                  width: 500,
                  height: 600,
                  padding: EdgeInsets.all(20),
                  child: SimpleCalculator(
                    theme: const CalculatorThemeData(
                      displayColor: Colors.black,
                      displayStyle:
                          const TextStyle(fontSize: 80, color: Colors.yellow),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
