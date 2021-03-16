import 'package:communication/helpers/api_service.dart';
import 'package:communication/model/item.dart';
import 'package:communication/scoped_model/main.dart';
import 'package:communication/views/home_page/home_page.dart';
import 'package:communication/widgets/blackout.dart';
import 'package:communication/widgets/item.dart';
import 'package:communication/widgets/loading_btn.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:communication/views/manage_pharmacy_items/all_items.dart';

class ItemFinder extends StatefulWidget {
  ItemFinder({Key key}) : super(key: key);
  @override
  _ItemFinderState createState() => _ItemFinderState();
}

class _ItemFinderState extends State<ItemFinder> {
  List<Item> filteredItems = [];
  String filterNumb = '';
  String filterStr = '';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    ScopedModel.of<MainModel>(context).getItemsFromBarCode
        ? _getItemsFromBarCode()
        : _loadAllItems();
    super.initState();
  }

  _loadAllItems() async {
    setState(() {
      filteredItems = null;
    });
    List<Item> items =
        await ApiService.shared.getItemsCall({'isDeleted': false});
    ScopedModel.of<MainModel>(context).setItems(items);
    filteredItems = ScopedModel.of<MainModel>(context).items;
    ScopedModel.of<MainModel>(context).focusItemFinder();
  }

  _getItemsFromBarCode() {
    filteredItems = ScopedModel.of<MainModel>(context).items;
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
                  _labels(),
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
                                child: Text('No Items'),
                              )
                            : ListView.builder(
                                itemBuilder: (context, index) => ItemView(
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

  _onItemSelected(Item item) {
    ScopedModel.of<MainModel>(context).addToBill(item);
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
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
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
            RaisedButton(
              color: Colors.blue,
              onPressed: () {
                _formKey.currentState.reset();
                setState(() {
                  filteredItems = ScopedModel.of<MainModel>(context).items;
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
            RaisedButton(
              color: Colors.blue,
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

  Widget _labels() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey, width: 1)),
      margin: EdgeInsets.only(top: 10),
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: LabelText('Name', Colors.black, al: Alignment.centerLeft),
          ),
          LabelText('Available', Colors.grey),
          LabelText('Sell', Colors.green),
          LabelText('Discount', Colors.orange),
          SizedBox(
            width: 24,
          )
        ],
      ),
    );
  }

  // reloadItems() async {
  //   List<Item> itemsNew =
  //       await ApiService.shared.getItemsCall({'isDeleted': false});
  //   ScopedModel.of<MainModel>(context).setItems(itemsNew);
  //   setState(() {
  //     filteredItems = itemsNew;
  //   });
  // }

  filterItems() {
    List<Item> filteredByName = [];
    if (filterStr.isEmpty) {
      filteredByName = ScopedModel.of<MainModel>(context).items;
    } else {
      ScopedModel.of<MainModel>(context).items.forEach((element) {
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
