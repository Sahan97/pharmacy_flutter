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
  final Function onSubmit;
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
      this.controller,
      this.onSubmit})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: width,
      child: TextFormField(
        enabled: !isDisable,
        // inputFormatters:
        //     isNumberOnly ? [FilteringTextInputFormatter.digitsOnly] : [],
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
        onFieldSubmitted: (value) {
          if (onSubmit != null) {
            onSubmit();
          }
        },
      ),
    );
  }
}

class InputFieldDropDown extends StatefulWidget {
  final String labelText;
  final IconData icon;
  final Function onSaved;
  final double width;
  final TextEditingController controller;
  final List<String> values;
  final String initialValue;
  final Function onValidate;
  const InputFieldDropDown(
      {Key key,
      @required this.icon,
      @required this.labelText,
      @required this.onSaved,
      @required this.values,
      @required this.onValidate,
      this.width = 300,
      this.controller,
      this.initialValue})
      : super(key: key);
  @override
  _InputFieldDropDownState createState() => _InputFieldDropDownState();
}

class _InputFieldDropDownState extends State<InputFieldDropDown> {
  String selectedValue;

  @override
  void initState() {
    selectedValue = (widget.initialValue == null || widget.initialValue == '')
        ? null
        : widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: widget.width,
      child: FormField<String>(
        onSaved: (value) {
          widget.onSaved(value);
        },
        initialValue: selectedValue,
        validator: widget.onValidate,
        builder: (FormFieldState<String> state) {
          return InputDecorator(
            decoration: InputDecoration(
              labelText: widget.labelText,
              labelStyle: TextStyle(fontSize: 18),
              prefixIcon: Icon(widget.icon),
            ),
            isEmpty: (selectedValue == null || selectedValue == ''),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedValue,
                isDense: true,
                onChanged: (String newValue) {
                  setState(() {
                    selectedValue = newValue;
                    state.didChange(newValue);
                  });
                },
                items: widget.values.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
