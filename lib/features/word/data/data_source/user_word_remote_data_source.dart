import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_language/core/utils/helper/method_utils.dart';
import 'package:daily_language/features/word/data/models/user_word_model.dart';

abstract interface class UserWordRemoteDataSource {
  Future<List<UserWordModel>> getWords({
    required String userId,
    required int limit,
    String? lastDocId,
    bool isReview = false,
  });

  Future<UserWordModel> getWord({required String userId, required String id});

  Future<void> createWord({
    required String userId,
    required UserWordModel word,
  });

  Future<void> updateWord({
    required String userId,
    required UserWordModel word,
  });

  Future<void> deleteWord({required String userId, required String id});
}

class UserWordRemoteDataSourceImpl implements UserWordRemoteDataSource {
  final FirebaseFirestore _database;

  UserWordRemoteDataSourceImpl(this._database);

  CollectionReference<Map<String, dynamic>> _userWordListCollection(
    String userId,
  ) {
    return _database.collection('words').doc(userId).collection('words');
  }

  @override
  Future<List<UserWordModel>> getWords({
    required String userId,
    required int limit,
    String? lastDocId,
    bool isReview = false,
  }) async {
    Query<Map<String, dynamic>> query = _userWordListCollection(userId);

    if (isReview) {
      query = query
          .where('nextReview', isLessThanOrEqualTo: DateTime.now().toIso8601String())
          .orderBy('nextReview')
          .limit(limit);
    } else {
      query = query.orderBy('createdAt', descending: true).limit(limit);
    }

    if (lastDocId != null) {
      final lastDocSnap = await _userWordListCollection(
        userId,
      ).doc(lastDocId).get();
      if (lastDocSnap.exists) {
        query = query.startAfterDocument(lastDocSnap);
      }
    }

    final querySnapshot = await query.get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return UserWordModel.fromJson(data);
    }).toList();
  }

  @override
  Future<UserWordModel> getWord({
    required String userId,
    required String id,
  }) async {
    final docSnap = await _userWordListCollection(userId).doc(id).get();
    if (!docSnap.exists || docSnap.data() == null) {
      throwServerException(message: 'not found', statusCode: 404);
    }
    final data = docSnap.data()!;
    data['id'] = docSnap.id;
    return UserWordModel.fromJson(data);
  }

  @override
  Future<void> createWord({
    required String userId,
    required UserWordModel word,
  }) async {
    await _userWordListCollection(userId).add(word.toCreateJson());
  }

  @override
  Future<void> updateWord({
    required String userId,
    required UserWordModel word,
  }) async {
    final docRef = _userWordListCollection(userId).doc(word.id);
    final docSnap = await docRef.get();
    if (!docSnap.exists) {
      throwServerException(message: 'not found', statusCode: 404);
    }
    await docRef.update(word.toUpdateJson());
  }

  @override
  Future<void> deleteWord({required String userId, required String id}) async {
    final docRef = _userWordListCollection(userId).doc(id);
    final docSnap = await docRef.get();
    if (!docSnap.exists) {
      throwServerException(message: 'not found', statusCode: 404);
    }
    await docRef.delete();
  }
}
