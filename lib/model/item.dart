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
  });

  int id;
  String name;
  String code;
  String category;
  String priceCategory;
  double buyPrice;
  double sellPrice;
  double currentQty;
  double reOrderQty;
  bool isActive;
  double totalPrice = 0;
  double sellQuantity = 1;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        category: json["category"],
        priceCategory: json["priceCategory"],
        buyPrice: json["buyPrice"].toDouble(),
        sellPrice: json["sellPrice"].toDouble(),
        currentQty: json["currentQty"].toDouble(),
        reOrderQty: json["reOrderQty"].toDouble(),
        isActive: json["isActive"],
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
      };
}
