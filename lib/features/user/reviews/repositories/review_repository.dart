import '../models/review_model.dart';
import '../services/review_service.dart';

class ReviewRepository {
  final ReviewService service;

  ReviewRepository(this.service);

  Future<ReviewModel> submitReview(
    int appointmentId,
    int rating,
  ) async {
    final response = await service.submitReview(
      appointmentId,
      rating,
    );

    return ReviewModel.fromJson(response["data"]);
  }
}