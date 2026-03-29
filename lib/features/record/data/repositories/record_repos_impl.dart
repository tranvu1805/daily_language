import 'package:daily_language/core/constants/app.dart';
import 'package:daily_language/core/network/api_service.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/record/data/data.dart';
import 'package:daily_language/features/record/domain/domain.dart';

class RecordReposImpl implements RecordRepos {
  final RecordRemoteDataSource _remoteDataSource;

  RecordReposImpl({required RecordRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  ResultFuture<List<Record>> getRecords({
    required GetRecordsUseCaseParams params,
  }) {
    return ApiService.handle(() async {
      final models = await _remoteDataSource.getRecords(
        userId: params.userId,
        limit: pageSize,
        lastDocId: params.lastDocId,
      );
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  ResultFuture<Record> getRecord({required GetRecordUseCaseParams params}) {
    return ApiService.handle(() async {
      final model = await _remoteDataSource.getRecord(
        userId: params.userId,
        id: params.id,
      );
      return model.toEntity();
    });
  }

  @override
  ResultVoid createRecord({required CreateRecordUseCaseParams params}) {
    return ApiService.handle(() async {
      final recordModel = RecordModel.toCreate(
        emotion: params.emotion,
        type: params.type,
        englishContent: params.englishContent,
        vietnameseContent: params.vietnameseContent,
        imageUrls: params.imageUrls,
        voiceUrl: params.voiceUrl,
      );
      await _remoteDataSource.createRecord(
        userId: params.userId,
        record: recordModel,
      );
    });
  }

  @override
  ResultVoid updateRecord({required UpdateRecordUseCaseParams params}) {
    return ApiService.handle(() async {
      final recordModel = RecordModel.toUpdate(
        id: params.id,
        emotion: params.emotion,
        type: params.type,
        englishContent: params.englishContent,
        vietnameseContent: params.vietnameseContent,
        imageUrls: params.imageUrls,
        voiceUrl: params.voiceUrl,
      );
      await _remoteDataSource.updateRecord(
        userId: params.userId,
        record: recordModel,
      );
    });
  }

  @override
  ResultVoid deleteRecord({required String id}) {
    throw UnimplementedError();
  }

  @override
  ResultFuture<String> translateVietnameseToEnglish({
    required TranslateVietnameseToEnglishUseCaseParams params,
  }) {
    return ApiService.handle(() async {
      return _remoteDataSource.translateVietnameseToEnglish(
        content: params.content,
      );
    });
  }
}
