import 'package:communication/helpers/images.dart';
import 'package:communication/widgets/Messages.dart';
import 'package:communication/widgets/background_image.dart';
import 'package:communication/widgets/custom_tab_view.dart';
import 'package:flutter/material.dart';

import 'add_new_user.dart';
import 'all_users.dart';

enum Tabs { AddUser, AllUsers }

class ManageUsers extends StatelessWidget {
  ManageUsers({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Messages.setContext(context);
    return Scaffold(
      body: BackgroundImage(
        image: image6,
        child: CustomTabView(title: 'Manage Users', labels: [
          'Add New User',
          'All Users'
        ], tabs: [
          AddNewUser(),
          AllUsers()
        ]),
      ),
    );
  }
}
