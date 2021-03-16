import 'package:communication/helpers/api_service.dart';
import 'package:communication/scoped_model/main.dart';
import 'package:communication/views/home_page/home_page.dart';
import 'package:communication/widgets/Messages.dart';
import 'package:communication/widgets/blackout.dart';
import 'package:communication/widgets/input_field.dart';
import 'package:communication/widgets/loading_btn.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String newPassword;
  String oldPassword;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isBusy = false;
  @override
  Widget build(BuildContext context) {
    return Blackout(
      child: Card(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Change Password',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                InputField(
                  icon: Icons.security,
                  labelText: 'Old Password',
                  onSaved: _oldPasswordSave,
                  onValidate: _oldPasswordValidator,
                  isObsecure: true,
                ),
                InputField(
                  icon: Icons.confirmation_number,
                  labelText: 'New Password',
                  onSaved: _newPasswordSave,
                  onValidate: _newPasswordValidator,
                  isObsecure: true,
                ),
                ButtonBar(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LoadingBtn(
                      onPressed: _onCancel,
                      text: 'Cancel',
                      color: Colors.red,
                    ),
                    LoadingBtn(
                      onPressed: _onSubmit,
                      text: 'Submit',
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

  String _oldPasswordValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter old password';
    }
    return null;
  }

  String _newPasswordValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter new password';
    }
    return null;
  }

  _oldPasswordSave(String value) {
    oldPassword = value;
  }

  _newPasswordSave(String value) {
    newPassword = value;
  }

  _onSubmit() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    setState(() {
      _isBusy = true;
    });
    ApiService.shared
        .changePasswordCall(oldPassword, newPassword)
        .then((value) {
      setState(() {
        _isBusy = false;
      });
      if (value.success) {
        _onCancel();
        Messages.simpleMessage(
            head: 'Sucessfull!',
            body: 'You have successfully changed your password');
      }
    });
  }

  _onCancel() {
    ScopedModel.of<MainModel>(context).setHomePagePopup(HomePagePopups.NoPopup);
  }
}
