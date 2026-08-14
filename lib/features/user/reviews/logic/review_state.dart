abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewSuccess extends ReviewState {
  final int rating;

  ReviewSuccess(this.rating);
}

class ReviewError extends ReviewState {
  final String message;

  ReviewError(this.message);
}