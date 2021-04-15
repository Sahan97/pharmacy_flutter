import 'package:communication/helpers/images.dart';
import 'package:communication/scoped_model/main.dart';
import 'package:communication/views/manage_pharmacy_items/add_from_excel.dart';
import 'package:communication/views/manage_pharmacy_items/add_item.dart';
import 'package:communication/views/manage_pharmacy_items/all_items.dart';
import 'package:communication/views/manage_pharmacy_items/edit_item.dart';
import 'package:communication/views/manage_pharmacy_items/re_fill_item.dart';
import 'package:communication/widgets/Messages.dart';
import 'package:communication/widgets/background_image.dart';
import 'package:communication/widgets/custom_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:communication/views/manage_pharmacy_items/re_order_list.dart';

enum ManageItemPopup { NoPopup, EditItem, ReFillItem }

class ManageItems extends StatelessWidget {
  const ManageItems({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Messages.setContext(context);
    return Scaffold(
      body: ScopedModelDescendant(
        builder: (context, child, MainModel model) => BackgroundImage(
          image: image4,
          child: Stack(
            children: [
              CustomTabView(
                title: 'Manage Pharmacy Items',
                labels: [
                  'All Items',
                  'Add New Item',
                  'Add From Excel',
                  'Re Order List'
                ],
                tabs: [AllItems(), AddItem(), AddFromExcel(), ReOrderList()],
              ),
              _buildPopup(model)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopup(MainModel model) {
    switch (model.manageItemCurrentPopup) {
      case ManageItemPopup.EditItem:
        return EditItem();
        break;
      case ManageItemPopup.ReFillItem:
        return ReFillItem();
        break;
      default:
        return Container();
    }
  }
}
