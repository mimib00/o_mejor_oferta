class Category {
  final int id;
  final String name;
  final String? photo;

  Category(
    this.id,
    this.name,
    this.photo,
  );

  factory Category.fromJson(Map<String, dynamic> data) {
    return Category(
      data["id"],
      data["name"],
      data["image"],
    );
  }
}
