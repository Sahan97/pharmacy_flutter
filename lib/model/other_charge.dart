class OtherCharge {
  OtherCharge({
    this.id,
    this.name,
    this.isDeleted,
  });

  int id;
  String name;
  bool isDeleted;
  factory OtherCharge.fromJson(Map<String, dynamic> json) => OtherCharge(
        id: json["id"],
        name: json["name"],
        isDeleted: json["isDeleted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isDeleted": isDeleted,
      };
}
