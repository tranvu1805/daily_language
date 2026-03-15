import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:equatable/equatable.dart';

class WordModel extends Equatable {
  final String? meaning;
  final String? category;
  final String? wordText;
  final List<String>? imageUrls;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isBookmarked;
  final String? id;

  const WordModel({
    this.meaning,
    this.category,
    this.wordText,
    this.imageUrls,
    this.createdAt,
    this.updatedAt,
    this.isBookmarked,
    this.id,
  });

  const WordModel.empty({
    this.meaning = '',
    this.category = '',
    this.wordText = '',
    this.imageUrls = const <String>[],
    this.createdAt,
    this.updatedAt,
    this.isBookmarked = false,
    this.id = '',
  });

  const WordModel.toCreate({
    required this.meaning,
    required this.category,
    required this.wordText,
    this.imageUrls,
    this.createdAt,
    this.updatedAt,
    this.isBookmarked,
    this.id,
  });

  const WordModel.toUpdate({
    required this.meaning,
    required this.category,
    required this.wordText,
    this.imageUrls,
    this.createdAt,
    this.updatedAt,
    this.isBookmarked,
    required this.id,
  });

  Word toEntity() => Word(
    meaning: meaning ?? '',
    category: category ?? '',
    wordText: wordText ?? '',
    imageUrls: imageUrls ?? <String>[],
    createdAt: createdAt ?? DateTime.now(),
    updatedAt: updatedAt ?? DateTime.now(),
    isBookmarked: isBookmarked ?? false,
    id: id ?? '',
  );

  Map<String, dynamic> toCreateJson() {
    final map = <String, dynamic>{};
    map['meaning'] = meaning;
    map['category'] = category;
    map['wordText'] = wordText;
    map['imageUrls'] = imageUrls;
    map['isBookmarked'] = isBookmarked;
    map['createdAt'] = FieldValue.serverTimestamp();
    return map;
  }

  Map<String, dynamic> toUpdateJson() {
    final map = <String, dynamic>{};
    map['meaning'] = meaning;
    map['category'] = category;
    map['wordText'] = wordText;
    map['imageUrls'] = imageUrls;
    map['isBookmarked'] = isBookmarked;
    map['updatedAt'] = FieldValue.serverTimestamp();
    return map;
  }

  WordModel.fromJson(dynamic json)
    : this(
        meaning: json['meaning'] as String?,
        category: json['category'] as String?,
        wordText: json['wordText'] as String?,
        imageUrls: (json['imageUrls'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
        updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
        isBookmarked: json['isBookmarked'] as bool?,
        id: json['id'] as String?,
      );

  @override
  List<Object?> get props => [
    meaning,
    category,
    wordText,
    imageUrls,
    createdAt,
    updatedAt,
    isBookmarked,
    id,
  ];
}
