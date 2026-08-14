import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/features/user/reviews/models/review_model.dart';
import 'package:medica_app/features/user/reviews/repositories/review_repository.dart';


import 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final ReviewRepository repository;

  ReviewCubit(this.repository) : super(ReviewInitial());

  ReviewModel? review;

  int selectedRating = 0;

  /// عند الضغط على النجوم
  void changeRating(int rating) {
    selectedRating = rating;
    emit(ReviewSuccess(selectedRating));
  }

  /// إرسال التقييم (إذا ما كان موجود يعمل POST وإذا موجود يعمل PUT)
  Future<void> submitReview({
    required int appointmentId,
    required int rating,
  }) async {
    emit(ReviewLoading());

    try {
      review = await repository.submitReview(appointmentId, rating);

      selectedRating = review!.rating;

      emit(ReviewSuccess(selectedRating));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }
}
