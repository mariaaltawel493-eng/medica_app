class BannerModel {
  final String type; // 'advertisement' أو 'article'
  final int id;
  final String? image;
  final String? title; // خاص بالمقال فقط (nullable)
  final String? category; // خاص بالمقال فقط (nullable)

  BannerModel({
    required this.type,
    required this.id,
    this.image,
    this.title,
    this.category,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      type: json['type'] ?? '',
      id: json['id'] ?? 0,
      image: json['image'], // يأتي برابط كامل أو null
      title: json['title'], // سيقرأ القيمة لو كان نوعه article
      category: json['category'], // سيقرأ القيمة لو كان نوعه article
    );
  }
}
