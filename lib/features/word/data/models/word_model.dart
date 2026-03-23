import 'package:daily_language/features/word/domain/domain.dart';
import 'package:equatable/equatable.dart';

class WordModel extends Equatable {
  final String? word;
  final String? type;
  final String? level;
  final String? pronunciation;
  final String? audioUs;
  final String? meaningEn;
  final String? example;
  final List<String>? synonym;
  final List<String>? antonym;
  final String? meaningVi;
  final String? definitionVi;
  final String? id;

  WordModel({
    this.word,
    this.type,
    this.level,
    this.pronunciation,
    this.audioUs,
    this.meaningEn,
    this.example,
    this.synonym,
    this.antonym,
    this.meaningVi,
    this.definitionVi,
  }) : id = '${word}_${type}_$level'.toLowerCase().replaceAll(' ', '_');
  Word toEntity() => Word(
    content: word ?? '',
    type: type ?? '',
    level: level ?? '',
    pronunciation: pronunciation ?? '',
    audioUs: audioUs ?? '',
    meaningEn: meaningEn ?? '',
    example: example ?? '',
    synonym: synonym ?? [],
    antonym: antonym ?? [],
    meaningVi: meaningVi ?? '',
    definitionVi: definitionVi ?? '',
    id: id ?? '',
  );
  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      word: json['word'] as String?,
      type: json['type'] as String?,
      level: json['level'] as String?,
      pronunciation: json['pronunciation'] as String?,
      audioUs: json['audio_us'] as String?,
      meaningEn: json['meaning_en'] as String?,
      example: json['example'] as String?,
      synonym: (json['synonym'] as List? ?? [])
          .map((e) => e as String)
          .toList(),
      antonym: (json['antonym'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      meaningVi: json['meaning_vi'] as String?,
      definitionVi: json['definition_vi'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'type': type,
      'level': level,
      'pronunciation': pronunciation,
      'audio_us': audioUs,
      'meaning_en': meaningEn,
      'example': example,
      'synonym': synonym,
      'antonym': antonym,
      'meaning_vi': meaningVi,
      'definition_vi': definitionVi,
    };
  }

  @override
  List<Object?> get props => [
    word,
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
