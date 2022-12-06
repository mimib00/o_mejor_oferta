class User {
  final String name;
  final String email;
  final String phone;

  User(
    this.name,
    this.email,
    this.phone,
  );

  factory User.fromJson(Map<String, dynamic> data) {
    return User(
      data["name"],
      data["email"],
      data["phone_number"],
    );
  }
}
