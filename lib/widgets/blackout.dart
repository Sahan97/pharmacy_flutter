import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/material.dart';

class Blackout extends StatelessWidget {
  final Widget child;
  const Blackout({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpacityAnimatedWidget.tween(
      duration: Duration(milliseconds: 200),
      enabled: true,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: ScaleAnimatedWidget(
            enabled: true,
            duration: Duration(milliseconds: 200),
            values: [0, 1],
            child: child,
            curve: Curves.easeIn,
          ),
        ),
      ),
    );
  }
}
