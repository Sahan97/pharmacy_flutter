import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  BackgroundImage({Key key,@required this.image,@required this.child}) : super(key: key);
  final String image;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
      ),
      child: child,
    );
  }
}
