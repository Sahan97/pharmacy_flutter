import 'package:communication/model/item.dart';
import 'package:flutter/material.dart';

class ReOrderItemView extends StatefulWidget {
  final Item item;
  const ReOrderItemView({
    Key key,
    @required this.item,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ReOrderItemViewState();
  }
}

class _ReOrderItemViewState extends State<ReOrderItemView> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: !widget.item.isActive ? Colors.red.withOpacity(0.3) : Colors.white,
      margin: EdgeInsets.only(top: 10),
      child: Stack(
        children: [
          Row(
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
              PriceView(price: widget.item.reOrderQty, color: Colors.blue),
              SizedBox(
                width: 20,
              )
            ],
          ),
        ],
      ),
    );
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
            width: 120,
            height: 50,
          )
        : Container(
            width: 110,
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
