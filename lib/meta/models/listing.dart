import 'package:mejor_oferta/meta/models/state.dart';

enum ListingStatus {
  draft,
  published,
  sold,
  archived;
}

class Listing {}

class ListingThumb {
  final int id;
  final String title;
  final States state;
  final double price;
  final String image;
  final DateTime created;
  final DateTime updated;

  ListingThumb(
    this.id,
    this.title,
    this.state,
    this.price,
    this.image,
    this.created,
    this.updated,
  );

  factory ListingThumb.fromJson(Map<String, dynamic> data) {
    return ListingThumb(
      data["id"],
      data["name"],
      States.fromJson(data["state"]),
      double.parse(data["price"]),
      data["image"],
      DateTime.parse(data["created_at"]),
      DateTime.parse(data["updated_at"]),
    );
  }
}
