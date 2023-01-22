import 'package:mejor_oferta/meta/models/listing.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? state;
  final double? lat;
  final double? long;
  final String? photo;
  final String? facebookHandle;
  final int sold;
  final int bought;
  final bool nsfwAllowed;
  final double rating;
  final List<ListingThumb> listings;

  User(
    this.id,
    this.name,
    this.email,
    this.phone,
    this.state,
    this.lat,
    this.long,
    this.photo,
    this.facebookHandle,
    this.sold,
    this.bought,
    this.nsfwAllowed,
    this.rating,
    this.listings,
  );

  factory User.fromJson(Map<String, dynamic> data) {
    List<ListingThumb> thumbs = [];
    if (data["listings"] != null) {
      for (var listing in data["listings"]) {
        thumbs.add(ListingThumb.fromJson(listing));
      }
    }
    return User(
      data["id"],
      data["name"],
      data["email"],
      data["phone_number"],
      data["location"],
      double.parse(data["location_lat"] ?? "0"),
      double.parse(data["location_long"] ?? "0"),
      data["profile_picture"],
      data["facebook_handle"] == null || data["facebook_handle"] == "" ? null : "https://www.facebook.com/${data["facebook_handle"]}",
      data["sold_items"] ?? 0,
      data["bought_items"] ?? 0,
      data["is_nsfw_allowed"] ?? false,
      data["average_rating"] ?? 0,
      thumbs,
    );
  }
}
