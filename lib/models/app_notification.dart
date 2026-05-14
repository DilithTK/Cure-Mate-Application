class AppNotification {
  final String id;
  final String title;
  final String message;
  final String type; // user / pharmacy
  final String targetId; // uid or pharmacyId
  final DateTime createdAt;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.targetId,
    required this.createdAt,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'type': type,
      'targetId': targetId,
      'createdAt': createdAt,
      'isRead': isRead,
    };
  }

  factory AppNotification.fromMap(String id, Map<String, dynamic> map) {
    return AppNotification(
      id: id,
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      type: map['type'] ?? '',
      targetId: map['targetId'] ?? '',
      createdAt: (map['createdAt'] as dynamic).toDate(),
      isRead: map['isRead'] ?? false,
    );
  }
}