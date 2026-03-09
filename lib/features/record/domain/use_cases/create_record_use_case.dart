import 'package:daily_language/core/use_case/use_case.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/record/domain/domain.dart';
import 'package:equatable/equatable.dart';

class CreateRecordUseCase
    implements UseCaseWithParams<void, CreateRecordUseCaseParams> {
  final RecordRepos _repository;

  const CreateRecordUseCase(this._repository);

  @override
  ResultVoid call(CreateRecordUseCaseParams params) async =>
      await _repository.createRecord(params: params);
}

class CreateRecordUseCaseParams extends Equatable {
  final String userId;
  final String emotion;
  final String type;
  final String content;
  final List<String>? imageUrls;
  final String? voiceUrl;

  const CreateRecordUseCaseParams({
    required this.userId,
    required this.emotion,
    required this.type,
    required this.content,
    this.imageUrls,
    this.voiceUrl,
  });

  const CreateRecordUseCaseParams.empty({
    this.userId = '',
    this.emotion = '',
    this.type = '',
    this.content = '',
    this.imageUrls,
    this.voiceUrl,
  });

  @override
  List<Object?> get props => [userId, emotion, type, content, imageUrls, voiceUrl];
}
