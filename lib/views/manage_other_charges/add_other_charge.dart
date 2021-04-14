import 'package:communication/helpers/api_service.dart';
import 'package:communication/model/other_charge.dart';
import 'package:communication/widgets/Messages.dart';
import 'package:communication/widgets/input_field.dart';
import 'package:communication/widgets/loading_btn.dart';
import 'package:flutter/material.dart';

class AddOtherCharge extends StatefulWidget {
  AddOtherCharge({Key key}) : super(key: key);

  @override
  _AddOtherChargeState createState() => _AddOtherChargeState();
}

class _AddOtherChargeState extends State<AddOtherCharge> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  OtherCharge newCharge = OtherCharge();
  bool _isBusy = false;

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
                  labelText: 'Charge Name',
                  onSaved: (value) {
                    newCharge.name = value;
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
                SizedBox(
                  height: 100,
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

  _onSubmit() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isBusy = true;
    });
    ApiService.shared.createOtherCharge({
      "name": newCharge.name,
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
