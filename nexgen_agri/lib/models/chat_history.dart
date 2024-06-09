class ChatHistory {
  final int? id;
  final String userId;
  final String role;
  final String content;
  final int timestamp;

  ChatHistory({
    this.id,
    required this.userId,
    required this.role,
    required this.content,
    required this.timestamp,
  });

  ChatHistory.fromMap(Map<dynamic, dynamic> map)
      : id = map['id'],
        userId = map['user_id'],
        role = map['role'],
        content = map['content'],
        timestamp = map['timestamp'];
}
