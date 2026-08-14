import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/core/routing/routes.dart';
import 'package:medica_app/core/theme/app_colors.dart';

class MedicalDocumentsCard extends StatelessWidget {
  final List<dynamic>? documents;
  final Function(int docId)? onDeleteDocument;
  final int? deletingDocId; // 💡 تتبع الملف الذي يتم حذفه الآن لمنع التداخل

  const MedicalDocumentsCard({
    super.key,
    this.documents,
    this.onDeleteDocument,
    this.deletingDocId, // تمريره من الـ Bloc Builder بالشاشة الأساسية
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final List<dynamic> docsList = documents ?? [];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkcardBackground : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الهيدر
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "medical.medical_documents".tr().toUpperCase(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: isDark
                      ? AppColors.darktextPrimary
                      : AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
              const Icon(
                Icons.file_copy_outlined,
                size: 24,
                color: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // شبكة المستندات
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: docsList.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return _buildAddButton(context, isDark);

              final doc = docsList[index - 1];
              final String filePath = doc['file_path'] ?? '';
              final int docId = doc['id'] ?? 0;
              final String fullUrl = doc['document_url'] ?? '';

              bool isPdf = filePath.toLowerCase().endsWith('.pdf');
              // 💡 التحقق هل هذا الملف بعينه قيد الحذف حالياً؟
              bool isThisDocDeleting = deletingDocId == docId;

              return _buildDocumentItem(
                isDark: isDark,
                isPdf: isPdf,
                fileUrl: fullUrl,
                isDeleting: isThisDocDeleting,
                onDelete: () {
                  if (onDeleteDocument != null &&
                      docId != 0 &&
                      deletingDocId == null) {
                    onDeleteDocument!(docId);
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.UploadDocumentScreen);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.black12,
            width: 1.5,
          ),
        ),
        child: const Icon(
          Icons.add_rounded,
          color: AppColors.primary,
          size: 35,
        ),
      ),
    );
  }

  Widget _buildDocumentItem({
    required bool isDark,
    required bool isPdf,
    required String fileUrl,
    required bool isDeleting,
    required VoidCallback onDelete,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.08) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: isPdf
                ? const Center(
                    child: Icon(
                      Icons.picture_as_pdf_rounded,
                      color: AppColors.primary,
                      size: 35,
                    ),
                  )
                : Image.network(
                    fileUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: Colors.grey,
                          size: 30,
                        ),
                      );
                    },
                  ),
          ),
        ),

        // زر الحذف الذكي (يتحول لمؤشر تحميل عند الحذف)
        Positioned(
          top: -4,
          right: -4,
          child: GestureDetector(
            onTap: isDeleting ? null : onDelete,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: isDeleting
                  ? const SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.close, size: 10, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
