class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? state;
  final double? lat;
  final double? long;
  final String? photo;

  User(
    this.id,
    this.name,
    this.email,
    this.phone,
    this.state,
    this.lat,
    this.long,
    this.photo,
  );

  factory User.fromJson(Map<String, dynamic> data) {
    return User(
      data["id"],
      data["name"],
      data["email"],
      data["phone_number"],
      data["location"],
      double.parse(data["location_lat"] ?? "0"),
      double.parse(data["location_long"] ?? "0"),
      data["profile_picture"],
    );
  }
}
