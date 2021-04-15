import 'package:communication/helpers/api_service.dart';
import 'package:communication/model/item.dart';
import 'package:communication/scoped_model/main.dart';
import 'package:communication/widgets/re_order_item_view.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:scoped_model/scoped_model.dart';

class ReOrderList extends StatefulWidget {
  ReOrderList({Key key}) : super(key: key);
  @override
  _ReOrderListState createState() => _ReOrderListState();
}

class _ReOrderListState extends State<ReOrderList> {
  List<Item> allItems = [];
  bool _isBusy = false;
  @override
  void initState() {
    _getReOrderItems();
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
                      : allItems.length == 0
                          ? Center(
                              child: Text(
                                'No Items to Re Order',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            )
                          : Column(
                              children: [
                                _labels(),
                                Expanded(
                                  child: ListView.builder(
                                    itemBuilder: (context, index) =>
                                        ReOrderItemView(
                                      item: allItems[index],
                                    ),
                                    itemCount: allItems.length,
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
          LabelText(
            'Current QTY',
            Colors.grey,
            width: 120,
          ),
          LabelText(
            'Re Order QTY',
            Colors.blue,
            width: 120,
          ),
          SizedBox(
            width: 24,
          )
        ],
      ),
    );
  }

  _getReOrderItems() {
    setState(() {
      _isBusy = true;
    });
    ApiService.shared.getReOrderListCall().then((value) {
      setState(() {
        _isBusy = false;
        allItems = value;
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
