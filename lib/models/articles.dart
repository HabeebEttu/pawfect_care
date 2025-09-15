import 'dart:convert';

class Articles {
  String coverImageUrl;
  String title;
  String subtitle;
  String date;
  String articleContent;
  Articles({
    required this.coverImageUrl,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.articleContent,
  });

  Articles copyWith({
    String? coverImageUrl,
    String? title,
    String? subtitle,
    String? date,
    String? articleContent,
  }) {
    return Articles(
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      articleContent: articleContent ?? this.articleContent,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'coverImageUrl': coverImageUrl,
      'title': title,
      'author': subtitle,
      'date': date,
      'articleContent': articleContent,
    };
  }

  factory Articles.fromMap(Map<String, dynamic> map) {
    return Articles(
      coverImageUrl: map['coverImageUrl'] as String,
      title: map['title'] as String,
      subtitle: map['author'] as String,
      date: map['date'] as String,
      articleContent: map['articleContent'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Articles.fromJson(String source) =>
      Articles.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Articles(coverImageUrl: $coverImageUrl, title: $title, author: $subtitle,date: $date  articleContent: $articleContent)';

  @override
  bool operator ==(covariant Articles other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.coverImageUrl == coverImageUrl &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.date == date &&
        other.articleContent == articleContent;
  }

  @override
  int get hashCode =>
      coverImageUrl.hashCode ^
      title.hashCode ^
      subtitle.hashCode ^
      date.hashCode ^
      articleContent.hashCode;
}
