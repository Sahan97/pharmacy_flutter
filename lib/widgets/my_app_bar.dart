import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'window_buttons.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final AppBar appBar;
  final Color backgroundColor;

  MyAppBar(
      {Key key, this.title, this.appBar, this.backgroundColor = Colors.blue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      actions: [
        SizedBox(
          width: 70,
        ),
        Expanded(
          child: MoveWindow(
            child: Center(
              widthFactor: 1,
              child: Text(
                title,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
        WindowButtons()
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
