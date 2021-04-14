import 'package:communication/model/sale.dart';
import 'package:communication/scoped_model/main.dart';
import 'package:communication/views/admin_sales_page/Admin_sales_page.dart';
import 'package:communication/widgets/blackout.dart';
import 'package:communication/widgets/loading_btn.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class AdminSaleView extends StatelessWidget {
  const AdminSaleView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Sale item = ScopedModel.of<MainModel>(context).saleItemToView;
    return Blackout(
      child: Center(
        child: SingleChildScrollView(
          child: Card(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  _itemDetail('Sale Id', item.id),
                  _itemDetail('Date', item.date),
                  _itemDetail('Time', item.time),
                  _itemDetail('Customer', item.customer),
                  _itemDetail('Total Amount', item.totalPrice),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    elevation: 5,
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.grey,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _tableHead(
                                  'Item / charge',
                                  400,
                                ),
                                _tableHead('Qty', 50, al: TextAlign.center),
                                _tableHead('Item Price', 100,
                                    al: TextAlign.center),
                                _tableHead('Price', 120, al: TextAlign.center),
                              ],
                            ),
                          ),
                          Column(
                            children: item.pharmacyItems
                                .map(
                                  (e) => Container(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 0.5)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _tableHead(e.item.name, 400,
                                            color: Colors.black),
                                        _tableHead(e.quantity.toString(), 50,
                                            color: Colors.black,
                                            al: TextAlign.center),
                                        _tableHead(
                                            e.item.sellPrice.toString(), 100,
                                            color: Colors.black,
                                            al: TextAlign.center),
                                        _tableHead(
                                            (e.item.sellPrice * e.quantity)
                                                .toString(),
                                            120,
                                            color: Colors.black,
                                            al: TextAlign.center),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          Column(
                            children: item.otherCharges
                                .map(
                                  (e) => Container(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 0.5)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _tableHead(e.name, 400,
                                            color: Colors.black),
                                        _tableHead(e.qty.toString(), 50,
                                            color: Colors.black,
                                            al: TextAlign.center),
                                        _tableHead(e.itemPrice.toString(), 100,
                                            color: Colors.black,
                                            al: TextAlign.center),
                                        _tableHead(
                                            (e.itemPrice * e.qty).toString(),
                                            120,
                                            color: Colors.black,
                                            al: TextAlign.center),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          )
                        ],
                      ),
                    ),
                  ),
                  ButtonBar(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LoadingBtn(
                        onPressed: () {
                          ScopedModel.of<MainModel>(context)
                              .setItemToView(null);
                          ScopedModel.of<MainModel>(context)
                              .setAdminSalePagePopup(
                                  AdminSalesPagePopup.NoPopup);
                        },
                        text: 'Close',
                        color: Colors.red,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemDetail(String key, dynamic value) {
    return Container(
      width: 450,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 130,
            child: Text(
              key,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            width: 20,
            child: Text(
              ' :   ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            child: Text(
              value.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget _tableHead(String name, double width,
      {Color color = Colors.white, TextAlign al = TextAlign.left}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: width,
      child: Text(
        name,
        style: TextStyle(color: color, fontSize: 18),
        textAlign: al,
      ),
    );
  }
}
