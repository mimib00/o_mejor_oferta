import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/meta/models/user.dart';

class InboxThread {
  final int id;
  final User user;
  final DateTime updated;
  final DateTime? lastMessage;
  final String message;

  InboxThread(
    this.id,
    this.user,
    this.updated,
    this.lastMessage,
    this.message,
  );

  factory InboxThread.fromJson(Map<String, dynamic> data) {
    final me = Authenticator.instance.user.value!;

    final user = data["second_person"]["id"] == me.id
        ? User.fromJson(data["first_person"])
        : User.fromJson(data["second_person"]);
    return InboxThread(
      data["id"],
      user,
      DateTime.parse(data["updated"]),
      data["last_messaged"] == null ? null : DateTime.parse(data["last_messaged"]),
      data["message"] ?? "Nothing",
    );
  }
}
