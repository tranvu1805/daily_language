import 'package:equatable/equatable.dart';

class Record extends Equatable {
  final String emotion;
  final String type;
  final String englishContent;
  final String vietnameseContent;
  final List<String> imageUrls;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String voiceUrl;
  final String id;

  const Record({
    required this.emotion,
    required this.type,
    required this.englishContent,
    required this.vietnameseContent,
    required this.imageUrls,
    required this.createdAt,
    required this.voiceUrl,
    required this.id,
    required this.updatedAt,
  });

  Record.empty({
    this.emotion = '',
    this.type = '',
    this.englishContent = '',
    this.vietnameseContent = '',
    this.imageUrls = const <String>[],
    this.voiceUrl = '',
    this.id = '',
  }) : createdAt = DateTime.now(),
       updatedAt = DateTime.now();

  @override
  List<Object> get props => [
    emotion,
    type,
    englishContent,
    vietnameseContent,
    imageUrls,
    createdAt,
    updatedAt,
    voiceUrl,
    id,
  ];
}
