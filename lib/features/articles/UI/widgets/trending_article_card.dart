import 'package:flutter/material.dart';
import 'package:medica_app/core/theme/app_colors.dart';

class TrendingArticleCard extends StatelessWidget {
  final String image;
  final String title;
  final int articleId;

  const TrendingArticleCard({
    super.key,
    required this.image,
    required this.title,
    required this.articleId,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              image,
              height: 150,
              width: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
                  width: 250,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.broken_image,
                    size: 60,
                    color: Colors.red,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darktextPrimary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
