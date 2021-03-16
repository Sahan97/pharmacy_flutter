import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingBtn extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final bool isBusy;
  final String text;
  final Function onPressed;
  final double fontSize;
  const LoadingBtn(
      {Key key,
      @required this.onPressed,
      @required this.text,
      this.width = 200,
      this.height = 35,
      this.color = Colors.blue,
      this.isBusy = false,
      this.fontSize = 18})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              border: Border.all(color: Colors.white, width: 0.8)),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              child: Center(
                child: isBusy
                    ? LoadingIndicator(
                        indicatorType: Indicator.pacman,
                        color: Colors.white,
                      )
                    : Text(
                        text,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize,
                            shadows: [
                              Shadow(
                                  color: Colors.black38,
                                  offset: Offset(1, 1),
                                  blurRadius: 3)
                            ]),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
