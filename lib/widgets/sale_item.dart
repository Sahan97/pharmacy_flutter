import 'package:communication/model/item.dart';
import 'package:communication/scoped_model/main.dart';
import 'package:communication/widgets/Messages.dart';
import 'package:communication/widgets/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

class SaleItem extends StatefulWidget {
  final Item item;
  final int index;
  SaleItem({Key key, @required this.item, @required this.index})
      : super(key: key);

  @override
  _SaleItemState createState() => _SaleItemState();
}

class _SaleItemState extends State<SaleItem> {
  bool isDiscountAdd = false;
  double price = 0;
  double quantity = 1;
  var focusNode = new FocusNode();
  final qtyController = TextEditingController();

  @override
  void initState() {
    focusNode.requestFocus();
    qtyController.text =
        widget.item.availableQuantity > 0 ? quantity.toStringAsFixed(0) : '0';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    calPrice();
    return Card(
      child: Row(
        children: [
          _remove(),
          NameView(
            name: widget.item.name,
          ),
          _qty(),
          PriceView(
            price: widget.item.sellPricePerItem,
            color: Colors.blue,
          ),
          widget.item.discount != 0
              ? _addDiscount()
              : Container(
                  width: 125,
                ),
          PriceView(
            price: price,
            color: Colors.green,
          )
        ],
      ),
    );
  }

  calPrice() {
    double newPrice = isDiscountAdd
        ? ((widget.item.sellPricePerItem * (100 - widget.item.discount) / 100) *
            quantity)
        : (widget.item.sellPricePerItem * quantity);
    setState(() {
      price = newPrice;
    });
    ScopedModel.of<MainModel>(context).setTotalPrice(newPrice, widget.index);
  }

  Widget _remove() {
    return IconButton(
      padding: EdgeInsets.all(5),
      onPressed: () {
        ScopedModel.of<MainModel>(context).removeItem(widget.index);
        ScopedModel.of<MainModel>(context).barCodeFocusNode.requestFocus();
      },
      icon: Icon(
        Icons.remove_circle_outline,
        color: Colors.red,
        size: 30,
      ),
    );
  }

  Widget _addDiscount() {
    return Container(
      margin: EdgeInsets.only(left: 35, right: 40),
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange, width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          _discount(!isDiscountAdd);
        },
        child: Center(
          child: isDiscountAdd
              ? Icon(
                  Icons.check,
                  color: Colors.orange,
                  size: 40,
                )
              : Container(),
        ),
      ),
    );
  }

  _discount(bool isAdd) {
    setState(() {
      isDiscountAdd = isAdd;
    });
    widget.item.isDiscountAdd = isDiscountAdd;
  }

  Widget _qty() {
    return Container(
      width: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 3, color: Colors.grey)),
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextFormField(
        controller: qtyController,
        focusNode: focusNode,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
        onChanged: (String value) async {
          if (value.isEmpty) {
            quantity = 0;
            widget.item.sellQuantity = 0;
          } else {
            if (widget.item.availableQuantity < double.parse(value)) {
              await Messages.simpleMessage(
                  head: 'Failed!',
                  body:
                      'This quantity is not available. Only ${widget.item.availableQuantity} items are available!');
              qtyController.text = "0";
              quantity = 0;
              widget.item.sellQuantity = quantity;
            } else {
              quantity = double.parse(value);
              widget.item.sellQuantity = quantity;
            }
          }
          calPrice();
        },
        onFieldSubmitted: (value) {
          ScopedModel.of<MainModel>(context).barCodeFocusNode.requestFocus();
        },
        cursorColor: Colors.black,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
