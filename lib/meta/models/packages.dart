class Packages {
  final int id;
  final String name;
  final String description;
  final double price;
  final int duration;

  Packages(
    this.id,
    this.name,
    this.description,
    this.price,
    this.duration,
  );
  factory Packages.fromJson(Map<String, dynamic> data) {
    return Packages(
      data["id"],
      data["name"],
      data["description"],
      data["price"],
      data["duration_days"],
    );
  }
}
