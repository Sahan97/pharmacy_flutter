// To parse this JSON data, do
//
//     final sale = saleFromJson(jsonString);

import 'dart:convert';

Sale saleFromJson(String str) => Sale.fromJson(json.decode(str));

String saleToJson(Sale data) => json.encode(data.toJson());

class Sale {
  Sale({
    this.id,
    this.customer,
    this.otherCharges,
    this.totalPrice,
    this.createdAt,
    this.date,
    this.time,
    this.pharmacyItems,
  });

  int id;
  String customer;
  List<OtherCharge> otherCharges;
  int totalPrice;
  DateTime createdAt;
  String date;
  String time;
  List<PharmacyItem> pharmacyItems;

  factory Sale.fromJson(Map<String, dynamic> json) => Sale(
        id: json["id"],
        customer: json["customer"],
        otherCharges: List<OtherCharge>.from(
            json["otherCharges"].map((x) => OtherCharge.fromJson(x))),
        totalPrice: json["totalPrice"],
        createdAt: DateTime.parse(json["createdAt"]),
        date: json["date"],
        time: json["time"],
        pharmacyItems: List<PharmacyItem>.from(
            json["pharmacyItems"].map((x) => PharmacyItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer": customer,
        "otherCharges": List<dynamic>.from(otherCharges.map((x) => x.toJson())),
        "totalPrice": totalPrice,
        "createdAt": createdAt.toIso8601String(),
        "date": date,
        "time": time,
        "pharmacyItems":
            List<dynamic>.from(pharmacyItems.map((x) => x.toJson())),
      };
}

class OtherCharge {
  OtherCharge({
    this.name,
    this.qty,
    this.itemPrice,
  });

  String name;
  int qty;
  int itemPrice;

  factory OtherCharge.fromJson(Map<String, dynamic> json) => OtherCharge(
        name: json["name"],
        qty: json["qty"],
        itemPrice: json["itemPrice"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "qty": qty,
        "itemPrice": itemPrice,
      };
}

class PharmacyItem {
  PharmacyItem({
    this.id,
    this.quantity,
    this.unitPrice,
    this.createdAt,
    this.item,
  });

  int id;
  int quantity;
  int unitPrice;
  DateTime createdAt;
  Item item;

  factory PharmacyItem.fromJson(Map<String, dynamic> json) => PharmacyItem(
        id: json["id"],
        quantity: json["quantity"],
        unitPrice: json["unitPrice"],
        createdAt: DateTime.parse(json["createdAt"]),
        item: Item.fromJson(json["item"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": quantity,
        "unitPrice": unitPrice,
        "createdAt": createdAt.toIso8601String(),
        "item": item.toJson(),
      };
}

class Item {
  Item({
    this.id,
    this.name,
    this.code,
    this.category,
    this.priceCategory,
    this.buyPrice,
    this.sellPrice,
    this.currentQty,
    this.reOrderQty,
    this.isActive,
    this.createdAt,
  });

  int id;
  String name;
  String code;
  String category;
  String priceCategory;
  int buyPrice;
  int sellPrice;
  int currentQty;
  int reOrderQty;
  bool isActive;
  DateTime createdAt;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        category: json["category"],
        priceCategory: json["priceCategory"],
        buyPrice: json["buyPrice"].toInt(),
        sellPrice: json["sellPrice"],
        currentQty: json["currentQty"],
        reOrderQty: json["reOrderQty"],
        isActive: json["isActive"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "category": category,
        "priceCategory": priceCategory,
        "buyPrice": buyPrice,
        "sellPrice": sellPrice,
        "currentQty": currentQty,
        "reOrderQty": reOrderQty,
        "isActive": isActive,
        "createdAt": createdAt.toIso8601String(),
      };
}
