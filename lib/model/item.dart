import 'package:communication/model/buy.dart';

class Item {
  Item({
    this.id,
    this.name,
    this.isDeleted,
    this.availableQuantity,
    this.sellPricePerItem,
    this.discount,
    this.buy,
  });

  int id;
  String name;
  bool isDeleted;
  double availableQuantity;
  double sellPricePerItem;
  double discount;
  Buy buy;
  double totalPrice = 0;
  double sellQuantity = 1;
  bool isDiscountAdd = false;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
      id: json["id"],
      name: json["name"],
      isDeleted: json["isDeleted"],
      availableQuantity: double.parse(json["availableQuantity"].toString()),
      sellPricePerItem: double.parse(json["sellPricePerItem"].toString()),
      discount: double.parse(json["discount"].toString()),
      buy: json['buys'] == null ? null : Buy.fromJson(json['buys'][0]));

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isDeleted": isDeleted,
        "availableQuantity": availableQuantity,
        "sellPricePerItem": sellPricePerItem,
        "discount": discount,
        "buy": buy
      };
}
