import 'package:daily_language/features/account/data/data.dart';
import 'package:daily_language/features/account/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tAccountModel = AccountModel.empty();

  test('should return a valid entity when call toEntity', () {
    final result = tAccountModel.toEntity();
    final expectedEntity = Account(
      uid: '',
      fullName: '',
      email: '',
      phoneNumber: '',
      streak: 0,
      maxStreak: 0,
      lastActivityAt: DateTime(2024, 6, 1),
      avatarUrl: '',
    );
    expect(result, expectedEntity);
  });
}
