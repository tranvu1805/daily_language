import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:equatable/equatable.dart';

class UserWordModel extends Equatable {
  final String? id;
  final String? userId;
  final String? wordId;
  final String? word;
  final int? repetitionCount;
  final int? wrongCount;
  final int? stage;
  final DateTime? lastReviewed;
  final DateTime? nextReview;
  final num? easeFactor;
  final num? interval;

  const UserWordModel({
    this.id,
    this.userId,
    this.wordId,
    this.repetitionCount,
    this.wrongCount,
    this.word,
    this.stage,
    this.lastReviewed,
    this.nextReview,
    this.easeFactor,
    this.interval,
  });

  UserWord toEntity() => UserWord(
    id: id ?? '',
    userId: userId ?? '',
    wordId: wordId ?? '',
    repetitionCount: repetitionCount ?? 0,
    wrongCount: wrongCount ?? 0,
    stage: stage ?? 0,
    lastReviewed: lastReviewed ?? DateTime.now(),
    nextReview: nextReview ?? DateTime.now(),
    easeFactor: easeFactor ?? 2.5,
    interval: interval ?? 1,
    word: word ?? '',
  );

  factory UserWordModel.fromJson(Map<String, dynamic> json) {
    return UserWordModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      wordId: json['wordId'] as String?,
      repetitionCount: json['repetitionCount'] as int?,
      wrongCount: json['wrongCount'] as int?,
      stage: json['stage'] as int?,
      lastReviewed: DateTime.tryParse(json['lastReviewed'].toString()),
      nextReview: DateTime.tryParse(json['nextReview'].toString()),
      easeFactor: json['easeFactor'] as num?,
      interval: json['interval'] as num?,
      word: json['word'] as String?,
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'userId': userId,
      'wordId': wordId,
      'repetitionCount': repetitionCount,
      'wrongCount': wrongCount,
      'stage': stage,
      'lastReviewed': lastReviewed?.toIso8601String(),
      'nextReview': nextReview?.toIso8601String(),
      'easeFactor': easeFactor,
      'interval': interval,
      'word': word,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'id': id,
      'userId': userId,
      'wordId': wordId,
      'repetitionCount': repetitionCount,
      'wrongCount': wrongCount,
      'stage': stage,
      'lastReviewed': lastReviewed?.toIso8601String(),
      'nextReview': nextReview?.toIso8601String(),
      'easeFactor': easeFactor,
      'interval': interval,
      'word': word,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // Factory constructors for use case params
  factory UserWordModel.fromGetParams(GetUserWordUseCaseParams params) {
    return UserWordModel(userId: params.userId, wordId: params.wordId);
  }

  factory UserWordModel.fromCreateParams(CreateUserWordUseCaseParams params) {
    return UserWordModel(
      userId: params.userId,
      wordId: params.wordId,
      word: params.word,
      repetitionCount: params.repetitionCount,
      wrongCount: params.wrongCount,
      stage: params.stage,
      lastReviewed: params.lastReviewed,
      nextReview: params.nextReview,
      easeFactor: params.easeFactor,
      interval: params.interval,
    );
  }

  factory UserWordModel.fromUpdateParams(UpdateUserWordUseCaseParams params) {
    return UserWordModel(
      id: params.id,
      userId: params.userId,
      wordId: params.wordId,
      word: params.word,
      repetitionCount: params.repetitionCount,
      wrongCount: params.wrongCount,
      stage: params.stage,
      lastReviewed: params.lastReviewed,
      nextReview: params.nextReview,
      easeFactor: params.easeFactor,
      interval: params.interval,
    );
  }

  factory UserWordModel.fromDeleteParams(DeleteUserWordUseCaseParams params) {
    return UserWordModel(userId: params.userId, wordId: params.wordId);
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    wordId,
    repetitionCount,
    wrongCount,
    stage,
    lastReviewed,
    nextReview,
    word,
    easeFactor,
    interval,
  ];
}
