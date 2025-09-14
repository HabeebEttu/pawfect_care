import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  final String id;
  final String title;
  final String coverImageUrl;
  final String articleContent;
  final String subtitle;
  final String authorId;
  final String authorRole;
  final DateTime createdAt;

  Article({
    required this.id,
    required this.title,
    required this.coverImageUrl,
    required this.articleContent,
    required this.subtitle,
    required this.authorId,
    required this.authorRole,
    required this.createdAt,
  });

  Article copyWith({
    String? id,
    String? title,
    String? coverImageUrl,
    String? articleContent,
    String? subtitle,
    String? authorId,
    String? authorRole,
    DateTime? createdAt,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      articleContent: articleContent ?? this.articleContent,
      subtitle: subtitle ?? this.subtitle,
      authorId: authorId ?? this.authorId,
      authorRole: authorRole ?? this.authorRole,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Convert this Article to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      // we usually don’t store the id because doc.id is used,
      // but keep it if you prefer.
      'title': title,
      'coverImageUrl': coverImageUrl,
      'articleContent': articleContent,
      'subtitle': subtitle,
      'authorId': authorId,
      'authorRole': authorRole,
      // store as Timestamp for Firestore
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Build an Article from a Firestore document snapshot
  factory Article.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Article(
      id: doc.id,
      title: data['title'] ?? '',
      coverImageUrl: data['coverImageUrl'] ?? '',
      articleContent: data['articleContent'] ?? '',
      subtitle: data['subtitle'] ?? '',
      authorId: data['authorId'] ?? '',
      authorRole: data['authorRole'] ?? '',
      createdAt: (data['createdAt'] is Timestamp)
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(data['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  /// If you ever need to decode from raw JSON (not Firestore)
  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      coverImageUrl: map['coverImageUrl'] ?? '',
      articleContent: map['articleContent'] ?? '',
      subtitle: map['subtitle'] ?? '',
      authorId: map['authorId'] ?? '',
      authorRole: map['authorRole'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Article.fromJson(String source) =>
      Article.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Article(id: $id, title: $title, authorRole: $authorRole, createdAt: $createdAt)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Article &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              title == other.title &&
              coverImageUrl == other.coverImageUrl &&
              articleContent == other.articleContent &&
              subtitle == other.subtitle &&
              authorId == other.authorId &&
              authorRole == other.authorRole &&
              createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      coverImageUrl.hashCode ^
      articleContent.hashCode ^
      subtitle.hashCode ^
      authorId.hashCode ^
      authorRole.hashCode ^
      createdAt.hashCode;
}
