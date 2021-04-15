import 'package:communication/helpers/images.dart';
import 'package:communication/scoped_model/main.dart';
import 'package:communication/views/auth/change_password.dart';
import 'package:communication/views/sales/charge_finder.dart';
import 'package:communication/views/sales/finish_order.dart';
import 'package:communication/views/sales/item_finder.dart';
import 'package:communication/views/sales/sales_page.dart';
import 'package:communication/widgets/Messages.dart';
import 'package:communication/widgets/background_image.dart';
import 'package:communication/widgets/calculator.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'home_page_drawer.dart';

enum HomePagePopups {
  NoPopup,
  ChangePassword,
  ItemFinder,
  FinishOrder,
  ChargeFinder,
  Calculator
}

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Messages.setContext(context);
    return _buildBody(context);
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildBody(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) => Scaffold(
        key: scaffoldKey,
        drawer: HomeDrawer(),
        body: BackgroundImage(
          image: image3,
          child: Stack(
            children: [
              SalesPage(),
              _buildPopup(context),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    backgroundColor: Colors.grey.withOpacity(0.5),
                    key: Key('drawer button'),
                    child: Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      scaffoldKey.currentState.openDrawer();
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopup(BuildContext context) {
    HomePagePopups current = ScopedModel.of<MainModel>(context).currentPopup;
    switch (current) {
      case HomePagePopups.ChangePassword:
        return ChangePassword();
        break;
      case HomePagePopups.ItemFinder:
        return ItemFinder();
        break;
      case HomePagePopups.ChargeFinder:
        return ChargeFinder();
        break;
      case HomePagePopups.FinishOrder:
        return FinishOrder();
        break;
      case HomePagePopups.Calculator:
        return MyCalculator();
        break;
      default:
        return Container();
    }
  }
}
