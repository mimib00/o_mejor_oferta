class Brand {
  final int id;
  final String name;

  Brand(
    this.id,
    this.name,
  );

  factory Brand.fromJson(Map<String, dynamic> data) {
    return Brand(
      data["id"],
      data["name"],
    );
  }
}
