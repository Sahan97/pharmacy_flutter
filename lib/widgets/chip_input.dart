import 'package:flutter/material.dart';
import 'package:flutter_chip_tags/flutter_chip_tags.dart';

class MyChipInput extends StatelessWidget {
  MyChipInput({Key key, @required this.myListCustom, @required this.addChips})
      : super(key: key);
  final List<String> myListCustom;
  final Function addChips;
  final myController = TextEditingController();
  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      width: 450,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(hintText: 'BarCode'),
            controller: myController,
            focusNode: focusNode,
            onFieldSubmitted: (value) {
              print(value);
              if (value.isNotEmpty && myListCustom.indexOf(value) == -1) {
                addChips(value);
                focusNode.requestFocus();
              }

              myController.value = TextEditingValue(
                text: '',
                selection: TextSelection.fromPosition(
                  TextPosition(offset: ''.length),
                ),
              );
              focusNode.requestFocus();
            },
          ),
          ChipTags(
            decoration: InputDecoration(enabled: false),
            list: myListCustom,
            chipColor: Colors.black,
            iconColor: Colors.white,
            textColor: Colors.white,
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }
}
