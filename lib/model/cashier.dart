class Cashier {
  Cashier({
    this.name,
  });

  String name;

  factory Cashier.fromJson(Map<String, dynamic> json) => Cashier(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {"name": name};
}
