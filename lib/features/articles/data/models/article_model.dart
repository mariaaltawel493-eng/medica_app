class ArticleModel {
  final int id;
  final String title;
  final String summary;
  final String? featuredImageUrl;
  final String category;
  final String authorType;
  final String authorName;
  final String publishedAt;
  final int viewCount;
  final String? content;

  ArticleModel({
    required this.id,
    required this.title,
    required this.summary,
    this.featuredImageUrl,
    required this.category,
    required this.authorType,
    required this.authorName,
    required this.publishedAt,
    required this.viewCount,
    this.content,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'],
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      featuredImageUrl: json['featured_image_url'],
      category: json['category'] ?? '',
      authorType: json['author_type'] ?? '',
      authorName: json['author_name'] ?? '',
      publishedAt: json['published_at'] ?? '',
      viewCount: json['view_count'] ?? 0,
      content: json['content'],
    );
  }
}
