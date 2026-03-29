import 'package:daily_language/core/network/api_service.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';

import '../../domain/entities/grammar_correction.dart';
import '../../domain/repositories/grammar_repository.dart';
import '../data_sources/grammar_remote_data_source.dart';

class GrammarRepositoryImpl implements GrammarRepository {
  final GrammarRemoteDataSource _remoteDataSource;

  GrammarRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<GrammarCorrection> correctGrammar(String text) {
    return ApiService.handle(() async {
      final correctionModel = await _remoteDataSource.correctGrammar(text);
      return correctionModel.toEntity();
    });
  }
}
