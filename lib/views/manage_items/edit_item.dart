import 'package:communication/helpers/api_service.dart';
import 'package:communication/model/item.dart';
import 'package:communication/scoped_model/main.dart';
import 'package:communication/views/manage_items/manage_items.dart';
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

class _EditItemState extends State<EditItem> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isBusy = false;
  Item itemToSend = Item(isDeleted: false);
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
                              initialValue: model
                                  .items[model.editItemIndex].availableQuantity
                                  .toStringAsFixed(0),
                              icon: Icons.check_circle_outline,
                              labelText: 'Available Quantity',
                              onSaved: (String value) {
                                if (value.isEmpty) {
                                  itemToSend.availableQuantity = 0;
                                } else {
                                  itemToSend.availableQuantity =
                                      double.parse(value);
                                }
                              },
                              onValidate: (String value) {
                                return null;
                              },
                              width: 400,
                              isNumberOnly: true,
                            ),
                            InputField(
                              initialValue: model
                                  .items[model.editItemIndex].sellPricePerItem
                                  .toStringAsFixed(0),
                              icon: Icons.monetization_on,
                              labelText: 'Sell Price',
                              onSaved: (String value) {
                                itemToSend.sellPricePerItem =
                                    double.parse(value);
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
                              initialValue: model
                                  .items[model.editItemIndex].discount
                                  .toStringAsFixed(0),
                              icon: Icons.money_off,
                              labelText: 'Discount',
                              onSaved: (String value) {
                                if (value.isEmpty) {
                                  itemToSend.discount = 0;
                                } else {
                                  itemToSend.discount = double.parse(value);
                                }
                              },
                              onValidate: (String value) {
                                return null;
                              },
                              width: 400,
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
    print(itemToSend.toJson());
    ApiService.shared.updateItemCall({
      "name": itemToSend.name,
      "isDeleted": false,
      "quantity": itemToSend.availableQuantity,
      "sellPrice": itemToSend.sellPricePerItem,
      "discount": itemToSend.discount,
      "itemId": itemToSend.id
    }).then((value) {
      setState(() {
        _isBusy = false;
      });
      if (value.message == 'item_name_exist') {
        Item item = Item.fromJson(value.data);
        Messages.simpleMessage(
            head: 'Item Name Already exists!',
            body: 'Item name you entered \'${item.name}\' is already exists.');
      } else {
        itemToSend.buy = model.items[model.editItemIndex].buy;
        model.items[model.editItemIndex] = itemToSend;
        model.setManageItemPopup(ManageItemPopup.NoPopup);
        Messages.simpleMessage(
            head: 'Successfull!',
            body: 'You have successfully updated the item');
      }
    });
  }
}
