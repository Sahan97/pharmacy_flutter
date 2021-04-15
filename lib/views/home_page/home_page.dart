import 'package:communication/helpers/images.dart';
import 'package:communication/scoped_model/main.dart';
import 'package:communication/views/auth/change_password.dart';
import 'package:communication/views/sales/charge_finder.dart';
import 'package:communication/views/sales/finish_order.dart';
import 'package:communication/views/sales/item_finder.dart';
import 'package:communication/views/sales/sales_page.dart';
import 'package:communication/widgets/Messages.dart';
import 'package:communication/widgets/my_app_bar.dart';
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

  Widget _buildBody(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) => Scaffold(
        appBar: MyAppBar(
          appBar: AppBar(),
          title: 'Hello, ${model.user != null ? model.user.name : ''}',
        ),
        drawer: HomeDrawer(),
        body: BackgroundImage(
          image: image3,
          child: Stack(
            children: [SalesPage(), _buildPopup(context)],
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
