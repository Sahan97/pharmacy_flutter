import 'package:communication/helpers/api_service.dart';
import 'package:communication/widgets/Messages.dart';
import 'package:communication/widgets/input_field.dart';
import 'package:communication/widgets/loading_btn.dart';
import 'package:flutter/material.dart';

final String defaultPassword = 'Welcome@123';

class AddNewUser extends StatefulWidget {
  AddNewUser({Key key}) : super(key: key);

  @override
  _AddNewUserState createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {
  String name;
  String userName;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: '');
  final userNameController = TextEditingController(text: '');

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputField(
              autofocus: true,
              width: 500,
              icon: Icons.person,
              labelText: 'Name',
              onSaved: _nameSave,
              onValidate: _nameValidate,
              controller: nameController,
            ),
            InputField(
              width: 500,
              icon: Icons.person_pin,
              labelText: 'User Name',
              onSaved: _userNameSave,
              onValidate: _userNameValidate,
              controller: userNameController,
            ),
            Container(
              child: Text(
                "* Default password  '$defaultPassword'",
                style: TextStyle(color: Colors.red),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              child: LoadingBtn(
                onPressed: _add,
                text: 'Add',
                isBusy: _isBusy,
              ),
            )
          ],
        ),
      ),
    );
  }

  String _nameValidate(String value) {
    if (value.isEmpty) {
      return 'Please enter Name';
    }
    return null;
  }

  String _userNameValidate(String value) {
    if (value.isEmpty) {
      return 'Please enter User Name';
    }
    return null;
  }

  _nameSave(String value) {
    name = value;
  }

  _userNameSave(String value) {
    userName = value;
  }

  _add() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isBusy = true;
    });
    ApiService.shared.registerCall({
      "name": name,
      "userName": userName,
    }).then((value) {
      setState(() {
        _isBusy = false;
      });

      if (value.success) {
        Messages.simpleMessage(
            head: value.title, body: value.subtitle, onPress: () {});
        nameController.text = '';
        userNameController.text = '';
      }
    });
  }
}
