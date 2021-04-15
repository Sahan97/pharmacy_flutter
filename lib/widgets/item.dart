import 'package:animated_widgets/animated_widgets.dart';
import 'package:communication/helpers/api_service.dart';
import 'package:communication/model/item.dart';
import 'package:communication/scoped_model/main.dart';
import 'package:communication/views/manage_pharmacy_items/manage_items.dart';
import 'package:communication/widgets/Messages.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ItemView extends StatefulWidget {
  final Item item;
  final int index;
  final bool isCashier;
  final Function onPressed;
  const ItemView(
      {Key key,
      @required this.item,
      @required this.index,
      this.isCashier = false,
      this.onPressed})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ItemViewState();
  }
}

class _ItemViewState extends State<ItemView> {
  bool _isSideBarActive = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: !widget.item.isActive ? Colors.red.withOpacity(0.3) : Colors.white,
      margin: EdgeInsets.only(top: 10),
      child: Stack(
        children: [
          InkWell(
            onTap: widget.isCashier
                ? () {
                    if (widget.item.currentQty > 0 &&
                        widget.item.sellPrice != null &&
                        widget.item.sellPrice > 0) {
                      widget.onPressed(widget.item);
                    }
                  }
                : () {
                    setState(() {
                      _isSideBarActive = false;
                    });
                  },
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                CodeView(
                  code: widget.item.code,
                ),
                NameView(
                    name:
                        '${widget.item.name} ${widget.item.priceCategory.isEmpty ? '' : ' - (${widget.item.priceCategory})'}'),
                PriceView(price: widget.item.currentQty, color: Colors.grey),
                widget.isCashier
                    ? Container()
                    : PriceView(
                        price: widget.item.buyPrice, color: Colors.blue),
                PriceView(price: widget.item.sellPrice, color: Colors.green),
                SizedBox(
                  width: 20,
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
                        Offset(193, 0),
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
      width: 220,
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
          Tooltip(
            message: 'Re-Fill',
            child: FloatingActionButton(
              key: Key('refill btn'),
              onPressed: _onReFill,
              child: Icon(
                Icons.settings_backup_restore,
                color: Colors.blue,
              ),
              backgroundColor: Colors.white,
            ),
          ),
          Tooltip(
            message: 'Edit',
            child: FloatingActionButton(
              key: Key('edit btn'),
              onPressed: _onEdit,
              child: Icon(
                Icons.edit,
                color: Colors.green,
              ),
              backgroundColor: Colors.white,
            ),
          ),
          Tooltip(
            message: !widget.item.isActive ? 'Activate' : 'Deactivate',
            child: FloatingActionButton(
              key: Key('delete btn'),
              onPressed: _onDelete,
              child: Icon(
                !widget.item.isActive ? Icons.restore_from_trash : Icons.delete,
                color: !widget.item.isActive ? Colors.green : Colors.red,
              ),
              backgroundColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  _onDelete() {
    Messages.confirmMessage(
        head: 'Are you sure?',
        body:
            'This action will \'${!widget.item.isActive ? 'SHOW' : 'Hide'}\' item from cashier\'s list',
        onConfirm: () {
          setState(() {
            _isSideBarActive = false;
          });
          ApiService.shared
              .itemActiveInactive(widget.item.id, !widget.item.isActive);
          setState(() {
            widget.item.isActive = !widget.item.isActive;
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
    ScopedModel.of<MainModel>(context).setEditItem(widget.index);
    ScopedModel.of<MainModel>(context)
        .setManageItemPopup(ManageItemPopup.EditItem);
  }

  _onReFill() {
    setState(() {
      _isSideBarActive = false;
    });
    ScopedModel.of<MainModel>(context).setEditItem(widget.index);
    ScopedModel.of<MainModel>(context)
        .setManageItemPopup(ManageItemPopup.ReFillItem);
  }
}

class PriceView extends StatelessWidget {
  final double price;
  final Color color;
  const PriceView({
    Key key,
    @required this.price,
    @required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (price == 0 || price == null)
        ? Container(
            width: 90,
            height: 50,
          )
        : Container(
            width: 80,
            height: 50,
            margin: EdgeInsets.only(right: 10, top: 5, bottom: 5),
            decoration: BoxDecoration(
                border: Border.all(color: color, width: 3),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white),
            child: Center(
              child: Text(
                price.toStringAsFixed(0),
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          );
  }
}

class CodeView extends StatelessWidget {
  final String code;
  const CodeView({
    Key key,
    @required this.code,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 50,
      margin: EdgeInsets.only(right: 10, top: 5, bottom: 5),
      child: code == null
          ? Container()
          : Center(
              child: Text(
                code,
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
            ),
    );
  }
}

class NameView extends StatelessWidget {
  final String name;
  const NameView({Key key, @required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
    );
  }
}
