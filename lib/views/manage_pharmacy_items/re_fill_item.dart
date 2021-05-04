import 'package:communication/helpers/api_service.dart';
import 'package:communication/model/item.dart';
import 'package:communication/scoped_model/main.dart';
import 'package:communication/views/manage_pharmacy_items/manage_items.dart';
import 'package:communication/widgets/Messages.dart';
import 'package:communication/widgets/blackout.dart';
import 'package:communication/widgets/input_field.dart';
import 'package:communication/widgets/loading_btn.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'edit_item.dart';

class ReFillItem extends StatefulWidget {
  ReFillItem({Key key}) : super(key: key);
  @override
  _ReFillItemState createState() => _ReFillItemState();
}

class _ReFillItemState extends State<ReFillItem> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isBusy = false;
  Item itemToSend;
  double quantity;
  // List<String> barcodes = [];
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(builder: (context, child, MainModel model) {
      itemToSend = model.items[model.editItemIndex];
      return Blackout(
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InputField(
                        isDisable: false,
                        initialValue: itemToSend.name,
                        icon: Icons.person,
                        labelText: 'Item name',
                        onSaved: (String value) {
                          itemToSend.name = value;
                        },
                        onValidate: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                        width: 500,
                      ),
                      InputField(
                        icon: Icons.check_circle_outline,
                        labelText: 'ReFill Quantity',
                        onSaved: (String value) {
                          itemToSend.currentQty = double.parse(value);
                        },
                        onValidate: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter Re-Fill quantity';
                          }
                          return null;
                        },
                        width: 500,
                        isNumberOnly: true,
                        initialValue: '',
                      ),
                      InputField(
                        icon: Icons.check_circle_outline,
                        labelText: 'Re Order Quantity',
                        onSaved: (String value) {
                          itemToSend.reOrderQty = double.parse(value);
                        },
                        onValidate: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter Re-Order quantity';
                          }
                          return null;
                        },
                        width: 500,
                        isNumberOnly: true,
                        initialValue: itemToSend.reOrderQty.toStringAsFixed(0),
                      ),
                      InputFieldDropDown(
                        initialValue: itemToSend.priceCategory,
                        icon: Icons.picture_in_picture_alt_outlined,
                        labelText: 'Price Category',
                        onSaved: (String value) {
                          itemToSend.priceCategory = value;
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
                        initialValue: itemToSend.buyPrice.toStringAsFixed(0),
                        icon: Icons.attach_money,
                        labelText: 'Buy Price',
                        onSaved: (String value) {
                          itemToSend.buyPrice = double.parse(value);
                        },
                        onValidate: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter buy price';
                          }
                          return null;
                        },
                        width: 500,
                        isNumberOnly: true,
                      ),
                      InputField(
                        initialValue: itemToSend.sellPrice.toStringAsFixed(0),
                        icon: Icons.monetization_on,
                        labelText: 'Sell Price',
                        onSaved: (String value) {
                          itemToSend.sellPrice = double.parse(value);
                        },
                        onValidate: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter sell price';
                          }
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
                              model.setManageItemPopup(ManageItemPopup.NoPopup);
                            },
                            text: 'Cancel',
                            color: Colors.red,
                          ),
                          LoadingBtn(
                            onPressed: () {
                              _onUpdate(model);
                            },
                            text: 'Re Fill',
                            isBusy: _isBusy,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  // _addBarcode(String code) {
  //   setState(() {
  //     barcodes.add(code);
  //   });
  // }

  _onUpdate(MainModel model) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isBusy = true;
    });
    ApiService.shared.reFillItemCall({
      "name": itemToSend.name,
      "itemId": itemToSend.id,
      "priceCategory": itemToSend.priceCategory,
      "buyPrice": itemToSend.buyPrice,
      "sellPrice": itemToSend.sellPrice,
      "reOrderQty": itemToSend.reOrderQty,
      "qty": itemToSend.currentQty,
    }).then((value) {
      setState(() {
        _isBusy = false;
      });
      if (value.success) {
        model.updateItem(model.editItemIndex, Item.fromJson(value.data));
        model.setManageItemPopup(ManageItemPopup.NoPopup);
      }

      Messages.simpleMessage(head: value.title, body: value.subtitle);
    });
  }
}
