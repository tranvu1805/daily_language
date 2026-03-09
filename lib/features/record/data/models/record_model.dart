import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_language/features/record/domain/domain.dart';
import 'package:equatable/equatable.dart';

class RecordModel extends Equatable {
  final String? emotion;
  final String? type;
  final String? content;
  final List<String>? imageUrls;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? voiceUrl;
  final String? id;

  const RecordModel({
    this.emotion,
    this.type,
    this.content,
    this.imageUrls,
    this.createdAt,
    this.updatedAt,
    this.voiceUrl,
    this.id,
  });

  const RecordModel.empty({
    this.emotion = '',
    this.type = '',
    this.content = '',
    this.imageUrls = const <String>[],
    this.createdAt,
    this.updatedAt,
    this.voiceUrl = '',
    this.id = '',
  });

  const RecordModel.toCreate({
    required this.emotion,
    required this.type,
    required this.content,
    this.imageUrls,
    this.createdAt,
    this.updatedAt,
    this.voiceUrl,
    this.id,
  });

  const RecordModel.toUpdate({
    required this.emotion,
    required this.type,
    required this.content,
    this.imageUrls,
    this.createdAt,
    this.updatedAt,
    this.voiceUrl,
    required this.id,
  });

  Record toEntity() => Record(
    emotion: emotion ?? '',
    type: type ?? '',
    content: content ?? '',
    imageUrls: imageUrls ?? <String>[],
    createdAt: createdAt ?? DateTime.now(),
    updatedAt: updatedAt ?? DateTime.now(),
    voiceUrl: voiceUrl ?? '',
    id: id ?? '',
  );

  Map<String, dynamic> toCreateJson() {
    final map = <String, dynamic>{};
    map['emotion'] = emotion;
    map['type'] = type;
    map['content'] = content;
    map['imageUrls'] = imageUrls;
    map['voiceUrl'] = voiceUrl;
    map['createdAt'] = FieldValue.serverTimestamp();
    return map;
  }

  Map<String, dynamic> toUpdateJson() {
    final map = <String, dynamic>{};
    map['emotion'] = emotion;
    map['type'] = type;
    map['content'] = content;
    map['imageUrls'] = imageUrls;
    map['voiceUrl'] = voiceUrl;
    map['updatedAt'] = FieldValue.serverTimestamp();
    return map;
  }

  RecordModel.fromJson(dynamic json)
    : this(
        emotion: json['emotion'] as String?,
        type: json['type'] as String?,
        content: json['content'] as String?,
        imageUrls: (json['imageUrls'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
        updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
        voiceUrl: json['voiceUrl'] as String?,
        id: json['id'] as String?,
      );

  @override
  List<Object?> get props => [
    emotion,
    type,
    content,
    imageUrls,
    createdAt,
    updatedAt,
    voiceUrl,
    id,
  ];
}
