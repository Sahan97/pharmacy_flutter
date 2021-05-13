import 'package:animated_widgets/animated_widgets.dart';
import 'package:communication/helpers/api_service.dart';
import 'package:communication/model/other_charge.dart';
import 'package:communication/scoped_model/main.dart';
import 'package:communication/views/manage_other_charges/manage_other_charges.dart';
import 'package:communication/widgets/Messages.dart';
import 'package:communication/widgets/item.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class OtherChargeView extends StatefulWidget {
  final OtherCharge item;
  final int index;
  final bool isCashier;
  final Function onPressed;
  const OtherChargeView(
      {Key key,
      @required this.item,
      @required this.index,
      this.isCashier = false,
      this.onPressed})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _OtherChargeViewState();
  }
}

class _OtherChargeViewState extends State<OtherChargeView> {
  bool _isSideBarActive = false;

  @override
  Widget build(BuildContext context) {
    return widget.item.isDeleted
        ? Container()
        : Card(
            elevation: 5,
            color: Colors.white,
            margin: EdgeInsets.only(top: 10),
            child: Stack(
              children: [
                InkWell(
                  onTap: widget.isCashier
                      ? () {
                          widget.onPressed(widget.item);
                        }
                      : null,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      NameView(name: widget.item.name),
                      widget.item.price != null
                          ? PriceView(
                              price: widget.item.price.toDouble(),
                              color: Colors.grey)
                          : Container(),
                      SizedBox(
                        width: 50,
                      )
                    ],
                  ),
                ),
                widget.isCashier
                    ? Container()
                    : Align(
                        alignment: Alignment.centerRight,
                        child: ClipRRect(
                          child: TranslationAnimatedWidget(
                            enabled: _isSideBarActive,
                            duration: Duration(milliseconds: 200),
                            values: [
                              Offset(140, 0),
                              Offset(0, 0),
                              Offset(-5, 0),
                              Offset(5, 0),
                              Offset(0, 0)
                            ],
                            curve: Curves.easeOut,
                            child: sidePannel(),
                          ),
                        ),
                      ),
              ],
            ),
          );
  }

  Widget sidePannel() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.symmetric(vertical: 5),
      width: 170,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(
              _isSideBarActive ? Icons.chevron_right : Icons.chevron_left,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isSideBarActive = !_isSideBarActive;
              });
            },
            padding: EdgeInsets.all(0),
          ),
          SidePanelButton(
              message: "Edit",
              onPressed: _onEdit,
              icon: Icons.edit,
              iconColor: Colors.green),
          SidePanelButton(
              message: "Delete",
              onPressed: _onDelete,
              icon: Icons.delete,
              iconColor: Colors.red),
        ],
      ),
    );
  }

  _onDelete() {
    Messages.confirmMessage(
        head: 'Are you sure?',
        body: 'This action will delete the charge from the list',
        onConfirm: () {
          setState(() {
            _isSideBarActive = false;
          });
          ApiService.shared.deleteOtherCharge(widget.item.id);
          setState(() {
            widget.item.isDeleted = true;
          });
        },
        onCancell: () {
          setState(() {
            _isSideBarActive = false;
          });
        });
  }

  _onEdit() {
    setState(() {
      _isSideBarActive = false;
    });
    ScopedModel.of<MainModel>(context).setEditOtherCharge(widget.index);
    ScopedModel.of<MainModel>(context)
        .setManageOtherChargesPopup(ManageOtherChargesPopup.UpdateCharge);
  }
}

class NameView extends StatelessWidget {
  final String name;
  const NameView({Key key, @required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 50,
        margin: EdgeInsets.only(top: 10),
        child: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
    );
  }
}
