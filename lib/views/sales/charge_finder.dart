import 'dart:math';

import 'package:communication/helpers/api_service.dart';
import 'package:communication/model/item.dart';
import 'package:communication/model/other_charge.dart';
import 'package:communication/scoped_model/main.dart';
import 'package:communication/views/home_page/home_page.dart';
import 'package:communication/widgets/Messages.dart';
import 'package:communication/widgets/blackout.dart';
import 'package:communication/widgets/loading_btn.dart';
import 'package:communication/widgets/other_charge.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:scoped_model/scoped_model.dart';

class ChargeFinder extends StatefulWidget {
  ChargeFinder({Key key}) : super(key: key);
  @override
  _ChargeFinderState createState() => _ChargeFinderState();
}

class _ChargeFinderState extends State<ChargeFinder> {
  List<OtherCharge> filteredItems = [];
  String filterStr = '';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _loadAllItems();
    super.initState();
  }

  _loadAllItems() async {
    setState(() {
      filteredItems = null;
    });
    List<OtherCharge> items = await ApiService.shared.getOtherCharges();
    ScopedModel.of<MainModel>(context).setOtherCharges(items);
    filteredItems = ScopedModel.of<MainModel>(context).otherCharges;
    ScopedModel.of<MainModel>(context).focusItemFinder();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (context, child, MainModel model) => Blackout(
        child: Center(
          child: Card(
            margin: EdgeInsets.all(30),
            color: Colors.white,
            child: Container(
              width: 900,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  _filter(),
                  Expanded(
                    child: filteredItems == null
                        ? Center(
                            child: SizedBox(
                              width: 100,
                              child: LoadingIndicator(
                                  indicatorType: Indicator.lineScale),
                            ),
                          )
                        : filteredItems.length == 0
                            ? Center(
                                child: Text('No Charges'),
                              )
                            : ListView.builder(
                                itemBuilder: (context, index) =>
                                    OtherChargeView(
                                  onPressed: _onItemSelected,
                                  isCashier: true,
                                  item: filteredItems[index],
                                  index: index,
                                ),
                                itemCount: filteredItems.length,
                              ),
                  ),
                  LoadingBtn(
                    onPressed: _onClose,
                    text: 'Close',
                    color: Colors.red,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onClose() {
    ScopedModel.of<MainModel>(context).setHomePagePopup(HomePagePopups.NoPopup);
    ScopedModel.of<MainModel>(context).focusSalesPage();
    ScopedModel.of<MainModel>(context).focusBarcodeField();
  }

  _onItemSelected(OtherCharge item) {
    if (ScopedModel.of<MainModel>(context)
            .billedItems
            .indexWhere((element) => element.name == item.name) ==
        -1) {
      ScopedModel.of<MainModel>(context).addToBill(Item(
          isItem: false,
          id: Random().nextInt(10000),
          name: item.name,
          priceCategory: '',
          sellPrice: 0));
    } else {
      Messages.simpleMessage(
          head: "Charge already added!",
          body: 'Same charge cannot add more than one time.');
    }
    _onClose();
  }

  Widget _filter() {
    return Container(
      color: Colors.white,
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Container(
              child: Text(
                'Filter by Name  :  ',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                margin: EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.purple,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(5)),
                width: 60,
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  onChanged: (String value) {
                    filterStr = value;
                    filterItems();
                  },
                  onFieldSubmitted: (value) {
                    _onClose();
                  },
                  cursorColor: Colors.black,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  focusNode:
                      ScopedModel.of<MainModel>(context).itemFindeeFocusNode,
                ),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              onPressed: () {
                _formKey.currentState.reset();
                setState(() {
                  filteredItems =
                      ScopedModel.of<MainModel>(context).otherCharges;
                });
              },
              child: Text(
                'Reset',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              onPressed: () {
                _formKey.currentState.reset();
                _loadAllItems();
              },
              child: Text(
                'Reload',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }

  filterItems() {
    List<OtherCharge> filteredByName = [];
    if (filterStr.isEmpty) {
      filteredByName = ScopedModel.of<MainModel>(context).otherCharges;
    } else {
      ScopedModel.of<MainModel>(context).otherCharges.forEach((element) {
        if (element.name.toLowerCase().contains(filterStr.toLowerCase())) {
          filteredByName.add(element);
        }
      });
    }
    setState(() {
      filteredItems = filteredByName;
    });
  }
}
