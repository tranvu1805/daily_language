import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_language/core/utils/helper/method_utils.dart';
import 'package:daily_language/features/record/data/data.dart';

abstract interface class RecordRemoteDataSource {
  Future<List<RecordModel>> getRecords({
    required String userId,
    required int limit,
    String? lastDocId,
  });

  Future<RecordModel> getRecord({required String userId, required String id});

  Future<void> createRecord({
    required String userId,
    required RecordModel record,
  });

  Future<void> updateRecord({
    required String userId,
    required RecordModel record,
  });

  Future<void> deleteRecord({required String userId, required String id});
}

class RecordRemoteDataSourceImpl implements RecordRemoteDataSource {
  final FirebaseFirestore _database;

  RecordRemoteDataSourceImpl(this._database);

  CollectionReference<Map<String, dynamic>> _recordsCollection(String userId) {
    return _database.collection('records').doc(userId).collection('records');
  }

  @override
  Future<List<RecordModel>> getRecords({
    required String userId,
    required int limit,
    String? lastDocId,
  }) async {
    Query<Map<String, dynamic>> query = _recordsCollection(
      userId,
    ).orderBy('createdAt', descending: true).limit(limit);

    if (lastDocId != null) {
      final lastDocSnap = await _recordsCollection(userId).doc(lastDocId).get();
      if (lastDocSnap.exists) {
        query = query.startAfterDocument(lastDocSnap);
      }
    }

    final querySnapshot = await query.get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return RecordModel.fromJson(data);
    }).toList();
  }

  @override
  Future<RecordModel> getRecord({
    required String userId,
    required String id,
  }) async {
    final docSnap = await _recordsCollection(userId).doc(id).get();
    if (!docSnap.exists || docSnap.data() == null) {
      throwServerException(message: 'not found', statusCode: 404);
    }
    final data = docSnap.data()!;
    data['id'] = docSnap.id;
    return RecordModel.fromJson(data);
  }

  @override
  Future<void> createRecord({
    required String userId,
    required RecordModel record,
  }) async {
    await _recordsCollection(userId).add(record.toCreateJson());
  }

  @override
  Future<void> updateRecord({
    required String userId,
    required RecordModel record,
  }) async {
    final docRef = _recordsCollection(userId).doc(record.id);
    final docSnap = await docRef.get();
    if (!docSnap.exists) {
      throwServerException(message: 'not found', statusCode: 404);
    }
    await docRef.update(record.toUpdateJson());
  }

  @override
  Future<void> deleteRecord({
    required String userId,
    required String id,
  }) async {
    final docRef = _recordsCollection(userId).doc(id);
    final docSnap = await docRef.get();
    if (!docSnap.exists) {
      throwServerException(message: 'not found', statusCode: 404);
    }
    await docRef.delete();
  }
}
