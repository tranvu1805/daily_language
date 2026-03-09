import 'package:daily_language/core/use_case/use_case.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/record/domain/domain.dart';
import 'package:equatable/equatable.dart';

class UpdateRecordUseCase
    implements UseCaseWithParams<void, UpdateRecordUseCaseParams> {
  final RecordRepos _repository;

  const UpdateRecordUseCase(this._repository);

  @override
  ResultVoid call(UpdateRecordUseCaseParams params) async =>
      await _repository.updateRecord(params: params);
}

class UpdateRecordUseCaseParams extends Equatable {
  final String userId;
  final String id;
  final String emotion;
  final String type;
  final String content;
  final List<String>? imageUrls;
  final String? voiceUrl;

  const UpdateRecordUseCaseParams({
    required this.userId,
    required this.id,
    required this.emotion,
    required this.type,
    required this.content,
    this.imageUrls,
    this.voiceUrl,
  });

  const UpdateRecordUseCaseParams.empty({
    this.userId = '',
    this.id = '',
    this.emotion = '',
    this.type = '',
    this.content = '',
    this.imageUrls,
    this.voiceUrl,
  });

  @override
  List<Object?> get props => [userId, id, emotion, type, content, imageUrls, voiceUrl];
}
