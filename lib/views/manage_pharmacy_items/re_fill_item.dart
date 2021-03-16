import 'package:communication/helpers/api_service.dart';
import 'package:communication/model/item.dart';
import 'package:communication/scoped_model/main.dart';
import 'package:communication/views/manage_pharmacy_items/manage_items.dart';
import 'package:communication/widgets/Messages.dart';
import 'package:communication/widgets/blackout.dart';
import 'package:communication/widgets/chip_input.dart';
import 'package:communication/widgets/input_field.dart';
import 'package:communication/widgets/loading_btn.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

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
  List<String> barcodes = [];
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
                        isDisable: true,
                        initialValue: itemToSend.name,
                        icon: Icons.person,
                        labelText: 'Item name',
                        onSaved: (String value) {},
                        onValidate: (String value) {
                          return null;
                        },
                        width: 400,
                      ),
                      // InputField(
                      //   autofocus: true,
                      //   initialValue: itemToSend.buy.seller,
                      //   icon: Icons.person,
                      //   labelText: 'Seller\'s name',
                      //   onSaved: (String value) {
                      //     if (value.isEmpty) {
                      //       itemToSend.buy.seller = 'unknown seller';
                      //     } else {
                      //       itemToSend.buy.seller = value;
                      //     }
                      //   },
                      //   onValidate: (String value) {
                      //     return null;
                      //   },
                      //   width: 400,
                      // ),
                      // InputField(
                      //   icon: Icons.check_circle_outline,
                      //   labelText: 'ReFill Quantity',
                      //   onSaved: (String value) {
                      //     quantity = double.parse(value);
                      //   },
                      //   onValidate: (String value) {
                      //     if (value.isEmpty) {
                      //       return 'Please enter Re-Fill quantity';
                      //     }
                      //     return null;
                      //   },
                      //   width: 400,
                      //   isNumberOnly: true,
                      // ),
                      // InputField(
                      //   initialValue:
                      //       itemToSend.buy.buyPricePerItem.toStringAsFixed(0),
                      //   icon: Icons.attach_money,
                      //   labelText: 'Buy Price',
                      //   onSaved: (String value) {
                      //     itemToSend.buy.buyPricePerItem = double.parse(value);
                      //   },
                      //   onValidate: (String value) {
                      //     if (value.isEmpty) {
                      //       return 'Please enter buy price';
                      //     }
                      //     return null;
                      //   },
                      //   width: 400,
                      //   isNumberOnly: true,
                      // ),
                      // InputField(
                      //   initialValue:
                      //       itemToSend.sellPricePerItem.toStringAsFixed(0),
                      //   icon: Icons.monetization_on,
                      //   labelText: 'Sell Price',
                      //   onSaved: (String value) {
                      //     itemToSend.sellPricePerItem = double.parse(value);
                      //   },
                      //   onValidate: (String value) {
                      //     if (value.isEmpty) {
                      //       return 'Please enter sell price';
                      //     }
                      //     return null;
                      //   },
                      //   width: 400,
                      //   isNumberOnly: true,
                      // ),
                      // InputField(
                      //   initialValue: itemToSend.discount.toStringAsFixed(0),
                      //   icon: Icons.money_off,
                      //   labelText: 'Discount',
                      //   onSaved: (String value) {
                      //     if (value.isEmpty) {
                      //       itemToSend.discount = 0;
                      //     } else {
                      //       itemToSend.discount = double.parse(value);
                      //     }
                      //   },
                      //   onValidate: (String value) {
                      //     return null;
                      //   },
                      //   width: 400,
                      //   isNumberOnly: true,
                      // ),
                      // MyChipInput(
                      //   myListCustom: barcodes,
                      //   addChips: _addBarcode,
                      // ),
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
                            text: 'Update',
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

  _addBarcode(String code) {
    setState(() {
      barcodes.add(code);
    });
  }

  _onUpdate(MainModel model) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isBusy = true;
    });
    ApiService.shared.reFillItemCall({
      "quantity": quantity,
      // "sellPrice": itemToSend.sellPricePerItem,
      // "discount": itemToSend.discount,
      // "seller": itemToSend.buy.seller,
      // "buyPrice": itemToSend.buy.buyPricePerItem,
      // "itemId": itemToSend.id,
      "barcodes": barcodes
    }).then((value) {
      setState(() {
        _isBusy = false;
      });
      // itemToSend.availableQuantity = itemToSend.availableQuantity + quantity;
      model.items[model.editItemIndex] = itemToSend;
      model.setManageItemPopup(ManageItemPopup.NoPopup);
      Messages.simpleMessage(
          head: 'Successfull!', body: 'You have successfully Re-Fill the item');
    });
  }
}
