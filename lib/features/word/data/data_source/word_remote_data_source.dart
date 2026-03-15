import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_language/core/utils/helper/method_utils.dart';
import 'package:daily_language/features/word/data/data.dart';

abstract interface class WordRemoteDataSource {
  Future<List<WordModel>> getWords({
    required String userId,
    required int limit,
    String? lastDocId,
  });

  Future<WordModel> getWord({required String userId, required String id});

  Future<void> createWord({
    required String userId,
    required WordModel word,
  });

  Future<void> updateWord({
    required String userId,
    required WordModel word,
  });

  Future<void> deleteWord({required String userId, required String id});
}

class WordRemoteDataSourceImpl implements WordRemoteDataSource {
  final FirebaseFirestore _database;

  WordRemoteDataSourceImpl(this._database);

  CollectionReference<Map<String, dynamic>> _wordsCollection(String userId) {
    return _database.collection('words').doc(userId).collection('words');
  }

  @override
  Future<List<WordModel>> getWords({
    required String userId,
    required int limit,
    String? lastDocId,
  }) async {
    Query<Map<String, dynamic>> query = _wordsCollection(
      userId,
    ).orderBy('createdAt', descending: true).limit(limit);

    if (lastDocId != null) {
      final lastDocSnap = await _wordsCollection(userId).doc(lastDocId).get();
      if (lastDocSnap.exists) {
        query = query.startAfterDocument(lastDocSnap);
      }
    }

    final querySnapshot = await query.get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return WordModel.fromJson(data);
    }).toList();
  }

  @override
  Future<WordModel> getWord({
    required String userId,
    required String id,
  }) async {
    final docSnap = await _wordsCollection(userId).doc(id).get();
    if (!docSnap.exists || docSnap.data() == null) {
      throwServerException(message: 'not found', statusCode: 404);
    }
    final data = docSnap.data()!;
    data['id'] = docSnap.id;
    return WordModel.fromJson(data);
  }

  @override
  Future<void> createWord({
    required String userId,
    required WordModel word,
  }) async {
    await _wordsCollection(userId).add(word.toCreateJson());
  }

  @override
  Future<void> updateWord({
    required String userId,
    required WordModel word,
  }) async {
    final docRef = _wordsCollection(userId).doc(word.id);
    final docSnap = await docRef.get();
    if (!docSnap.exists) {
      throwServerException(message: 'not found', statusCode: 404);
    }
    await docRef.update(word.toUpdateJson());
  }

  @override
  Future<void> deleteWord({
    required String userId,
    required String id,
  }) async {
    final docRef = _wordsCollection(userId).doc(id);
    final docSnap = await docRef.get();
    if (!docSnap.exists) {
      throwServerException(message: 'not found', statusCode: 404);
    }
    await docRef.delete();
  }
}
