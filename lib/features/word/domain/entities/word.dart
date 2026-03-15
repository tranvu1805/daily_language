import 'package:equatable/equatable.dart';

class Word extends Equatable {
  final String meaning;
  final String category;
  final String wordText;
  final List<String> imageUrls;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isBookmarked;
  final String id;

  const Word({
    required this.meaning,
    required this.category,
    required this.wordText,
    required this.imageUrls,
    required this.createdAt,
    required this.isBookmarked,
    required this.id,
    required this.updatedAt,
  });

  Word.empty({
    this.meaning = '',
    this.category = '',
    this.wordText = '',
    this.imageUrls = const <String>[],
    this.isBookmarked = false,
    this.id = '',
  }) : createdAt = DateTime.now(),
       updatedAt = DateTime.now();

  @override
  List<Object> get props => [
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
