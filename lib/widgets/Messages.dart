import 'dart:io';
import 'package:communication/scoped_model/main.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class Messages {
  static BuildContext context;

  static setContext(_context) {
    context = _context;
  }

  static simpleMessage(
      {@required String head, @required String body, Function onPress}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(head),
            content: Text(body),
            actions: <Widget>[
              TextButton(
                focusNode: ScopedModel.of<MainModel>(context).messageFocusNode,
                child: Text(
                  'ok',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  if (onPress != null) {
                    onPress();
                  }
                  Navigator.pop(context);
                  ScopedModel.of<MainModel>(context).focusSalesPage();
                },
              )
            ],
          );
        });
  }

  static requestError() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Something went wrong!'),
            content: Text('Please try again later!'),
            actions: <Widget>[
              TextButton(
                focusNode: ScopedModel.of<MainModel>(context).messageFocusNode,
                child: Text(
                  'ok',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/landing');
                },
              )
            ],
          );
        });
  }

  static noInternet() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No Internet!'),
            content:
                Text('Please check your internet connection and try again.'),
            actions: <Widget>[
              // TextButton(
              //   child: Text(
              //     'exit',
              //     style: TextStyle(color: Colors.red),
              //   ),
              //   onPressed: () {
              //     exit(0);
              //   },
              // ),
              TextButton(
                child: Text(
                  'try again',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  // Navigator.pushReplacementNamed(context, '/login');
                },
              )
            ],
          );
        });
  }

  static confirmMessage(
      {@required String head,
      @required String body,
      @required Function onConfirm,
      @required Function onCancell}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(head),
            content: Text(body),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'cancel',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  onCancell();
                  Navigator.pop(context);
                },
              ),
              TextButton(
                focusNode: ScopedModel.of<MainModel>(context).messageFocusNode,
                child: Text(
                  'confirm',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  onConfirm();
                  Navigator.pop(context);
                  ScopedModel.of<MainModel>(context).focusSalesPage();
                },
              ),
            ],
          );
        });
  }
}
