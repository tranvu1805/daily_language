import 'package:equatable/equatable.dart';

class UserWord extends Equatable {
  final String id;
  final String userId;
  final String wordId;
  final String word;
  final String level;
  final int repetitionCount;
  final int wrongCount;
  final int stage;
  final DateTime lastReviewed;
  final DateTime nextReview;
  final num easeFactor;
  final num interval;

  const UserWord({
    required this.id,
    required this.userId,
    required this.wordId,
    required this.level,
    required this.repetitionCount,
    required this.wrongCount,
    required this.stage,
    required this.lastReviewed,
    required this.nextReview,
    required this.easeFactor,
    required this.interval,
    required this.word,
  });

  UserWord.empty({
    this.id = '',
    this.userId = '',
    this.wordId = '',
    this.repetitionCount = 0,
    this.wrongCount = 0,
    this.word = '',
    this.stage = 0,
    this.level = '',
    DateTime? lastReviewed,
    DateTime? nextReview,
    this.easeFactor = 2.5,
    this.interval = 1,
  }) : lastReviewed = lastReviewed ?? DateTime.now(),
       nextReview = nextReview ?? DateTime.now().add(const Duration(days: 1));

  UserWord copyWith({
    String? id,
    String? userId,
    String? wordId,
    String? word,
    String? level,
    int? repetitionCount,
    int? wrongCount,
    int? stage,
    DateTime? lastReviewed,
    DateTime? nextReview,
    num? easeFactor,
    num? interval,
  }) {
    return UserWord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      wordId: wordId ?? this.wordId,
      word: word ?? this.word,
      level: level ?? this.level,
      repetitionCount: repetitionCount ?? this.repetitionCount,
      wrongCount: wrongCount ?? this.wrongCount,
      stage: stage ?? this.stage,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      nextReview: nextReview ?? this.nextReview,
      easeFactor: easeFactor ?? this.easeFactor,
      interval: interval ?? this.interval,
    );
  }

  @override
  List<Object> get props => [
    id,
    userId,
    wordId,
    level,
    repetitionCount,
    wrongCount,
    stage,
    lastReviewed,
    nextReview,
    easeFactor,
    interval,
    word,
  ];
}
