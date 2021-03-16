import 'package:animated_widgets/animated_widgets.dart';
import 'package:communication/helpers/api_service.dart';
import 'package:communication/model/user.dart';
import 'package:communication/scoped_model/main.dart';
import 'package:communication/widgets/Messages.dart';
import 'package:communication/widgets/input_field.dart';
import 'package:communication/widgets/loading_btn.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class Login extends StatefulWidget {
  final Function onClosed;
  Login({Key key, @required this.onClosed}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String userName;
  String password;
  bool isBusy = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _login('admin', 'Test123#');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: OpacityAnimatedWidget(
        enabled: true,
        duration: Duration(milliseconds: 500),
        values: [0, 1],
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black.withOpacity(0.8),
          child: Center(
            child: ScaleAnimatedWidget(
              enabled: true,
              delay: Duration(milliseconds: 300),
              curve: Curves.easeOut,
              duration: Duration(milliseconds: 700),
              values: [0, 1, 1.1, 0.9, 1],
              child: Card(
                color: Colors.white.withOpacity(0.9),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InputField(
                          icon: Icons.person,
                          labelText: 'User Name',
                          onSaved: _userNameSave,
                          onValidate: _userNameValidator,
                          autofocus: true,
                        ),
                        InputField(
                          icon: Icons.security,
                          labelText: 'Password',
                          isObsecure: true,
                          onSaved: _passwordSave,
                          onValidate: _passwordValidator,
                        ),
                        LoadingBtn(
                          onPressed: _onLogin,
                          text: 'LOGIN',
                          isBusy: isBusy,
                        ),
                        LoadingBtn(
                          onPressed: () {
                            widget.onClosed();
                          },
                          text: 'CANCEL',
                          isBusy: false,
                          color: Colors.red,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _userNameValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter user name!';
    }
    return null;
  }

  _userNameSave(String value) {
    userName = value;
  }

  String _passwordValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter password!';
    }
    return null;
  }

  _passwordSave(String value) {
    password = value;
  }

  _onLogin() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      isBusy = true;
    });
    _login(userName, password);
  }

  _login(String usrName, String pswrd) async {
    setState(() {
      isBusy = true;
    });
    ApiService.shared.loginCall(usrName, pswrd).then((value) {
      setState(() {
        isBusy = false;
      });
      if (!value.success) {
        Messages.simpleMessage(
            head: value.title,
            body: value.subtitle,
            onPress: () {
              Navigator.pushReplacementNamed(context, '/landing');
            });
      } else {
        User currentUser = User.fromJson(value.data['user']);
        ScopedModel.of<MainModel>(context).login(currentUser);
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }
}
