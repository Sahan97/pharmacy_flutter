import 'package:communication/helpers/api_service.dart';
import 'package:communication/model/other_charge.dart';
import 'package:communication/scoped_model/main.dart';
import 'package:communication/views/manage_other_charges/manage_other_charges.dart';
import 'package:communication/widgets/Messages.dart';
import 'package:communication/widgets/blackout.dart';
import 'package:communication/widgets/input_field.dart';
import 'package:communication/widgets/loading_btn.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UpdateOtherCharge extends StatefulWidget {
  UpdateOtherCharge({Key key}) : super(key: key);
  @override
  _UpdateOtherChargeState createState() => _UpdateOtherChargeState();
}

class _UpdateOtherChargeState extends State<UpdateOtherCharge> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isBusy = false;
  OtherCharge itemToSend = OtherCharge(isDeleted: false);
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
                              initialValue: model
                                  .otherCharges[model.editOtherChargeIndex]
                                  .name,
                              icon: Icons.note_add,
                              labelText: 'Charge Name',
                              onSaved: (value) {
                                itemToSend.name = value;
                                itemToSend.id = model
                                    .otherCharges[model.editOtherChargeIndex]
                                    .id;
                              },
                              onValidate: (String value) {
                                if (value.isEmpty) {
                                  return 'Please enter charge name';
                                }
                                return null;
                              },
                              autofocus: true,
                              width: 500,
                            ),
                            InputField(
                              initialValue: model
                                          .otherCharges[
                                              model.editOtherChargeIndex]
                                          .price !=
                                      null
                                  ? model
                                      .otherCharges[model.editOtherChargeIndex]
                                      .price
                                      .toString()
                                  : ' ',
                              icon: Icons.attach_money_outlined,
                              labelText: 'Price',
                              onSaved: (String value) {
                                itemToSend.price =
                                    value.isEmpty ? null : int.parse(value);
                              },
                              onValidate: (String value) {
                                return null;
                              },
                              autofocus: true,
                              width: 500,
                            ),
                            SizedBox(
                              height: 100,
                            ),
                            ButtonBar(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                LoadingBtn(
                                  onPressed: () {
                                    model.setManageOtherChargesPopup(
                                        ManageOtherChargesPopup.NoPopup);
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
    ApiService.shared.updateOtherChargeCall({
      "id": itemToSend.id,
      "name": itemToSend.name,
      "price": itemToSend.price,
    }).then((value) {
      setState(() {
        _isBusy = false;
      });
      if (value.success) {
        model.otherCharges[model.editOtherChargeIndex] = itemToSend;
        model.setManageOtherChargesPopup(ManageOtherChargesPopup.NoPopup);
      }
      Messages.simpleMessage(head: value.title, body: value.subtitle);
    });
  }
}
