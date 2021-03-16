import 'package:animated_widgets/animated_widgets.dart';
import 'package:communication/helpers/api_service.dart';
import 'package:communication/model/item.dart';
import 'package:communication/scoped_model/main.dart';
import 'package:communication/views/manage_items/manage_items.dart';
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
      color: widget.item.isDeleted ? Colors.red.withOpacity(0.7) : Colors.white,
      margin: EdgeInsets.only(top: 10),
      child: Stack(
        children: [
          InkWell(
            onTap: widget.isCashier
                ? () {
                    if (widget.item.availableQuantity > 0) {
                      widget.onPressed(widget.item);
                    }
                  }
                : null,
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                NameView(name: widget.item.name),
                PriceView(
                    price: widget.item.availableQuantity, color: Colors.grey),
                widget.isCashier
                    ? Container()
                    : PriceView(
                        price: widget.item.buy.buyPricePerItem,
                        color: Colors.blue),
                PriceView(
                    price: widget.item.sellPricePerItem, color: Colors.green),
                PriceView(
                    price: widget.item.discount,
                    color: Colors.orange,
                    isDiscount: true),
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
          FloatingActionButton(
            key: Key('refill btn'),
            onPressed: widget.item.isDeleted ? null : _onReFill,
            child: Icon(
              Icons.settings_backup_restore,
              color: Colors.blue,
            ),
            backgroundColor: widget.item.isDeleted
                ? Colors.grey.withOpacity(0.5)
                : Colors.white,
          ),
          FloatingActionButton(
            key: Key('edit btn'),
            onPressed: widget.item.isDeleted ? null : _onEdit,
            child: Icon(
              Icons.edit,
              color: Colors.green,
            ),
            backgroundColor: widget.item.isDeleted
                ? Colors.grey.withOpacity(0.5)
                : Colors.white,
          ),
          FloatingActionButton(
            key: Key('delete btn'),
            onPressed: _onDelete,
            child: Icon(
              widget.item.isDeleted ? Icons.restore_from_trash : Icons.delete,
              color: widget.item.isDeleted ? Colors.green : Colors.red,
            ),
            backgroundColor: Colors.white,
          )
        ],
      ),
    );
  }

  _onDelete() {
    Messages.confirmMessage(
        head: 'Are you sure?',
        body:
            'This action will \'${widget.item.isDeleted ? 'SHOW' : 'Hide'}\' item from cashier\'s list',
        onConfirm: () {
          setState(() {
            _isSideBarActive = false;
          });
          ApiService.shared
              .deleteOrRestoreCall(widget.item.id, !widget.item.isDeleted);
          setState(() {
            widget.item.isDeleted = !widget.item.isDeleted;
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
  final bool isDiscount;
  const PriceView(
      {Key key,
      @required this.price,
      @required this.color,
      this.isDiscount = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isDiscount && price == 0
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
                '${price.toStringAsFixed(0)}${isDiscount ? '%' : ''}',
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 20),
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
