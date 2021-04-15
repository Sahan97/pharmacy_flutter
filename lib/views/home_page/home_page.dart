import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:communication/helpers/images.dart';
import 'package:communication/scoped_model/main.dart';
import 'package:communication/views/auth/change_password.dart';
import 'package:communication/views/sales/charge_finder.dart';
import 'package:communication/views/sales/finish_order.dart';
import 'package:communication/views/sales/item_finder.dart';
import 'package:communication/views/sales/sales_page.dart';
import 'package:communication/widgets/Messages.dart';
import 'package:communication/widgets/background_image.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'home_page_drawer.dart';

enum HomePagePopups {
  NoPopup,
  ChangePassword,
  ItemFinder,
  FinishOrder,
  ChargeFinder
}

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Messages.setContext(context);
    return _buildBody(context);
  }

  final minButtonColors = WindowButtonColors(
    iconNormal: Colors.white,
    mouseOver: Color(0xFFF6A00C),
    mouseDown: Color(0xFF805306),
    iconMouseOver: Colors.white,
  );

  final maxButtonColors = WindowButtonColors(
    iconNormal: Colors.white,
    mouseOver: Colors.green,
    mouseDown: Color(0xFF805306),
    iconMouseOver: Colors.white,
  );

  final closeButtonColors = WindowButtonColors(
    iconNormal: Colors.white,
    mouseOver: Color(0xFFD32F2F),
    mouseDown: Color(0xFFB71C1C),
    iconMouseOver: Colors.white,
  );

  Widget _buildBody(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) => Scaffold(
        appBar: AppBar(
          // title: Text('Hello, ${model.user != null ? model.user.name : ''}'),
          actions: [
            SizedBox(
              width: 100,
            ),
            Expanded(
              child: MoveWindow(
                child: Center(
                  widthFactor: 1,
                  child: Text(
                    'Hello, ${model.user != null ? model.user.name : ''}',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            _myWindowButton(
              child: MinimizeWindowButton(
                colors: minButtonColors,
                animate: true,
              ),
            ),
            _myWindowButton(
              child: MaximizeWindowButton(
                colors: maxButtonColors,
                animate: true,
              ),
            ),
            _myWindowButton(
              child: CloseWindowButton(
                colors: closeButtonColors,
                animate: true,
              ),
            )
          ],
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

  Widget _myWindowButton({@required Widget child}) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white.withOpacity(0.8), width: 2)),
        margin: EdgeInsets.symmetric(horizontal: 3),
        height: 40,
        width: 40,
        child: ClipRRect(borderRadius: BorderRadius.circular(40), child: child),
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
      default:
        return Container();
    }
  }
}
