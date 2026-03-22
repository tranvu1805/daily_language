import 'package:equatable/equatable.dart';

class Word extends Equatable {
  final String content;
  final String type;
  final String level;
  final String pronunciation;
  final String audioUs;
  final String meaningEn;
  final String example;
  final List<String> synonym;
  final List<String> antonym;
  final String meaningVi;
  final String definitionVi;
  final String id;

  const Word({
    required this.content,
    required this.type,
    required this.level,
    required this.pronunciation,
    required this.audioUs,
    required this.meaningEn,
    required this.example,
    required this.synonym,
    required this.antonym,
    required this.meaningVi,
    required this.definitionVi,
    required this.id,
  });

  const Word.empty({
    this.content = '',
    this.type = '',
    this.level = '',
    this.pronunciation = '',
    this.audioUs = '',
    this.meaningEn = '',
    this.example = '',
    this.synonym = const [],
    this.antonym = const [],
    this.meaningVi = '',
    this.definitionVi = '',
    this.id = '',
  });

  @override
  List<Object?> get props => [
    content,
    type,
    level,
    pronunciation,
    audioUs,
    meaningEn,
    example,
    synonym,
    antonym,
    meaningVi,
    definitionVi,
    id,
  ];
}
