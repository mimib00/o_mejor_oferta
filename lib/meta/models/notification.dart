class NotificationMessage {
  final int id;
  final int user;
  final String title;
  final String message;
  final DateTime createdAt;

  NotificationMessage(
    this.id,
    this.user,
    this.title,
    this.message,
    this.createdAt,
  );

  factory NotificationMessage.fromJson(Map<String, dynamic> data) {
    return NotificationMessage(
      data["id"],
      data["user"],
      data["title"],
      data["message"],
      DateTime.parse(data["created_at"]),
    );
  }
}
