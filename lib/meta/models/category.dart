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

class FullCategory {
  final int id;
  final String name;
  final String? photo;
  final List<Category> children;

  FullCategory(
    this.id,
    this.name,
    this.photo,
    this.children,
  );

  factory FullCategory.fromJson(Map<String, dynamic> data) {
    List<Category> categories = [];
    for (var cat in data["sub_categories"]) {
      categories.add(Category.fromJson(cat));
    }
    return FullCategory(
      data["id"],
      data["name"],
      data["image"],
      categories,
    );
  }
}
