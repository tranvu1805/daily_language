import 'package:bloc_test/bloc_test.dart';
import 'package:daily_language/core/errors/failures.dart';
import 'package:daily_language/features/authentication/domain/domain.dart';
import 'package:daily_language/features/authentication/presentation/presentation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockGetAuthenticationUseCase extends Mock implements GetUserUseCase {}

class MockLoginWithGoogleUseCase extends Mock
    implements LoginWithGoogleUseCase {}

void main() {
  late LogoutUseCase logoutUseCase;
  late GetUserUseCase getAuthenticationUseCase;
  late LoginWithGoogleUseCase loginWithGoogleUseCase;
  late AuthenticationBloc authenticationBloc;
  const tFailure = ServerFailure(message: 'error', statusCode: 555);

  setUp(() {
    loginWithGoogleUseCase = MockLoginWithGoogleUseCase();
    logoutUseCase = MockLogoutUseCase();
    getAuthenticationUseCase = MockGetAuthenticationUseCase();
    authenticationBloc = AuthenticationBloc(
      loginWithGoogleUseCase: loginWithGoogleUseCase,
      logoutUseCase: logoutUseCase,
      getUserUseCase: getAuthenticationUseCase,
    );
  });

  group('AuthenticationRequested', () {
    blocTest(
      'should emit AuthenticationSuccess when successfully',
      build: () => authenticationBloc,
      setUp: () {
        when(
          () => getAuthenticationUseCase(),
        ).thenAnswer((_) => Stream.value(const User.empty()));
      },
      act: (bloc) => bloc.add(AuthenticationRequested()),
      expect: () => [
        AuthenticationInProgress(),
        const AuthenticationSuccess(user: User.empty()),
      ],
    );

    blocTest(
      'should emit AuthenticationFailure when unsuccessfully',
      build: () => authenticationBloc,
      setUp: () {
        when(
          () => getAuthenticationUseCase(),
        ).thenAnswer((_) => Stream.value(null));
      },
      act: (bloc) => bloc.add(AuthenticationRequested()),
      expect: () => [
        AuthenticationInProgress(),
        const AuthenticationFailure(error: 'Unauthenticated'),
      ],
    );
  });
  group('AuthenticationGoogleLoggedIn', () {
    blocTest(
      'should emit AuthenticationSuccess when successfully',
      build: () => authenticationBloc,
      setUp: () {
        when(
          () => getAuthenticationUseCase(),
        ).thenAnswer((_) => Stream.value(const User.empty()));
        when(
          () => loginWithGoogleUseCase(),
        ).thenAnswer((_) async => const Right(null));
      },
      act: (bloc) => bloc.add(AuthenticationGoogleLoggedIn()),
      expect: () => [
        AuthenticationInProgress(),
        const AuthenticationSuccess(user: User.empty()),
      ],
    );

    blocTest(
      'should emit AuthenticationFailure when unsuccessfully',
      build: () => authenticationBloc,
      setUp: () {
        when(
          () => getAuthenticationUseCase(),
        ).thenAnswer((_) => Stream.value(null));
        when(
          () => loginWithGoogleUseCase(),
        ).thenAnswer((_) async => const Left(tFailure));
      },
      act: (bloc) => bloc.add(AuthenticationGoogleLoggedIn()),
      expect: () => [
        AuthenticationInProgress(),
        AuthenticationFailure(error: tFailure.message),
      ],
    );
  });
  group('AuthenticationLoggedOut', () {
    blocTest(
      'should emit AuthenticationSuccess when successfully',
      build: () => authenticationBloc,
      setUp: () {
        when(() => logoutUseCase()).thenAnswer((_) async => const Right(null));
      },
      act: (bloc) => bloc.add(AuthenticationLoggedOut()),
      expect: () => [
        AuthenticationInProgress(),
        const AuthenticationFailure(error: 'Unauthenticated'),
      ],
    );

    blocTest(
      'should emit AuthenticationFailure when unsuccessfully',
      build: () => authenticationBloc,
      setUp: () {
        when(
          () => logoutUseCase(),
        ).thenAnswer((_) async => const Left(tFailure));
      },
      act: (bloc) => bloc.add(AuthenticationLoggedOut()),
      expect: () => [
        AuthenticationInProgress(),
        AuthenticationFailure(error: tFailure.message),
      ],
    );
  });
}
