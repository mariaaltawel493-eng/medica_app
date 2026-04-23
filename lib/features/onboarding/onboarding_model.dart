class OnboardingModel {
  final String image; // مسار الصورة أو ملف الـ JSON
  final String title;
  final String description;
  final bool isLottie; // عشان نميز إذا كان أنيميشن أو صورة عادية

  OnboardingModel({
    required this.image,
    required this.title,
    required this.description,
    this.isLottie = false,
  });
}
