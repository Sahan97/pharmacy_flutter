class User {
  User({
    this.id,
    this.name,
    this.userName,
    this.isDeleted,
    this.isAdmin,
  });

  int id;
  String name;
  String userName;
  bool isDeleted;
  bool isAdmin;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        userName: json["userName"],
        isDeleted: json["isDeleted"],
        isAdmin: json["isAdmin"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "userName": userName,
        "isDeleted": isDeleted,
        "isAdmin": isAdmin,
      };
}
