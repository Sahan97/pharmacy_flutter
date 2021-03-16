import 'dart:io';
import 'package:flutter/material.dart';

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
              FlatButton(
                child: Text(
                  'ok',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  if (onPress != null) {
                    onPress();
                  }
                  Navigator.pop(context);
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
              FlatButton(
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
              FlatButton(
                child: Text(
                  'exit',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  exit(0);
                },
              ),
              FlatButton(
                child: Text(
                  'try again',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
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
              FlatButton(
                child: Text(
                  'cancel',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  onCancell();
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(
                  'confirm',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  onConfirm();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
