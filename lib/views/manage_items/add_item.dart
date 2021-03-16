import 'package:communication/helpers/api_service.dart';
import 'package:communication/model/item.dart';
import 'package:communication/widgets/Messages.dart';
import 'package:communication/widgets/chip_input.dart';
import 'package:communication/widgets/input_field.dart';
import 'package:communication/widgets/loading_btn.dart';
import 'package:flutter/material.dart';

class AddItem extends StatefulWidget {
  AddItem({Key key}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name, seller;
  double quantity, sellPricePerItem, buyPricePerItem, discount;
  bool _isBusy = false;
  List<String> barcodes = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(5)),
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                InputField(
                  icon: Icons.note_add,
                  labelText: 'Item Name',
                  onSaved: (value) {
                    name = value;
                  },
                  onValidate: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter item name';
                    }
                    return null;
                  },
                  autofocus: true,
                  width: 400,
                ),
                InputField(
                  icon: Icons.check_circle_outline,
                  labelText: 'Quantity',
                  onSaved: (String value) {
                    if (value.isEmpty) {
                      quantity = 0;
                    } else {
                      quantity = double.parse(value);
                    }
                  },
                  onValidate: (String value) {
                    return null;
                  },
                  width: 400,
                  isNumberOnly: true,
                ),
                InputField(
                    icon: Icons.person,
                    labelText: 'Seller',
                    onSaved: (String value) {
                      if (value.isEmpty) {
                        seller = 'unknown seller';
                      } else {
                        seller = value;
                      }
                    },
                    onValidate: (String value) {
                      return null;
                    },
                    width: 400),
                InputField(
                  icon: Icons.attach_money,
                  labelText: 'Buy Price',
                  onSaved: (String value) {
                    if (value.isEmpty) {
                      buyPricePerItem = 0;
                    } else {
                      buyPricePerItem = double.parse(value);
                    }
                  },
                  onValidate: (String value) {
                    return null;
                  },
                  width: 400,
                  isNumberOnly: true,
                ),
                InputField(
                  icon: Icons.monetization_on,
                  labelText: 'Sell Price',
                  onSaved: (String value) {
                    sellPricePerItem = double.parse(value);
                  },
                  onValidate: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter sell price';
                    }
                    return null;
                  },
                  width: 400,
                  isNumberOnly: true,
                ),
                InputField(
                  icon: Icons.money_off,
                  labelText: 'Discount',
                  onSaved: (String value) {
                    if (value.isEmpty) {
                      discount = 0;
                    } else {
                      discount = double.parse(value);
                    }
                  },
                  onValidate: (String value) {
                    return null;
                  },
                  width: 400,
                  isNumberOnly: true,
                  initialValue: '0',
                ),
                MyChipInput(
                  myListCustom: barcodes,
                  addChips: _addBarcode,
                ),
                ButtonBar(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LoadingBtn(
                      onPressed: () {
                        _formKey.currentState.reset();
                      },
                      text: 'Clear',
                      color: Colors.red,
                    ),
                    LoadingBtn(
                      onPressed: _onSubmit,
                      text: 'Add',
                      isBusy: _isBusy,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _addBarcode(String code) {
    setState(() {
      barcodes.add(code);
    });
  }

  _onSubmit() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isBusy = true;
    });
    ApiService.shared.createItemCall({
      "name": name,
      "quantity": quantity,
      "sellPricePerItem": sellPricePerItem,
      "discount": discount,
      "seller": seller,
      "buyPricePerItem": buyPricePerItem,
      "barcodes": barcodes
    }).then((value) {
      setState(() {
        _isBusy = false;
      });
      Messages.simpleMessage(head: value.title, body: value.subtitle);
    });
  }
}
