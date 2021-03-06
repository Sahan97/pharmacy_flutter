import 'package:communication/helpers/api_service.dart';
import 'package:communication/model/sale.dart';
import 'package:communication/views/manage_pharmacy_items/all_items.dart';
import 'package:communication/widgets/sale_list_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../../widgets/sale_list_item.dart' as price;

class AllSales extends StatefulWidget {
  AllSales({Key key}) : super(key: key);

  @override
  _AllSalesState createState() => _AllSalesState();
}

class _AllSalesState extends State<AllSales> {
  List<Sale> sales = [];
  bool _isBusy = false;
  double total = 0;
  double freeOfCharge = 0;
  double totalCost = 0;
  int saleId;
  final dateController = TextEditingController();
  final idController = TextEditingController();
  @override
  void initState() {
    getSales(null, null);
    super.initState();
  }

  getSales(DateTime date, int saleId) {
    setState(() {
      _isBusy = true;
      total = 0;
    });
    ApiService.shared.getSales(date, saleId).then((value) {
      if (this.mounted) {
        setState(() {
          _isBusy = false;
        });
        if (value.success) {
          setState(() {
            sales = List<Sale>.from(value.data.map((x) => Sale.fromJson(x)));
          });
          double tot = 0;
          double cost = 0;
          double foc = 0;
          sales.forEach((element) {
            if (element.isFreeOfCharge) {
              foc += element.totalPrice;
            } else {
              tot += element.totalPrice;
            }
            element.pharmacyItems.forEach((p) {
              cost += (p.quantity * p.item.buyPrice);
            });
          });
          setState(() {
            total = tot;
            totalCost = cost;
            freeOfCharge = foc;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
        ),
        child: Column(
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
                    : sales.length == 0
                        ? Center(
                            child: Text(
                              'No Items',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          )
                        : Column(
                            children: [
                              _labels(),
                              Expanded(
                                child: ListView.builder(
                                  itemBuilder: (context, index) => SaleListItem(
                                    item: sales[index],
                                    index: index,
                                  ),
                                  itemCount: sales.length,
                                ),
                              ),
                            ],
                          ),
              ),
            ),
            _totalLable()
          ],
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
          SizedBox(
            width: 5,
          ),
          LabelText(
            'Sale Id',
            Colors.black,
          ),
          LabelText(
            'Date',
            Colors.black,
            width: 130,
          ),
          LabelText(
            'Time',
            Colors.black,
            width: 130,
          ),
          SizedBox(
            width: 40,
          ),
          Expanded(
            child:
                LabelText('Customer', Colors.black, al: Alignment.centerLeft),
          ),
          LabelText(
            'Total Price',
            Colors.orange,
            width: 200,
          ),
        ],
      ),
    );
  }

  Widget _totalLable() {
    return Card(
      margin: EdgeInsets.all(0),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Total Sales',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                Spacer(),
                price.PriceView(
                  price: total,
                  color: Colors.red,
                  height: 35,
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Total Free Of Charge',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                ),
                Spacer(),
                price.PriceView(
                  price: freeOfCharge,
                  color: Colors.orange,
                  height: 35,
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Gross Profit',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                Spacer(),
                price.PriceView(
                  price: (total - totalCost),
                  color: Colors.green,
                  height: 35,
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _filter() {
    return Card(
      margin: EdgeInsets.all(0),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: [
            Text(
              'Date :',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 20,
            ),
            Container(
              width: 180,
              child: TextField(
                style: TextStyle(fontSize: 20),
                controller: dateController,
                readOnly: true,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime selected = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020, 01, 01),
                        lastDate: DateTime(2200),
                      );
                      if (selected != null) {
                        idController.text = '';
                        dateController.text =
                            DateFormat('yyyy-MM-dd').format(selected);
                        getSales(selected, null);
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 50,
            ),
            Text(
              'Sale Id :',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 20,
            ),
            Container(
              width: 100,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(8)),
              child: TextField(
                controller: idController,
                onChanged: (value) {
                  dateController.text = '';
                  setState(() {
                    saleId = int.parse(value);
                  });
                },
                onSubmitted: (value) {
                  getSales(null, int.parse(value));
                },
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              height: 40,
              child: FloatingActionButton(
                onPressed: () {
                  getSales(null, saleId);
                },
                child: Center(
                  child: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(
              width: 100,
            ),
            TextButton(
              onPressed: () {
                idController.text = '';
                dateController.text = '';
                getSales(null, null);
              },
              child: Text(
                'Get All',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              ),
            )
          ],
        ),
      ),
    );
  }
}
