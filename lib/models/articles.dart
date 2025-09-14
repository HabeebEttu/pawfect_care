// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Articles {
  String userId;
  String title;
  String coverImageUrl;
  String articleContent;
  String subtitle;
  Articles({
    required this.userId,
    required this.title,
    required this.coverImageUrl,
    required this.articleContent,
    required this.subtitle,
  });

  Articles copyWith({
    String? userId,
    String? title,
    String? coverImageUrl,
    String? articleContent,
    String? subtitle,
  }) {
    return Articles(
      userId: userId ?? this.userId,
      title: title ?? this.title,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      articleContent: articleContent ?? this.articleContent,
      subtitle: subtitle ?? this.subtitle,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'title': title,
      'coverImageUrl': coverImageUrl,
      'articleContent': articleContent,
      'subtitle': subtitle,
    };
  }

  factory Articles.fromMap(Map<String, dynamic> map) {
    return Articles(
      userId: map['userId'] as String,
      title: map['title'] as String,
      coverImageUrl: map['coverImageUrl'] as String,
      articleContent: map['articleContent'] as String,
      subtitle: map['subtitle'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Articles.fromJson(String source) =>
      Articles.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Articles(userId: $userId, title: $title, coverImageUrl: $coverImageUrl, articleContent: $articleContent, subtitle: $subtitle)';
  }

  @override
  bool operator ==(covariant Articles other) {
    if (identical(this, other)) return true;
  
    return 
      other.userId == userId &&
      other.title == title &&
      other.coverImageUrl == coverImageUrl &&
      other.articleContent == articleContent &&
      other.subtitle == subtitle;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
      title.hashCode ^
      coverImageUrl.hashCode ^
      articleContent.hashCode ^
      subtitle.hashCode;
  }
}
