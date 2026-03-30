part of 'review_word_bloc.dart';

abstract class ReviewWordEvent extends Equatable {
  const ReviewWordEvent();

  @override
  List<Object?> get props => [];
}

class ReviewWordLoaded extends ReviewWordEvent {
  final String userId;

  const ReviewWordLoaded({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ReviewWordRefreshed extends ReviewWordEvent {
  final String userId;

  const ReviewWordRefreshed({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ReviewWordAnswerSubmitted extends ReviewWordEvent {
  final String answer;

  const ReviewWordAnswerSubmitted({required this.answer});

  @override
  List<Object?> get props => [answer];
}

class ReviewWordNextRequested extends ReviewWordEvent {}

class ReviewWordFinishedRequested extends ReviewWordEvent {}
