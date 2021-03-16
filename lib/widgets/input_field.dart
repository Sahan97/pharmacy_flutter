import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final Function onSaved;
  final Function onValidate;
  final double width;
  final bool isObsecure;
  final bool autofocus;
  final bool isNumberOnly;
  final String initialValue;
  final bool isDisable;
  final TextEditingController controller;
  const InputField(
      {Key key,
      @required this.icon,
      @required this.labelText,
      @required this.onSaved,
      @required this.onValidate,
      this.width = 300,
      this.isObsecure = false,
      this.autofocus = false,
      this.isNumberOnly = false,
      this.initialValue = '',
      this.isDisable = false,
      this.controller})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: width,
      child: TextFormField(
        enabled: !isDisable,
        inputFormatters:
            isNumberOnly ? [FilteringTextInputFormatter.digitsOnly] : [],
        autofocus: autofocus,
        decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(fontSize: 18),
            prefixIcon: Icon(icon)),
        onSaved: onSaved,
        validator: onValidate,
        obscureText: isObsecure,
        initialValue: controller != null ? null : initialValue,
        style: TextStyle(fontSize: 25),
        controller: controller,
      ),
    );
  }
}
