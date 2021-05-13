import 'package:communication/helpers/api_service.dart';
import 'package:communication/model/other_charge.dart';
import 'package:communication/scoped_model/main.dart';
import 'package:communication/widgets/other_charge.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:scoped_model/scoped_model.dart';

class AllOtherCharges extends StatefulWidget {
  AllOtherCharges({Key key}) : super(key: key);
  @override
  _AllOtherChargesState createState() => _AllOtherChargesState();
}

class _AllOtherChargesState extends State<AllOtherCharges> {
  List<OtherCharge> allCharges = [];
  bool _isBusy = false;
  @override
  void initState() {
    _getAllCharges();
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
                                indicatorType: Indicator.lineScale),
                          ),
                        )
                      : model.otherCharges.length == 0
                          ? Center(
                              child: Text(
                                'No Charges',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            )
                          : Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemBuilder: (context, index) =>
                                        OtherChargeView(
                                      item: model.otherCharges[index],
                                      index: index,
                                    ),
                                    itemCount: model.otherCharges.length,
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

  _getAllCharges() {
    setState(() {
      _isBusy = true;
    });
    ApiService.shared.getOtherCharges().then((value) {
      if (this.mounted) {
        setState(() {
          _isBusy = false;
          allCharges = value;
          ScopedModel.of<MainModel>(context).setOtherCharges(value);
        });
      }
    });
  }
}
