import 'package:flutter/material.dart';

class CustomRadio extends StatelessWidget {
  final bool isSelected;
  final String title;
  final Function onClick;
  const CustomRadio(
      {Key key,
      @required this.isSelected,
      @required this.title,
      @required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? Colors.blue : Colors.grey,
              size: 30,
            ),
            SizedBox(
              width: 20,
            ),
            Container(
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.blue : Colors.grey),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
