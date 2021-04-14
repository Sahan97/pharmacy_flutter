import 'package:communication/model/sale.dart';
import 'package:communication/scoped_model/main.dart';
import 'package:communication/views/admin_sales_page/Admin_sales_page.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SaleListItem extends StatefulWidget {
  final Sale item;
  final int index;
  const SaleListItem({Key key, @required this.item, @required this.index})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ItemViewState();
  }
}

class _ItemViewState extends State<SaleListItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () {
          ScopedModel.of<MainModel>(context).setItemToView(widget.item);
          ScopedModel.of<MainModel>(context)
              .setAdminSalePagePopup(AdminSalesPagePopup.ItemView);
        },
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            PriceView(
              price: double.parse(widget.item.id.toString()),
              color: Colors.orange,
            ),
            SizedBox(
              width: 20,
            ),
            Container(
              width: 140,
              child: Text(
                widget.item.date,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                ),
              ),
            ),
            Container(
                width: 140,
                child: Text(
                  widget.item.time,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 17,
                  ),
                )),
            NameView(name: widget.item.customer, al: TextAlign.left),
            PriceView(
                price: double.parse(widget.item.totalPrice.toString()),
                color: Colors.green),
            SizedBox(
              width: 40,
            )
          ],
        ),
      ),
    );
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
  final double fontSize;
  final Color color;
  final TextAlign al;
  const NameView(
      {Key key,
      @required this.name,
      this.fontSize = 20,
      this.color = Colors.black,
      this.al = TextAlign.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Text(
          name,
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: fontSize, color: color),
        ),
      ),
    );
  }
}
