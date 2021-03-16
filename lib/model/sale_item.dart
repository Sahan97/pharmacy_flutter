import 'package:communication/model/cashier.dart';

class SaleItem {
  SaleItem({
    this.quantity,
    this.isDiscountGiven,
    this.lastSellPrice,
    this.item,
  });

  double quantity;
  bool isDiscountGiven;
  double lastSellPrice;
  Cashier item;

  factory SaleItem.fromJson(Map<String, dynamic> json) => SaleItem(
        quantity: double.parse(json["quantity"].toString()),
        isDiscountGiven: json["isDiscountGiven"],
        lastSellPrice: double.parse(json["lastSellPrice"].toString()),
        item: Cashier.fromJson(json["item"]),
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
        "isDiscountGiven": isDiscountGiven,
        "lastSellPrice": lastSellPrice,
        "item": item.toJson(),
      };
}
