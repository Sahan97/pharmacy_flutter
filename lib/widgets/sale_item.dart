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
  double price = 0;
  double quantity = 0;
  var focusNode = new FocusNode();
  var itemPriceFocusNode = new FocusNode();
  final qtyController = TextEditingController();
  final priceController = TextEditingController();

  @override
  void initState() {
    if (widget.item.isItem) {
      focusNode.requestFocus();
      quantity = widget.item.sellQuantity;
      qtyController.text = quantity != 0 ? quantity.toStringAsFixed(0) : '';
    } else {
      priceController.text = widget.item.sellPrice == null
          ? '0'
          : widget.item.sellPrice.toStringAsFixed(0);
      price = widget.item.sellPrice == null ? 0 : widget.item.sellPrice;
      quantity = widget.item.sellQuantity;
      qtyController.text = quantity.toStringAsFixed(0);
      itemPriceFocusNode.requestFocus();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    calPrice();

    return Card(
      child: Row(
        children: [
          _remove(),
          CodeView(
            code: widget.item.code,
          ),
          NameView(
            name:
                '${widget.item.name} ${widget.item.priceCategory.isEmpty ? '' : ' - (${widget.item.priceCategory})'}',
          ),
          _qty(),
          widget.item.isItem
              ? PriceView(
                  price: widget.item.sellPrice,
                  color: Colors.blue,
                )
              : chargeItemPrice(),
          SizedBox(
            width: 14,
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
    double newPrice = (widget.item.sellPrice * quantity);
    setState(() {
      price = newPrice;
    });
    ScopedModel.of<MainModel>(context).setTotalPrice(newPrice, widget.index);
  }

  Widget chargeItemPrice() {
    return Container(
      width: 80,
      height: 50,
      margin: EdgeInsets.only(right: 10, top: 5, bottom: 5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 3),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white),
      child: TextFormField(
        focusNode: itemPriceFocusNode,
        controller: priceController,
        // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
        onChanged: (String value) async {
          ScopedModel.of<MainModel>(context).setSellPrice(
              widget.index, value.isEmpty ? 0 : double.parse(value));
          // widget.item.sellPrice = value.isEmpty ? 0 : double.parse(value);
          calPrice();
        },
        onFieldSubmitted: (value) {
          ScopedModel.of<MainModel>(context).barCodeFocusNode.requestFocus();
        },
        cursorColor: Colors.black,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.blue,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _remove() {
    return IconButton(
      padding: EdgeInsets.all(5),
      onPressed: () {
        ScopedModel.of<MainModel>(context).removeItem(widget.item.id);
        ScopedModel.of<MainModel>(context).barCodeFocusNode.requestFocus();
      },
      icon: Icon(
        Icons.remove_circle_outline,
        color: Colors.red,
        size: 30,
      ),
    );
  }

  Widget _qty() {
    return Container(
      width: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 3, color: Colors.grey)),
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(horizontal: 34),
      child: TextFormField(
        controller: qtyController,
        focusNode: focusNode,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
            ScopedModel.of<MainModel>(context).setQuantity(widget.index, 0);
          } else {
            if (widget.item.isItem &&
                widget.item.currentQty < double.parse(value)) {
              try {
                await Messages.simpleMessage(
                    head: 'Failed!',
                    body:
                        'This quantity is not available. Only ${widget.item.currentQty} items are available!');
              } catch (e) {}

              qtyController.text = "0";
              quantity = 0;
              ScopedModel.of<MainModel>(context)
                  .setQuantity(widget.index, quantity);
            } else {
              quantity = double.parse(value);
              ScopedModel.of<MainModel>(context)
                  .setQuantity(widget.index, quantity);
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
