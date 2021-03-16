import 'package:communication/helpers/api_service.dart';
import 'package:communication/model/user.dart';
import 'package:communication/widgets/Messages.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'add_new_user.dart';

class AllUsers extends StatefulWidget {
  AllUsers({Key key}) : super(key: key);

  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  bool _isBusy = false;
  List<User> allUsers = [];

  @override
  void initState() {
    _loadUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _isBusy
          ? Center(
              child: SizedBox(
                  width: 100,
                  child: LoadingIndicator(indicatorType: Indicator.lineScale)),
            )
          : allUsers.length == 0
              ? Center(
                  child: Text('No Users'),
                )
              : ListView.builder(
                  itemBuilder: (context, index) => _userItem(allUsers[index]),
                  itemCount: allUsers.length,
                ),
    );
  }

  _loadUsers() {
    setState(() {
      _isBusy = true;
    });
    ApiService.shared.getAllUsersCall().then((value) {
      setState(() {
        _isBusy = false;
      });
      setState(() {
        allUsers = value;
      });
    });
  }

  _userItem(User user) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Card(
        color: user.isDeleted ? Colors.red.shade100 : Colors.white,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 3),
                  shape: BoxShape.circle),
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(10),
              child: Icon(Icons.person),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                  Text(user.userName),
                ],
              ),
            ),
            Container(
              child: ButtonBar(
                children: [
                  Tooltip(
                    message: 'Reset Password to default',
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: IconButton(
                          icon: Icon(
                            Icons.security,
                            size: 30,
                            color: Colors.orange,
                          ),
                          onPressed: () {
                            _resetPassword(user);
                          }),
                    ),
                  ),
                  Tooltip(
                    message: user.isAdmin ? "Make as Cashier" : "Make as Admin",
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: IconButton(
                          icon: Icon(
                            Icons.person_pin,
                            size: 30,
                            color: user.isAdmin ? Colors.green : Colors.grey,
                          ),
                          onPressed: () {
                            _updateRole(user);
                          }),
                    ),
                  ),
                  Tooltip(
                    message: user.isDeleted ? "Unblock User" : "Block User",
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: IconButton(
                          icon: Icon(
                            user.isDeleted
                                ? Icons.restore_from_trash
                                : Icons.delete,
                            size: 30,
                            color: user.isDeleted ? Colors.green : Colors.red,
                          ),
                          onPressed: () {
                            _deleteRecover(user);
                          }),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _updateRole(User u) {
    Messages.confirmMessage(
        head: 'Are you sure?',
        body:
            'This action will make ${u.name} as ${u.isAdmin ? 'Cashier' : 'Admin'}.',
        onConfirm: () {
          ApiService.shared.updateRoleCall(
              {'isAdmin': !u.isAdmin, 'userId': u.id}).then((value) {
            if (value.success) {
              Messages.simpleMessage(head: value.title, body: value.subtitle);
              setState(() {
                u.isAdmin = !u.isAdmin;
              });
            }
          });
        },
        onCancell: () {});
  }

  _deleteRecover(User u) {
    Messages.confirmMessage(
        head: 'Are you sure?',
        body: u.isDeleted
            ? 'This action will UNBLOCK ${u.name}\'s account.'
            : 'This action will BLOCK ${u.name}\'s account ',
        onConfirm: () {
          ApiService.shared.updateIsDelete(
              {'userId': u.id, 'status': !u.isDeleted}).then((value) {
            if (value.success) {
              Messages.simpleMessage(head: value.title, body: value.subtitle);
              setState(() {
                u.isDeleted = !u.isDeleted;
              });
            }
          });
        },
        onCancell: () {});
  }

  _resetPassword(User u) {
    Messages.confirmMessage(
        head: 'Are you sure?',
        body:
            'This action will reset ${u.name}\'s password to \'$defaultPassword\'',
        onConfirm: () {
          ApiService.shared.resetPasswordCall({'userId': u.id}).then((value) {
            if (value.success) {
              Messages.simpleMessage(head: value.title, body: value.subtitle);
            }
          });
        },
        onCancell: () {});
  }
}
