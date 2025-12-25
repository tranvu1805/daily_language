import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_language/core/errors/exceptions.dart';
import 'package:daily_language/features/account/data/data.dart';

abstract interface class AccountRemoteDataSource {
  Future<List<AccountModel>> getAccounts({required String token, int page = 1});

  Future<AccountModel> getAccount({required String uid});

  Future<void> createAccount({required AccountModel account});

  Future<void> updateAccount({required AccountModel account});

  Future<void> deleteAccount({required String id});
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final FirebaseFirestore _database;

  AccountRemoteDataSourceImpl(this._database);

  @override
  Future<List<AccountModel>> getAccounts({required String token, int page = 1}) async {
    throw UnimplementedError();
    // final response = await db.get(
    //   Uri.parse('$baseUrl/account:list').replace(queryParameters: {'page': page.toString()}),
    //   headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    // );
    // throwServerException(response, 200);
    // final data = jsonDecode(response.body)['data'];
    // return data
    //     .map<AccountModel>((json) => AccountModel.fromJson(json as Map<String, dynamic>))
    //     .toList();
  }

  @override
  Future<AccountModel> getAccount({required String uid}) async {
    final ref = _database
        .collection("users")
        .doc(uid)
        .withConverter(
          fromFirestore: (snapshot, _) => AccountModel.fromJson(snapshot.data()!),
          toFirestore: (model, _) => model.toJson(),
        );
    final docSnap = await ref.get();
    if (!docSnap.exists || docSnap.data() == null) {
      throw ServerException(message: 'account not found', statusCode: 404);
    }
    return docSnap.data()!;
  }

  @override
  Future<void> createAccount({required AccountModel account}) async {
    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(account.uid)
        .withConverter(
          fromFirestore: (snapshot, _) => AccountModel.fromJson(snapshot.data()!),
          toFirestore: (model, _) => model.toJson(),
        );

    await _database.runTransaction((tx) async {
      final snapshot = await tx.get(ref);
      if (!snapshot.exists) {
        tx.set(ref, account);
      }
    });
  }

  @override
  Future<void> updateAccount({required AccountModel account}) async {
    // final response = await db.post(
    //   Uri.parse('$baseUrl/account:update').replace(queryParameters: {'filterByTk': account.uid}),
    //   headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    //   body: jsonEncode(account.toJsonForCreate()),
    // );
    // throwServerException(response, 200);
  }

  @override
  Future<void> deleteAccount({required String id}) async {
    // final response = await db.post(
    //   Uri.parse('$baseUrl/account:destroy').replace(queryParameters: {'filterByTk': id}),
    //   headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    // );
    // throwServerException(response, 200);
  }
}
