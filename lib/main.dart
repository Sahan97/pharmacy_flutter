import 'package:communication/helpers/shop_details.dart';
import 'package:communication/scoped_model/main.dart';
import 'package:communication/views/admin_sales_page/Admin_sales_page.dart';
import 'package:communication/views/landing_page.dart';
import 'package:communication/views/manage_other_charges/manage_other_charges.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'views/home_page/home_page.dart';
import 'views/manage_pharmacy_items/manage_items.dart';
import 'views/manage_users/manage_users.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: MainModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: shopName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LandingPage(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/landing':
              return MaterialPageRoute(
                builder: (context) => LandingPage(),
              );
              break;
            case '/home':
              return MaterialPageRoute(
                builder: (context) => HomePage(),
              );
              break;
            case '/manageUsers':
              return MaterialPageRoute(
                builder: (context) => ManageUsers(),
              );
              break;
            case '/manageItems':
              return MaterialPageRoute(
                builder: (context) => ManageItems(),
              );
              break;

            case '/otherCharges':
              return MaterialPageRoute(
                builder: (context) => ManageOtherCharges(),
              );
              break;
            case '/adminSales':
              return MaterialPageRoute(
                builder: (context) => AdminSalesPage(),
              );
              break;

            default:
              return MaterialPageRoute(
                builder: (contxt) => LandingPage(),
              );
          }
        },
      ),
    );
  }
}
