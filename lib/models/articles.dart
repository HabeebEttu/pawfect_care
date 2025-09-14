import 'dart:convert';

class Articles {
  String title;
  String coverImageUrl;
  String articleContent;
  String subtitle;
  Articles({
    required this.title,
    required this.coverImageUrl,
    required this.articleContent,
    required this.subtitle

  });

  Articles copyWith({
    String? title,
    String? coverImageUrl,
    String? articleContent,
  }) {
    return Articles(
      title: title ?? this.title,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      articleContent: articleContent ?? this.articleContent,
      subtitle: subtitle ?? this.subtitle
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'coverImageUrl': coverImageUrl,
      'articleContent': articleContent,
      'subtitle': subtitle
    };
  }

  factory Articles.fromMap(Map<String, dynamic> map) {
    return Articles(
      title: map['title'] as String,
      coverImageUrl: map['coverImageUrl'] as String,
      articleContent: map['articleContent'] as String,
      subtitle: map['subtitle']
    );
  }

  String toJson() => json.encode(toMap());

  factory Articles.fromJson(String source) => Articles.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Articles(title: $title, coverImageUrl: $coverImageUrl, articleContent: $articleContent)';

  @override
  bool operator ==(covariant Articles other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
      other.coverImageUrl == coverImageUrl &&
      other.articleContent == articleContent;
  }

  @override
  int get hashCode => title.hashCode ^ coverImageUrl.hashCode ^ articleContent.hashCode;
}
