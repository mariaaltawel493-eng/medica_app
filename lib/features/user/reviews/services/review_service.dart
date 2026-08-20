

import 'package:medica_app/core/networking/api_service.dart';

class ReviewService {
  final ApiService apiService;

  ReviewService(this.apiService);

  /// إنشاء تقييم جديد
  Future<Map<String, dynamic>> createReview(
    int appointmentId,
    int rating,
  ) async {
    return await apiService.post("appointments/$appointmentId/reviews", {
      "rating": rating,
    });
  }

  /// تعديل تقييم موجود
  Future<Map<String, dynamic>> updateReview(
    int appointmentId,
    int rating,
  ) async {
    return await apiService.put(
      "appointments/$appointmentId/review",
      body: {"rating": rating},
    );
  }

  /// الدالة التي ستستخدمها الشاشة
  /// تحاول POST وإذا كان التقييم موجود تعمل PUT
  Future<Map<String, dynamic>> submitReview(
    int appointmentId,
    int rating,
  ) async {
    try {
      final response = await createReview(appointmentId, rating);

      print("POST RESPONSE: $response");

      return response;
    } catch (e) {
      print("POST ERROR: $e");

      final response = await updateReview(appointmentId, rating);

      print("PUT RESPONSE: $response");

      return response;
    }
  }
}
