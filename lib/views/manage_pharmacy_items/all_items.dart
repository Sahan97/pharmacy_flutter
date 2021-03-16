import 'package:communication/helpers/api_service.dart';
import 'package:communication/model/item.dart';
import 'package:communication/scoped_model/main.dart';
import 'package:communication/widgets/item.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:scoped_model/scoped_model.dart';

class AllItems extends StatefulWidget {
  AllItems({Key key}) : super(key: key);
  @override
  _AllItemsState createState() => _AllItemsState();
}

class _AllItemsState extends State<AllItems> {
  List<Item> allItems = [];
  String filterNumb = '';
  String filterStr = '';
  bool _isBusy = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _getAllItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
        ),
        child: ScopedModelDescendant(
          builder: (context, child, MainModel model) => Column(
            children: [
              _filter(),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: _isBusy
                      ? Center(
                          child: SizedBox(
                              height: 50,
                              child: LoadingIndicator(
                                  indicatorType: Indicator.lineScale)),
                        )
                      : model.items.length == 0
                          ? Center(
                              child: Text(
                                'No Items',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            )
                          : Column(
                              children: [
                                _labels(),
                                Expanded(
                                  child: ListView.builder(
                                    itemBuilder: (context, index) => ItemView(
                                      item: model.items[index],
                                      index: index,
                                    ),
                                    itemCount: model.items.length,
                                  ),
                                ),
                              ],
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                margin: EdgeInsets.only(right: 20, top: 2, bottom: 2),
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
                  autofocus: true,
                  cursorColor: Colors.black,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            RaisedButton(
              color: Colors.blue,
              onPressed: () {
                _formKey.currentState.reset();
                ScopedModel.of<MainModel>(context).setItems(allItems);
              },
              child: Text(
                'Reset',
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
    List<Item> filteredByName = [];
    if (filterStr.isEmpty) {
      filteredByName = allItems;
    } else {
      allItems.forEach((element) {
        if (element.name.toLowerCase().contains(filterStr.toLowerCase())) {
          filteredByName.add(element);
        }
      });
    }
    ScopedModel.of<MainModel>(context).setItems(filteredByName);
  }

  Widget _labels() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 1)),
      margin: EdgeInsets.only(top: 10),
      color: Colors.white,
      child: Row(
        children: [
          LabelText('Code', Colors.black),
          Expanded(
            child: LabelText('Name', Colors.black, al: Alignment.centerLeft),
          ),
          LabelText('QTY', Colors.grey),
          LabelText('Buy', Colors.blue),
          LabelText('Sell', Colors.green),
          SizedBox(
            width: 24,
          )
        ],
      ),
    );
  }

  _getAllItems() {
    setState(() {
      _isBusy = true;
    });
    ApiService.shared.getItemsCall().then((value) {
      setState(() {
        _isBusy = false;
        allItems = value;
        ScopedModel.of<MainModel>(context).setItems(value);
      });
    });
  }
}

class LabelText extends StatelessWidget {
  final String title;
  final Color color;
  final Alignment al;
  final double width;
  const LabelText(
    this.title,
    this.color, {
    Key key,
    this.al = Alignment.center,
    this.width = 92.5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      width: width,
      child: Align(
        alignment: al,
        child: Text(
          title,
          style: TextStyle(
              color: color, fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
