import 'package:animated_widgets/animated_widgets.dart';
import 'package:communication/helpers/images.dart';
import 'package:communication/scoped_model/main.dart';
import 'package:communication/widgets/background_image.dart';
import 'package:communication/widgets/drawer_item.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'home_page.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: BackgroundImage(
          image: image6,
          child: ScopedModelDescendant(
            builder: (context, child, MainModel model) => Container(
              child: ListView(
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.orange, width: 5),
                      ),
                      child: Center(
                        child: Text(
                          model.user != null
                              ? model.user.name[0].toUpperCase()
                              : "H",
                          style: TextStyle(
                              fontSize: 50,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SizeAnimatedWidget(
                    enabled: true,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                    values: [Size(0, 100), Size(0, 0)],
                  ),
                  model.user != null && model.user.isAdmin
                      ? Column(
                          children: [
                            DrawerItem(
                                icon: Icons.people,
                                title: 'Manage Users',
                                route: '/manageUsers'),
                            DrawerItem(
                                icon: Icons.shopping_cart,
                                title: 'Manage Pharmacy Items',
                                route: '/manageItems'),
                            DrawerItem(
                                icon: Icons.store,
                                title: 'Sales',
                                route: '/adminSales')
                          ],
                        )
                      : Container(),
                  DrawerItem(
                    icon: Icons.security,
                    title: 'Change Password',
                    onPressed: () {
                      Navigator.pop(context);
                      ScopedModel.of<MainModel>(context)
                          .setHomePagePopup(HomePagePopups.ChangePassword);
                    },
                  ),
                  DrawerItem(
                    icon: Icons.exit_to_app,
                    title: 'Logout',
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/landing');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
