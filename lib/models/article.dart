// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:pawfect_care/models/review.dart';

class Article {
  String userId;
  String id;
  String title;
  String coverImageUrl;
  String articleContent;
  String subtitle;
  List<Review> reviews;

  Article({
    required this.userId,
    required this.id,
    required this.title,
    required this.coverImageUrl,
    required this.articleContent,
    required this.subtitle,
    required this.reviews,
  });

  Article copyWith({
    String? userId,
    String? id,
    String? title,
    String? coverImageUrl,
    String? articleContent,
    String? subtitle,
    List<Review>? reviews,
  }) {
    return Article(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      articleContent: articleContent ?? this.articleContent,
      subtitle: subtitle ?? this.subtitle,
      reviews: reviews ?? this.reviews,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'id': id,
      'title': title,
      'coverImageUrl': coverImageUrl,
      'articleContent': articleContent,
      'subtitle': subtitle,
      'reviews': reviews.map((x) => x.toMap()).toList(),
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      userId: map['userId'] as String,
      id: map['id'] as String,
      title: map['title'] as String,
      coverImageUrl: map['coverImageUrl'] as String,
      articleContent: map['articleContent'] as String,
      subtitle: map['subtitle'] as String,
      reviews: List<Review>.from((map['reviews'] as List<int>).map<Review>((x) => Review.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory Article.fromJson(String source) =>
      Article.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Article(userId: $userId, id: $id, title: $title, coverImageUrl: $coverImageUrl, articleContent: $articleContent, subtitle: $subtitle, reviews: $reviews)';
  }

  @override
  bool operator ==(covariant Article other) {
    if (identical(this, other)) return true;
  
    return 
      other.userId == userId &&
      other.id == id &&
      other.title == title &&
      other.coverImageUrl == coverImageUrl &&
      other.articleContent == articleContent &&
      other.subtitle == subtitle &&
      listEquals(other.reviews, reviews);
  }

  @override
  int get hashCode {
    return userId.hashCode ^
      id.hashCode ^
      title.hashCode ^
      coverImageUrl.hashCode ^
      articleContent.hashCode ^
      subtitle.hashCode ^
      reviews.hashCode;
  }
}
