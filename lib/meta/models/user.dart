class User {
  final String name;
  final String email;
  final String phone;
  final String? state;
  final double? lat;
  final double? long;
  final String? photo;

  User(
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
      data["name"],
      data["email"],
      data["phone_number"],
      data["location"],
      data["location_lat"],
      data["location_long"],
      data["profile_picture"],
    );
  }
}
