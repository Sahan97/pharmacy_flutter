import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String route;
  final Function onPressed;
  const DrawerItem(
      {Key key,
      @required this.icon,
      @required this.title,
      this.route,
      this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          if (onPressed == null) {
            Navigator.pop(context);
            if (route != null) {
              Navigator.pushNamed(context, route);
            }
          } else {
            onPressed();
          }
        },
        leading: Icon(icon),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20
          ),
        ),
      ),
    );
  }
}
