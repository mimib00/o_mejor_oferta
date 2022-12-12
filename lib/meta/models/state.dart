class States {
  final int id;
  final String name;

  States(
    this.id,
    this.name,
  );

  factory States.fromJson(Map<String, dynamic> data) {
    return States(
      data["id"],
      data["name"],
    );
  }
}
