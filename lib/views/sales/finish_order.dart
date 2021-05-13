import 'dart:convert';

import 'package:communication/helpers/api_service.dart';
import 'package:communication/scoped_model/main.dart';
import 'package:communication/views/home_page/home_page.dart';
import 'package:communication/widgets/Messages.dart';
import 'package:communication/widgets/blackout.dart';
import 'package:communication/widgets/loading_btn.dart';
import 'package:cross_local_storage/cross_local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

class FinishOrder extends StatefulWidget {
  FinishOrder({Key key}) : super(key: key);

  @override
  _FinishOrderState createState() => _FinishOrderState();
}

class _FinishOrderState extends State<FinishOrder> {
  final receiverFocusNode = FocusNode();
  final nameFocusNode = FocusNode();
  int finalPrice;
  int received = 0;
  String name = '';
  bool finishLoading = false;
  bool isFreeOfCharge = false;

  @override
  void initState() {
    finalPrice = int.parse(getPrice());
    nameFocusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Blackout(
      child: Center(
        child: Card(
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _enterName(),
                _priceItem(
                    text: 'Total Price',
                    price: finalPrice,
                    color: Colors.green),
                isFreeOfCharge
                    ? Container(
                        width: 10,
                        height: 50,
                      )
                    : _receivedPrice(),
                _priceItem(
                    text: 'Balance',
                    price: isFreeOfCharge ? 0 : received - finalPrice,
                    color: (received - finalPrice) < 0
                        ? Colors.red
                        : Colors.orange),
                SizedBox(
                  height: 40,
                ),
                _freeOfCharge(),
                ButtonBar(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LoadingBtn(
                      onPressed: () {
                        _showPopup(HomePagePopups.NoPopup);
                      },
                      text: 'Cancel',
                      color: Colors.red,
                    ),
                    LoadingBtn(
                      onPressed: _finishOrder,
                      text: 'Finish',
                      color: Colors.green,
                      isBusy: finishLoading,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showPopup(HomePagePopups pop) {
    ScopedModel.of<MainModel>(context).setHomePagePopup(pop);
  }

  Widget _priceItem(
      {@required int price, @required String text, @required Color color}) {
    return Container(
      width: 500,
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 25, color: color, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            child: Text(
              price.toStringAsFixed(0),
              style: TextStyle(
                  fontSize: 25, color: color, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget _freeOfCharge() {
    return Container(
      width: 500,
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: Text(
                "Free Of Charge",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
              child: Switch(
            value: isFreeOfCharge,
            onChanged: (value) {
              setState(() {
                isFreeOfCharge = value;
              });
            },
          ))
        ],
      ),
    );
  }

  Widget _receivedPrice() {
    return Container(
      width: 500,
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: Text(
                "Received",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            width: 100,
            child: TextField(
              textAlign: TextAlign.right,
              focusNode: receiverFocusNode,
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
              onChanged: (value) {
                setState(() {
                  received = int.parse(value);
                });
              },
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              onSubmitted: (value) {
                _finishOrder();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _enterName() {
    return Container(
      width: 500,
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: Text(
                "Customer",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            width: 100,
            child: TextField(
              focusNode: nameFocusNode,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              onSubmitted: (value) {
                receiverFocusNode.requestFocus();
              },
            ),
          )
        ],
      ),
    );
  }

  String getPrice() {
    double price = 0;
    ScopedModel.of<MainModel>(context).billedItems.forEach((element) {
      price = price + element.totalPrice;
    });
    return price.toStringAsFixed(0);
  }

  _finishOrder() {
    if (!isFreeOfCharge && received < finalPrice) {
      Messages.simpleMessage(
          head: 'Failed!',
          body: 'Received price from customer is less than the total price!');
      return;
    }
    setState(() {
      finishLoading = true;
    });
    var pharmacyItems = [];
    var otherCharges = [];
    var otherChargesPrint = [];

    double drugsCharge = 0;

    ScopedModel.of<MainModel>(context).billedItems.forEach((element) {
      if (element.isItem) {
        pharmacyItems.add({
          "itemId": element.id,
          "qty": element.sellQuantity,
          "itemPrice": element.sellPrice,
        });
        drugsCharge = drugsCharge + (element.sellQuantity * element.sellPrice);
      } else {
        otherCharges.add({
          "name": element.name,
          "qty": element.sellQuantity,
          "itemPrice": element.sellPrice
        });

        otherChargesPrint.add({
          "name": element.name,
          "qty": element.sellQuantity,
          "pricePerItem": element.sellPrice
        });
      }
    });

    saleCall() {
      ApiService.shared.createSaleCall({
        "customer": name.isEmpty ? 'unknown customer' : name,
        "pharmacyItems": pharmacyItems,
        "stationaryItems": [],
        "otherCharges": otherCharges,
        "isFreeOfCharge": isFreeOfCharge
      }).then((value) async {
        setState(() {
          finishLoading = false;
        });
        if (value.success) {
          LocalStorageInterface prefs = await LocalStorage.getInstance();
          List<dynamic> sales = jsonDecode(prefs.getString('sales') ?? "[]");
          if (sales.length == 0) {
            _showPopup(HomePagePopups.NoPopup);
            ScopedModel.of<MainModel>(context).clearBill();
            ScopedModel.of<MainModel>(context).barCodeFocusNode.requestFocus();
          } else {
            ApiService.shared
                .createMissedSaleCall({"sales": sales}).then((value) {
              if (value.success) {
                prefs.setString('sales', jsonEncode([]));
                _showPopup(HomePagePopups.NoPopup);
                ScopedModel.of<MainModel>(context).clearBill();
                ScopedModel.of<MainModel>(context)
                    .barCodeFocusNode
                    .requestFocus();
              } else {
                _showPopup(HomePagePopups.NoPopup);
                ScopedModel.of<MainModel>(context).clearBill();
                ScopedModel.of<MainModel>(context)
                    .barCodeFocusNode
                    .requestFocus();
              }
            });
          }
        } else {
          LocalStorageInterface prefs = await LocalStorage.getInstance();
          List<dynamic> sales = jsonDecode(prefs.getString('sales') ?? "[]");
          sales.add({
            "customer": name.isEmpty ? 'unknown customer' : name,
            "pharmacyItems": pharmacyItems,
            "stationaryItems": [],
            "otherCharges": otherCharges,
            "isFreeOfCharge": isFreeOfCharge
          });
          prefs.setString('sales', jsonEncode(sales));
          _showPopup(HomePagePopups.NoPopup);
          ScopedModel.of<MainModel>(context).clearBill();
          ScopedModel.of<MainModel>(context).barCodeFocusNode.requestFocus();
          // Messages.simpleMessage(
          //     head: 'Failed!',
          //     body:
          //         'There is a probem with the system! Please try again later or contact system admin!');
        }
      });
    }

    ApiService.shared
        .printBill(
            name.isEmpty ? 'unknown customer' : name,
            drugsCharge.toInt(),
            otherChargesPrint,
            received.toString(),
            isFreeOfCharge)
        .then((value) {
      if (value['success']) {
        saleCall();
      } else {
        Messages.confirmMessage(
            head: "Unable to print receipt!",
            body: 'Do you want to proceed bill without printed receipt?',
            onConfirm: () {
              saleCall();
            },
            onCancell: () {
              _showPopup(HomePagePopups.NoPopup);
            });
      }
    });
  }
}
