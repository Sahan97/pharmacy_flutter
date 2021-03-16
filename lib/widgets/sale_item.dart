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
  final qtyController = TextEditingController();

  @override
  void initState() {
    focusNode.requestFocus();
    qtyController.text = '';
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
          PriceView(
            price: widget.item.sellPrice,
            color: Colors.blue,
          ),
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
            if (widget.item.currentQty < double.parse(value)) {
              await Messages.simpleMessage(
                  head: 'Failed!',
                  body:
                      'This quantity is not available. Only ${widget.item.currentQty} items are available!');
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
