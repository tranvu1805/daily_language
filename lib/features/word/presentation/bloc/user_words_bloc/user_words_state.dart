part of 'user_words_bloc.dart';

enum UserWordsStatus { initial, loading, success, failure }

enum UserWordsAction { none, request, refresh, detail }

final class UserWordsState extends Equatable {
  const UserWordsState({
    this.userWords = const [],
    this.status = UserWordsStatus.initial,
    this.hasReachedMax = false,
    this.lastDocId,
    this.action = UserWordsAction.none,
    this.error = '',
    this.selectedWordDetail,
  });

  final List<UserWord> userWords;
  final UserWordsAction action;
  final String error;
  final bool hasReachedMax;
  final String? lastDocId;
  final UserWordsStatus status;
  final Word? selectedWordDetail;

  UserWordsState copyWith({
    List<UserWord>? userWords,
    UserWordsStatus? status,
    bool? hasReachedMax,
    String? lastDocId,
    UserWordsAction? action,
    String? error,
    Word? selectedWordDetail,
  }) {
    return UserWordsState(
      userWords: userWords ?? this.userWords,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      lastDocId: lastDocId ?? this.lastDocId,
      action: action ?? this.action,
      status: status ?? this.status,
      error: error ?? this.error,
      selectedWordDetail: selectedWordDetail ?? this.selectedWordDetail,
    );
  }

  @override
  List<Object?> get props => [
    userWords,
    status,
    hasReachedMax,
    lastDocId,
    action,
    error,
    selectedWordDetail,
  ];
}
