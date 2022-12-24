import 'dart:developer';

import 'package:mejor_oferta/meta/models/listing.dart';
import 'package:mejor_oferta/meta/models/user.dart';

enum OfferStatus {
  pending,
  accepted,
  declined,
  cancelled;

  const OfferStatus();
  factory OfferStatus.getStatus(String status) {
    switch (status) {
      case "PENDING":
        return OfferStatus.pending;
      case "ACCEPTED":
        return OfferStatus.accepted;
      case "DECLINED":
        return OfferStatus.declined;
      case "CANCELLED":
        return OfferStatus.cancelled;
      default:
        return OfferStatus.pending;
    }
  }
}

class Offer {
  final int id;
  final Listing listing;
  final User user;
  final String price;
  final OfferStatus status;
  final DateTime created;
  final DateTime updated;

  Offer(
    this.id,
    this.listing,
    this.user,
    this.price,
    this.status,
    this.created,
    this.updated,
  );

  factory Offer.fromJson(Map<String, dynamic> data, Listing listing) {
    return Offer(
      data["id"],
      listing,
      User.fromJson(data["user"]),
      data["price"],
      OfferStatus.getStatus(data["status"]),
      DateTime.parse(data["created_at"]),
      DateTime.parse(data["updated_at"]),
    );
  }
}
