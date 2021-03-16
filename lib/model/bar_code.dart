import 'package:communication/model/item.dart';

class Barcode {
  Barcode({
    this.id,
    this.barcode,
    this.itemId,
    this.item,
  });

  int id;
  String barcode;
  int itemId;
  Item item;

  factory Barcode.fromJson(Map<String, dynamic> json) => Barcode(
        id: json["id"],
        barcode: json["barcode"],
        itemId: json["itemId"],
        item: Item.fromJson(json["item"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "barcode": barcode,
        "itemId": itemId,
        "item": item.toJson(),
      };
}
