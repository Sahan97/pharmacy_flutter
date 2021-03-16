import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/material.dart';

class Blackout extends StatelessWidget {
  final Widget child;
  const Blackout({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpacityAnimatedWidget.tween(
      enabled: true,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: ScaleAnimatedWidget(
            enabled: true,
            duration: Duration(milliseconds: 500),
            values: [0, 0.5, 1, 1.1, 0.9, 1],
            child: child,
          ),
        ),
      ),
    );
  }
}
