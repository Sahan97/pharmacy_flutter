class OtherCharge {
  OtherCharge({this.id, this.name, this.isDeleted, this.price});

  int id;
  String name;
  bool isDeleted;
  int price;
  factory OtherCharge.fromJson(Map<String, dynamic> json) => OtherCharge(
        id: json["id"],
        name: json["name"],
        isDeleted: json["isDeleted"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "isDeleted": isDeleted,
      };
}
