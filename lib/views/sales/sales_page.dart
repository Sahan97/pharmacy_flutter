import 'package:communication/helpers/api_service.dart';
import 'package:communication/helpers/shop_details.dart';
import 'package:communication/model/bar_code.dart';
import 'package:communication/model/item.dart';
import 'package:communication/scoped_model/main.dart';
import 'package:communication/views/home_page/home_page.dart';
import 'package:communication/views/manage_pharmacy_items/all_items.dart';
import 'package:communication/widgets/Messages.dart';
import 'package:communication/widgets/loading_btn.dart';
import 'package:communication/widgets/sale_item.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:scoped_model/scoped_model.dart';

class SalesPage extends StatefulWidget {
  SalesPage({Key key}) : super(key: key);

  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  @override
  void initState() {
    ScopedModel.of<MainModel>(context).focusBarcodeField();
    super.initState();
  }

  final barCodeContriller = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: ScopedModel.of<MainModel>(context).salesFocusNode,
      onKey: _onKeyPressHandler,
      child: ScopedModelDescendant(
        builder: (context, child, MainModel model) => Container(
          padding: EdgeInsets.all(10),
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Text(
                shopName,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Sunday Best',
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 5,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  color: Colors.black.withOpacity(0.5),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 20),
                        child: Column(
                          children: [
                            LoadingBtn(
                              onPressed: _itemFinderClick,
                              text: 'Pharmacy Items (F1)',
                              color: Colors.green,
                            ),
                            LoadingBtn(
                              onPressed: _itemFinderClick,
                              text: 'Stationary Items (F2)',
                              color: Colors.green,
                            ),
                            LoadingBtn(
                              onPressed: _itemFinderClick,
                              text: 'Other Charges (F3)',
                              color: Colors.green,
                            ),

                            Spacer(),
                            // LoadingBtn(
                            //   onPressed: _reFillNoteClick,
                            //   text: 'Re-Fill Note (F3)',
                            //   color: Colors.blue,
                            // ),
                            LoadingBtn(
                              onPressed: _finishOrderClick,
                              text: 'Finish Order (F4)',
                              color: Colors.orange,
                            ),
                            LoadingBtn(
                              onPressed: _clearClick,
                              text: 'Clear (F5)',
                              color: Colors.red,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2)),
                          child: Column(
                            children: [
                              _labels(),
                              Expanded(
                                child: Stack(
                                  children: [
                                    ListView.builder(
                                      itemBuilder: (context, index) => SaleItem(
                                        item: model.billedItems[index],
                                        index: index,
                                      ),
                                      itemCount: model.billedItems.length,
                                    ),
                                    isLoading
                                        ? Center(
                                            child: SizedBox(
                                                height: 50,
                                                child: LoadingIndicator(
                                                    indicatorType:
                                                        Indicator.lineScale)),
                                          )
                                        : Container()
                                  ],
                                ),
                              ),
                              _totalPrice()
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _labels() {
    return Container(
      color: Colors.white,
      height: 40,
      child: Row(
        children: [
          SizedBox(
            width: 35,
          ),
          LabelText('Code', Colors.black),
          Expanded(
            child: Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LabelText(
                    'Name',
                    Colors.black,
                    al: Alignment.centerLeft,
                  ),
                  _barcodeField()
                ],
              ),
            ),
          ),
          _devider(),
          LabelText('Qty', Colors.black),
          _devider(),
          LabelText('Item Price', Colors.black),
          _devider(),
          LabelText('Price', Colors.black),
        ],
      ),
    );
  }

  Widget _devider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey,
      margin: EdgeInsets.symmetric(horizontal: 10),
    );
  }

  Widget _barcodeField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      margin: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.purple,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(5)),
      width: 200,
      child: TextFormField(
        controller: barCodeContriller,
        focusNode: ScopedModel.of<MainModel>(context).barCodeFocusNode,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
        onFieldSubmitted: _onBarCodeEnter,
        cursorColor: Colors.black,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _totalPrice() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Price',
            style: TextStyle(
                color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white70),
            child: Text(
              getPrice(),
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black)]),
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

  _onBarCodeEnter(String value) {
    if (value.isNotEmpty) {
      barCodeContriller.text = '';
      setState(() {
        isLoading = true;
      });
      ApiService.shared.getItemByBarcodeCall(value).then((value) {
        setState(() {
          isLoading = false;
        });
        if (value.success) {
          List<Barcode> barcodes =
              List<Barcode>.from(value.data.map((x) => Barcode.fromJson(x)));
          if (barcodes.length == 1) {
            ScopedModel.of<MainModel>(context).addToBill(barcodes[0].item);
          } else {
            ScopedModel.of<MainModel>(context).setGetItemsFromBarCode(true);
            List<Item> itms = [];
            barcodes.forEach((element) => itms.add(element.item));
            ScopedModel.of<MainModel>(context).setItems(itms);
            ScopedModel.of<MainModel>(context)
                .setHomePagePopup(HomePagePopups.ItemFinder);
            ScopedModel.of<MainModel>(context)
                .itemFindeeFocusNode
                .requestFocus();
          }
        }
      });
    } else {
      ScopedModel.of<MainModel>(context).barCodeFocusNode.requestFocus();
    }
  }

  _onKeyPressHandler(RawKeyEvent key) {
    if (key.runtimeType.toString() == 'RawKeyDownEvent') {
      print(key.logicalKey.keyId);
      switch (key.logicalKey.keyId) {
        case 4295426106: //F1
          _itemFinderClick();
          break;
        case 4295426107: //F2

          break;
        case 4295426108: //F3

          break;
        case 4295426109: //F4
          _finishOrderClick();
          break;
        case 4295426110: //F5
          _clearClick();
          break;
        case 4295426089:
          _closePopup();
          break;
      }
      // print(key.logicalKey.keyId);
    }
  }

  _itemFinderClick() {
    ScopedModel.of<MainModel>(context).setGetItemsFromBarCode(false);
    _showPopup(HomePagePopups.ItemFinder);
    ScopedModel.of<MainModel>(context).itemFindeeFocusNode.requestFocus();
  }

  _finishOrderClick() {
    if (ScopedModel.of<MainModel>(context).billedItems.length == 0) {
      return;
    }

    Messages.confirmMessage(
        head: 'Are you sure?',
        body: "This action will finish the order",
        onConfirm: () {
          _showPopup(HomePagePopups.FinishOrder);
        },
        onCancell: () {});
  }

  _showPopup(HomePagePopups pop) {
    ScopedModel.of<MainModel>(context).setHomePagePopup(pop);
  }

  _reFillNoteClick() {}

  _clearClick() {
    Messages.confirmMessage(
        head: 'Are you sure?',
        body: "This action will clear the current bill.",
        onConfirm: () {
          ScopedModel.of<MainModel>(context).clearBill();
        },
        onCancell: () {});
  }

  _closePopup() {
    ScopedModel.of<MainModel>(context).setHomePagePopup(HomePagePopups.NoPopup);
  }
}
