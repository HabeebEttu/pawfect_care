// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Review {
  String id;
  String userId;
  String content;
  DateTime createdAt;
  Review({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
  });
  

  Review copyWith({
    String? id,
    String? userId,
    String? content,
    DateTime? createdAt,
  }) {
    return Review(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] as String,
      userId: map['userId'] as String,
      content: map['content'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Review.fromJson(String source) => Review.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Review(id: $id, userId: $userId, content: $content, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant Review other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.userId == userId &&
      other.content == content &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userId.hashCode ^
      content.hashCode ^
      createdAt.hashCode;
  }
}
