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

class EditItem extends StatefulWidget {
  EditItem({Key key}) : super(key: key);
  @override
  _EditItemState createState() => _EditItemState();
}

final priceCategories = ["ONE", "BOTTLE", "TUBE", "ML"];

class _EditItemState extends State<EditItem> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isBusy = false;
  Item itemToSend = Item(isActive: true);
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (context, child, MainModel model) => Blackout(
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
                              initialValue:
                                  model.items[model.editItemIndex].name,
                              icon: Icons.note_add,
                              labelText: 'Item Name',
                              onSaved: (value) {
                                itemToSend.name = value;
                                itemToSend.id =
                                    model.items[model.editItemIndex].id;
                                itemToSend.buyPrice =
                                    model.items[model.editItemIndex].buyPrice;
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
                              initialValue:
                                  model.items[model.editItemIndex].code,
                              icon: Icons.note_add,
                              labelText: 'Item Code',
                              onSaved: (value) {
                                itemToSend.code = value;
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
                            InputField(
                              initialValue: model
                                  .items[model.editItemIndex].sellPrice
                                  .toStringAsFixed(0),
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
                            InputFieldDropDown(
                              initialValue: model
                                  .items[model.editItemIndex].priceCategory,
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
                              initialValue: model
                                  .items[model.editItemIndex].currentQty
                                  .toStringAsFixed(0),
                              icon: Icons.check_circle_outline,
                              labelText: 'Current Quantity',
                              onSaved: (String value) {
                                if (value.isEmpty) {
                                  itemToSend.currentQty = 0;
                                } else {
                                  itemToSend.currentQty = double.parse(value);
                                }
                              },
                              onValidate: (String value) {
                                return null;
                              },
                              width: 500,
                              isNumberOnly: true,
                            ),
                            InputField(
                              initialValue: model
                                  .items[model.editItemIndex].reOrderQty
                                  .toStringAsFixed(0),
                              icon: Icons.check_circle_outline,
                              labelText: 'Re Order Quantity',
                              onSaved: (String value) {
                                if (value.isEmpty) {
                                  itemToSend.reOrderQty = 0;
                                } else {
                                  itemToSend.reOrderQty = double.parse(value);
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
                                    model.setManageItemPopup(
                                        ManageItemPopup.NoPopup);
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
            ));
  }

  _onUpdate(MainModel model) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isBusy = true;
    });
    ApiService.shared.updateItemCall({
      "itemId": itemToSend.id,
      "name": itemToSend.name,
      "code": itemToSend.code,
      "sellPrice": itemToSend.sellPrice,
      "priceCategory": itemToSend.priceCategory,
      "currentQty": itemToSend.currentQty,
      "reOrderQty": itemToSend.reOrderQty,
    }).then((value) {
      setState(() {
        _isBusy = false;
      });
      if (value.success) {
        model.items[model.editItemIndex] = itemToSend;
        model.setManageItemPopup(ManageItemPopup.NoPopup);
      }
      Messages.simpleMessage(head: value.title, body: value.subtitle);
    });
  }
}
