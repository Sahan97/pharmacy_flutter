import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

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
        _myWindowButton(
          child: MinimizeWindowButton(
            colors: minButtonColors,
            animate: true,
          ),
        ),
        _myWindowButton(
          child: MaximizeWindowButton(
            colors: minButtonColors,
            animate: true,
          ),
        ),
        _myWindowButton(
          child: CloseWindowButton(
            colors: closeButtonColors,
            animate: true,
          ),
        )
      ],
    );
  }

  final minButtonColors = WindowButtonColors(
    iconNormal: Colors.white,
    mouseOver: Colors.grey.withOpacity(0.8),
    mouseDown: Color(0xFF805306),
    iconMouseOver: Colors.white,
  );

  final closeButtonColors = WindowButtonColors(
    iconNormal: Colors.white,
    mouseOver: Color(0xFFD32F2F),
    mouseDown: Color(0xFFB71C1C),
    iconMouseOver: Colors.white,
  );
  Widget _myWindowButton({@required Widget child}) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white.withOpacity(0.8), width: 2)),
        margin: EdgeInsets.symmetric(horizontal: 3),
        height: 40,
        width: 40,
        child: ClipRRect(borderRadius: BorderRadius.circular(40), child: child),
      ),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}