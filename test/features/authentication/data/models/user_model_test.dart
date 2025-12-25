import 'package:daily_language/features/authentication/data/data.dart';
import 'package:daily_language/features/authentication/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tUserModel = UserModel.empty();

  test('should return a valid entity when call toEntity', () {
    final result = tUserModel.toEntity();
    final expectedEntity = const User(id: '', username: '', email: '', avatarUrl: '');
    expect(result, expectedEntity);
  });
}
