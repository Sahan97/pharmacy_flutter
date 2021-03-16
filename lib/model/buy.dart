class Buy {
  Buy({
    this.id,
    this.seller,
    this.date,
    this.quantity,
    this.buyPricePerItem,
    this.itemId,
  });

  int id;
  String seller;
  DateTime date;
  double quantity;
  double buyPricePerItem;
  double itemId;

  factory Buy.fromJson(Map<String, dynamic> json) => Buy(
        id: json["id"],
        seller: json["seller"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        quantity: json["quantity"] == null
            ? null
            : double.parse(json["quantity"].toString()),
        buyPricePerItem: json["buyPricePerItem"] == null
            ? null
            : double.parse(json["buyPricePerItem"].toString()),
        itemId: json["itemId"] == null
            ? null
            : double.parse(json["itemId"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "seller": seller,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "quantity": quantity,
        "buyPricePerItem": buyPricePerItem,
        "itemId": itemId,
      };
}
