import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/meta/models/user.dart';

class InboxThread {
  final int id;
  final User user;
  final DateTime updated;
  final DateTime? lastMessage;
  String message;

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
      data["last_message_timestamp"] == null ? null : DateTime.parse(data["last_message_timestamp"]),
      data["last_message"] ?? "No Message",
    );
  }
}

class Message {
  final int id;
  final int thread;
  final User user;
  final String message;
  final DateTime timestamp;

  Message(
    this.id,
    this.thread,
    this.user,
    this.message,
    this.timestamp,
  );

  factory Message.fromJson(Map<String, dynamic> data) {
    return Message(
      data["id"],
      data["thread"],
      User.fromJson(data["user"]),
      data["message"],
      DateTime.parse(data["timestamp"]),
    );
  }
}
