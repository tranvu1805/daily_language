import 'dart:convert';

import 'package:daily_language/core/constants/app.dart';
import 'package:daily_language/core/errors/exceptions.dart';
import 'package:http/http.dart' as http;

import '../models/grammar_correction_model.dart';

abstract interface class GrammarRemoteDataSource {
  Future<GrammarCorrectionModel> correctGrammar({
    required String text,
    required String language,
  });
}

class GrammarRemoteDataSourceImpl implements GrammarRemoteDataSource {
  final http.Client _client;

  GrammarRemoteDataSourceImpl(this._client);

  @override
  Future<GrammarCorrectionModel> correctGrammar({
    required String text,
    required String language,
  }) async {
    final response = await _client.post(
      Uri.parse(urlGemini),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'text': text, 'language': language}),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return GrammarCorrectionModel.fromJson(decoded);
    } else {
      throw ServerException(
        message: 'Failed to correct grammar: ${response.reasonPhrase}',
        statusCode: response.statusCode,
      );
    }
  }
}
