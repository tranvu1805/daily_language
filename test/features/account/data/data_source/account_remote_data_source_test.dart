import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_language/features/account/data/data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  late MockFirebaseFirestore database;
  late AccountRemoteDataSource dataSource;

  setUp(() {
    database = MockFirebaseFirestore();
    dataSource = AccountRemoteDataSourceImpl(database);
    registerFallbackValue(Uri());
  });

  // group('getAccounts', () {
  //   test('should call getAccounts and return list of Accounts', () async {
  //     // arrange
  //     when(
  //       () => database.get(any(), headers: any(named: 'headers')),
  //     ).thenAnswer((_) async => http.Response(jsonEncode({'data': []}), 200));
  //     // act
  //     final response = dataSource.getAccounts(page: tPage, token: tToken);
  //     // assert
  //     expect(response, completes);
  //     verify(
  //       () => database.get(
  //         Uri.parse(
  //           '$baseUrl/account:list',
  //         ).replace(queryParameters: {'appends[]': 'belong_to', 'page': tPage.toString()}),
  //         headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $tToken'},
  //       ),
  //     ).called(1);
  //     verifyNoMoreInteractions(database);
  //   });
  //
  //   test('should call getAccounts and throw exception when unsuccessfully', () async {
  //     // arrange
  //     when(() => database.get(any(), headers: any(named: 'headers'))).thenAnswer(
  //       (_) async => http.Response(
  //         jsonEncode({
  //           'error': [
  //             {'message': 'Error'},
  //           ],
  //         }),
  //         555,
  //       ),
  //     );
  //     // act
  //     final response = dataSource.getAccounts(page: tPage, token: tToken);
  //     // assert
  //     expect(response, throwsA(tException));
  //     verify(
  //       () => database.get(
  //         Uri.parse(
  //           '$baseUrl/account:list',
  //         ).replace(queryParameters: {'appends[]': 'belong_to', 'page': tPage.toString()}),
  //         headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $tToken'},
  //       ),
  //     ).called(1);
  //     verifyNoMoreInteractions(database);
  //   });
  // });

  // group('getAccount', () {
  //   test('should call getAccount and return Account', () async {
  //     // arrange
  //     when(() => database.collection('users')).thenReturn(collection);
  //     when(() => collection.doc(uid)).thenReturn(document);
  //
  //     when(
  //       () => document.withConverter<AccountModel>(
  //         fromFirestore: any(named: 'fromFirestore'),
  //         toFirestore: any(named: 'toFirestore'),
  //       ),
  //     ).thenReturn(convertedDoc);
  //
  //     when(() => convertedDoc.get()).thenAnswer((_) async => snapshot);
  //
  //     when(() => snapshot.data()).thenReturn(account);
  //
  //     // act
  //     final result = await repo.getAccount(uid: uid);
  //
  //     // assert
  //     expect(result, account);
  //
  //     verify(() => firestore.collection('users')).called(1);
  //     verify(() => collection.doc(uid)).called(1);
  //     verify(() => convertedDoc.get()).called(1);
  //     verifyNoMoreInteractions(database);
  //   });
  //
  //   test('should call getAccount and throw exception when unsuccessfully', () async {
  //     // arrange
  //     when(() => database.get(any(), headers: any(named: 'headers'))).thenAnswer(
  //       (_) async => http.Response(
  //         jsonEncode({
  //           'error': [
  //             {'message': 'Error'},
  //           ],
  //         }),
  //         555,
  //       ),
  //     );
  //     // act
  //     final response = dataSource.getAccount(uid: tUid, token: tToken);
  //     // assert
  //     expect(response, throwsA(tException));
  //     verify(
  //       () => database.get(
  //         Uri.parse('$baseUrl/account:get').replace(queryParameters: {'filterByTk': tUid}),
  //         headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $tToken'},
  //       ),
  //     ).called(1);
  //     verifyNoMoreInteractions(database);
  //   });
  // });
  //
  // group('createAccount', () {
  //   test('should call createAccount and return void when successfully', () async {
  //     // arrange
  //     when(
  //       () => database.post(
  //         any(),
  //         headers: any(named: 'headers'),
  //         body: any(named: 'body'),
  //       ),
  //     ).thenAnswer((_) async => http.Response('data', 200));
  //     // act
  //     final response = dataSource.createAccount(token: tToken, account: tAccountModel);
  //     // assert
  //     expect(response, completes);
  //     verify(
  //       () => database.post(
  //         Uri.parse('$baseUrl/account:create'),
  //         headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $tToken'},
  //         body: jsonEncode(tAccountModel.toJsonForCreate()),
  //       ),
  //     ).called(1);
  //     verifyNoMoreInteractions(database);
  //   });
  //
  //   test('should call createAccount and throw exception when unsuccessfully', () async {
  //     // arrange
  //     when(
  //       () => database.post(
  //         any(),
  //         headers: any(named: 'headers'),
  //         body: any(named: 'body'),
  //       ),
  //     ).thenAnswer(
  //       (_) async => http.Response(
  //         jsonEncode({
  //           'error': [
  //             {'message': 'Error'},
  //           ],
  //         }),
  //         555,
  //       ),
  //     );
  //     // act
  //     final response = dataSource.createAccount(token: tToken, account: tAccountModel);
  //     // assert
  //     expect(response, throwsA(tException));
  //     verify(
  //       () => database.post(
  //         Uri.parse('$baseUrl/account:create'),
  //         headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $tToken'},
  //         body: jsonEncode(tAccountModel.toJsonForCreate()),
  //       ),
  //     ).called(1);
  //     verifyNoMoreInteractions(database);
  //   });
  // });
  //
  // group('updateAccount', () {
  //   test('should call updateAccount and return void when successfully', () async {
  //     // arrange
  //     when(
  //       () => database.post(
  //         any(),
  //         headers: any(named: 'headers'),
  //         body: any(named: 'body'),
  //       ),
  //     ).thenAnswer((_) async => http.Response('data', 200));
  //     // act
  //     final response = dataSource.updateAccount(token: tToken, account: tAccountModel);
  //     // assert
  //     expect(response, completes);
  //     verify(
  //       () => database.post(
  //         Uri.parse(
  //           '$baseUrl/account:update',
  //         ).replace(queryParameters: {'filterByTk': tAccountModel.uid}),
  //         headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $tToken'},
  //         body: jsonEncode(tAccountModel.toJsonForCreate()),
  //       ),
  //     ).called(1);
  //     verifyNoMoreInteractions(database);
  //   });
  //
  //   test('should call updateAccount and throw exception when unsuccessfully', () async {
  //     // arrange
  //     when(
  //       () => database.post(
  //         any(),
  //         headers: any(named: 'headers'),
  //         body: any(named: 'body'),
  //       ),
  //     ).thenAnswer(
  //       (_) async => http.Response(
  //         jsonEncode({
  //           'error': [
  //             {'message': 'Error'},
  //           ],
  //         }),
  //         555,
  //       ),
  //     );
  //     // act
  //     final response = dataSource.updateAccount(token: tToken, account: tAccountModel);
  //     // assert
  //     expect(response, throwsA(tException));
  //     verify(
  //       () => database.post(
  //         Uri.parse(
  //           '$baseUrl/account:update',
  //         ).replace(queryParameters: {'filterByTk': tAccountModel.uid}),
  //         headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $tToken'},
  //         body: jsonEncode(tAccountModel.toJsonForCreate()),
  //       ),
  //     ).called(1);
  //     verifyNoMoreInteractions(database);
  //   });
  // });
  //
  // group('deleteAccount', () {
  //   test('should call deleteAccount and return void when successfully', () async {
  //     // arrange
  //     when(
  //       () => database.post(any(), headers: any(named: 'headers')),
  //     ).thenAnswer((_) async => http.Response('data', 200));
  //     // act
  //     final response = dataSource.deleteAccount(id: tUid, token: tToken);
  //     // assert
  //     expect(response, completes);
  //     verify(
  //       () => database.post(
  //         Uri.parse('$baseUrl/account:destroy').replace(queryParameters: {'filterByTk': tUid}),
  //         headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $tToken'},
  //       ),
  //     ).called(1);
  //     verifyNoMoreInteractions(database);
  //   });
  //
  //   test('should call deleteAccount and throw exception when unsuccessfully', () async {
  //     // arrange
  //     when(() => database.post(any(), headers: any(named: 'headers'))).thenAnswer(
  //       (_) async => http.Response(
  //         jsonEncode({
  //           'error': [
  //             {'message': 'Error'},
  //           ],
  //         }),
  //         555,
  //       ),
  //     );
  //     // act
  //     final response = dataSource.deleteAccount(id: tUid, token: tToken);
  //     // assert
  //     expect(response, throwsA(tException));
  //     verify(
  //       () => database.post(
  //         Uri.parse('$baseUrl/account:destroy').replace(queryParameters: {'filterByTk': tUid}),
  //         headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $tToken'},
  //       ),
  //     ).called(1);
  //     verifyNoMoreInteractions(database);
  //   });
  // });
}
