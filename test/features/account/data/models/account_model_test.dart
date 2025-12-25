import 'package:daily_language/features/account/data/data.dart';
import 'package:daily_language/features/account/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tAccountModel = AccountModel.empty();

  test('should return a valid value when call toJson', () {
    final result = tAccountModel.toJson();
    final expectedJson = {"uid": '', "fullName": '', "email": '', "phoneNumber": '', "streak": -1};
    expect(result, expectedJson);
  });

  test('should return a valid value when call fromJson', () {
    final json = {"uid": '', "fullName": '', "email": '', "phoneNumber": '', "streak": -1};
    final result = AccountModel.fromJson(json);
    final expectedModel = const AccountModel(
      uid: '',
      fullName: '',
      email: '',
      phoneNumber: '',
      streak: -1,
    );
    expect(result, expectedModel);
  });
  test('should return a valid entity when call toEntity', () {
    final result = tAccountModel.toEntity();
    final expectedEntity = const Account(
      uid: '',
      fullName: '',
      email: '',
      phoneNumber: '',
      streak: -1,
    );
    expect(result, expectedEntity);
  });
}
