import './sale_item.dart';

import 'cashier.dart';

class Sale {
  Sale({
    this.id,
    this.customer,
    this.date,
    this.totalAmount,
    this.cashierId,
    this.cashier,
    this.saleItems,
  });

  int id;
  String customer;
  DateTime date;
  int totalAmount;
  int cashierId;
  Cashier cashier;
  List<SaleItem> saleItems;

  factory Sale.fromJson(Map<String, dynamic> json) => Sale(
        id: json["id"],
        customer: json["customer"],
        date: DateTime.parse(json["date"]),
        totalAmount: json["totalAmount"],
        cashierId: json["cashierId"],
        cashier: Cashier.fromJson(json["cashier"]),
        saleItems: List<SaleItem>.from(
            json["saleItems"].map((x) => SaleItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer": customer,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "totalAmount": totalAmount,
        "cashierId": cashierId,
        "cashier": cashier.toJson(),
        "saleItems": List<dynamic>.from(saleItems.map((x) => x.toJson())),
      };
}
