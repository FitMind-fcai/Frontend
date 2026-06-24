// lib/data/models/coaching_message_model.dart

class CoachingMessageModel {
  final int id;
  final String category;
  final String urgency;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;

  CoachingMessageModel({
    required this.id,
    required this.category,
    required this.urgency,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
  });

  factory CoachingMessageModel.fromJson(Map<String, dynamic> json) {
    return CoachingMessageModel(
      id: json['id'] as int,
      category: json['category'] as String,
      urgency: json['urgency'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      isRead: json['is_read'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  CoachingMessageModel copyWith({bool? isRead}) {
    return CoachingMessageModel(
      id: id,
      category: category,
      urgency: urgency,
      title: title,
      body: body,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }
}

class CoachingMessagesResponse {
  final List<CoachingMessageModel> messages;
  final int unreadCount;

  CoachingMessagesResponse({required this.messages, required this.unreadCount});

  factory CoachingMessagesResponse.fromJson(Map<String, dynamic> json) {
    return CoachingMessagesResponse(
      messages: (json['messages'] as List)
          .map((e) => CoachingMessageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      unreadCount: json['unread_count'] as int,
    );
  }
}