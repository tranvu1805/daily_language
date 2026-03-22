import 'dart:convert';

import 'package:daily_language/features/word/data/data.dart';
import 'package:flutter/services.dart';

abstract interface class WordLocalDataSource {
  Future<List<WordModel>> getWordsFromAssets({
    required String level,
    required int limit,
    String? lastId,
  });

  Future<WordModel?> getWordFromAssets({
    required String level,
    required String id,
  });

  Future<WordModel?> getWordByIdFromAllAssets({
    required String id,
  });
}

abstract class AssetLoader {
  Future<String> loadString(String assetPath);
}

class DefaultAssetLoader implements AssetLoader {
  @override
  Future<String> loadString(String assetPath) {
    return rootBundle.loadString(assetPath);
  }
}

class WordLocalDataSourceImpl implements WordLocalDataSource {
  final AssetLoader _assetLoader;

  WordLocalDataSourceImpl({required AssetLoader assetLoader})
    : _assetLoader = assetLoader;

  @override
  Future<List<WordModel>> getWordsFromAssets({
    required String level,
    required int limit,
    String? lastId,
  }) async {
    final assetPath = 'assets/data/oxford3000_${level.toLowerCase()}.json';
    final jsonStr = await _assetLoader.loadString(assetPath);
    final List<dynamic> jsonList = jsonDecode(jsonStr);
    int startIndex = 0;
    if (lastId != null) {
      startIndex = jsonList.indexWhere((item) => item['word'] == lastId) + 1;
      if (startIndex < 0) startIndex = 0;
    }
    final selected = jsonList.skip(startIndex).take(limit).toList();
    return selected.map((item) => WordModel.fromJson(item)).toList();
  }

  @override
  Future<WordModel?> getWordFromAssets({
    required String level,
    required String id,
  }) async {
    final assetPath = 'assets/data/oxford3000_${level.toLowerCase()}.json';
    final jsonStr = await _assetLoader.loadString(assetPath);
    final List<dynamic> jsonList = jsonDecode(jsonStr);
    final item = jsonList.firstWhere(
      (item) => item['word'] == id,
      orElse: () => null,
    );
    if (item == null) return null;
    return WordModel.fromJson(item);
  }

  @override
  Future<WordModel?> getWordByIdFromAllAssets({
    required String id,
  }) async {
    final levels = ['a1', 'a2', 'b1', 'b2', 'c1'];
    for (final level in levels) {
      final assetPath = 'assets/data/oxford3000_$level.json';
      try {
        final jsonStr = await _assetLoader.loadString(assetPath);
        final List<dynamic> jsonList = jsonDecode(jsonStr);
        final item = jsonList.firstWhere(
          (item) => item['word'] == id,
          orElse: () => null,
        );
        if (item != null) return WordModel.fromJson(item);
      } catch (e) {
        // file not found or decode error, ignore and continue
      }
    }
    return null;
  }
}
