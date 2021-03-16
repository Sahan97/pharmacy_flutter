import 'package:communication/helpers/images.dart';
import 'package:communication/scoped_model/main.dart';
import 'package:communication/views/admin_sales_page/admin_sale_view.dart';
import 'package:communication/views/admin_sales_page/all_sales.dart';
import 'package:communication/widgets/Messages.dart';
import 'package:communication/widgets/background_image.dart';
import 'package:communication/widgets/custom_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

enum AdminSalesPagePopup { NoPopup, ItemView }

class AdminSalesPage extends StatefulWidget {
  AdminSalesPage({Key key}) : super(key: key);

  @override
  _AdminSalesPageState createState() => _AdminSalesPageState();
}

class _AdminSalesPageState extends State<AdminSalesPage> {
  @override
  Widget build(BuildContext context) {
    Messages.setContext(context);
    return Scaffold(
      body: ScopedModelDescendant(
        builder: (context, child, MainModel model) => BackgroundImage(
          image: image6,
          child: Stack(
            children: [
              CustomTabView(
                title: 'Sales Page',
                labels: ['All Sales'],
                tabs: [AllSales()],
              ),
              _buildPopup(model)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopup(MainModel model) {
    switch (model.adminSalePagePopup) {
      case AdminSalesPagePopup.ItemView:
        return AdminSaleView();
        break;
      default:
        return Container();
    }
  }
}
