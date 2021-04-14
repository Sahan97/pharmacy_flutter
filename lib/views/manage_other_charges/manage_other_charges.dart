import 'package:communication/helpers/images.dart';
import 'package:communication/scoped_model/main.dart';
import 'package:communication/views/manage_other_charges/add_other_charge.dart';
import 'package:communication/views/manage_other_charges/all_other_charges.dart';
import 'package:communication/views/manage_other_charges/edit_other_charge.dart';
import 'package:communication/widgets/Messages.dart';
import 'package:communication/widgets/background_image.dart';
import 'package:communication/widgets/custom_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

enum ManageOtherChargesPopup { NoPopup, UpdateCharge }

class ManageOtherCharges extends StatelessWidget {
  const ManageOtherCharges({Key key}) : super(key: key);

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
                title: 'Manage Other Charges',
                labels: ['All Charges', 'Add New Charge'],
                tabs: [
                  AllOtherCharges(),
                  AddOtherCharge(),
                ],
              ),
              _buildPopup(model)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopup(MainModel model) {
    switch (model.manageOtherChargesCurrentPopup) {
      case ManageOtherChargesPopup.UpdateCharge:
        return UpdateOtherCharge();
        break;
      default:
        return Container();
    }
  }
}
