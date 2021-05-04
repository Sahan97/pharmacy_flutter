import 'package:communication/helpers/api_service.dart';
import 'package:communication/model/item.dart';
import 'package:communication/widgets/Messages.dart';
import 'package:communication/widgets/input_field.dart';
import 'package:communication/widgets/loading_btn.dart';
import 'package:flutter/material.dart';

import 'edit_item.dart';

class AddItem extends StatefulWidget {
  AddItem({Key key}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Item newItem = Item();
  bool _isBusy = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(5),
      ),
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
                    newItem.name = value;
                  },
                  onValidate: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter item name';
                    }
                    return null;
                  },
                  autofocus: true,
                  width: 500,
                ),
                InputField(
                  icon: Icons.note_add,
                  labelText: 'Item Code',
                  onSaved: (value) {
                    newItem.code = value;
                  },
                  onValidate: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter item code';
                    }
                    return null;
                  },
                  autofocus: true,
                  width: 500,
                ),
                InputFieldDropDown(
                  initialValue: newItem.priceCategory,
                  icon: Icons.picture_in_picture_alt_outlined,
                  labelText: 'Price Category',
                  onSaved: (String value) {
                    newItem.priceCategory = value;
                  },
                  onValidate: (String value) {
                    if (value == null) {
                      return 'Please select price category';
                    }
                    return null;
                  },
                  values: priceCategories,
                  width: 500,
                ),
                InputField(
                  icon: Icons.monetization_on,
                  labelText: 'Buy Price',
                  onSaved: (String value) {
                    if (value.isEmpty) {
                      newItem.buyPrice = 0;
                    } else {
                      newItem.buyPrice = double.parse(value);
                    }
                  },
                  onValidate: (String value) {
                    return null;
                  },
                  width: 500,
                  isNumberOnly: true,
                ),
                InputField(
                  icon: Icons.monetization_on,
                  labelText: 'Sell Price',
                  onSaved: (String value) {
                    if (value.isEmpty) {
                      newItem.sellPrice = 0;
                    } else {
                      newItem.sellPrice = double.parse(value);
                    }
                  },
                  onValidate: (String value) {
                    return null;
                  },
                  width: 500,
                  isNumberOnly: true,
                ),
                InputField(
                  icon: Icons.check_circle_outline,
                  labelText: 'Quantity',
                  onSaved: (String value) {
                    if (value.isEmpty) {
                      newItem.currentQty = 0;
                    } else {
                      newItem.currentQty = double.parse(value);
                    }
                  },
                  onValidate: (String value) {
                    return null;
                  },
                  width: 500,
                  isNumberOnly: true,
                ),
                InputField(
                  icon: Icons.check_circle_outline,
                  labelText: 'Re Order QTY',
                  onSaved: (String value) {
                    if (value.isEmpty) {
                      newItem.reOrderQty = 0;
                    } else {
                      newItem.reOrderQty = double.parse(value);
                    }
                  },
                  onValidate: (String value) {
                    return null;
                  },
                  width: 500,
                  isNumberOnly: true,
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

  // _addBarcode(String code) {
  //   setState(() {
  //     barcodes.add(code);
  //   });
  // }

  _onSubmit() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isBusy = true;
    });
    ApiService.shared.createItemCall({
      "name": newItem.name,
      "code": newItem.code,
      "priceCategory": newItem.priceCategory,
      "buyPrice": newItem.buyPrice,
      "sellPrice": newItem.sellPrice,
      "currentQty": newItem.currentQty,
      "reOrderQty": newItem.reOrderQty
    }).then((value) {
      setState(() {
        _isBusy = false;
      });
      if (value.success) {
        _formKey.currentState.reset();
      }
      Messages.simpleMessage(head: value.title, body: value.subtitle);
    });
  }
}
