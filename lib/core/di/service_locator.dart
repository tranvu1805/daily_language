import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_language/features/account/data/data.dart';
import 'package:daily_language/features/account/domain/domain.dart';
import 'package:daily_language/features/account/presentation/bloc/account_bloc/account_bloc.dart';
import 'package:daily_language/features/authentication/data/data.dart';
import 'package:daily_language/features/authentication/domain/domain.dart';
import 'package:daily_language/features/authentication/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DI {
  static final DI instance = DI._();

  DI._();

  final sl = GetIt.I;

  Future<void> init() async {
    // Authentication Feature
    sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn.instance);
    sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    sl.registerLazySingleton<AuthenticationRemoteDataSource>(
      () => AuthenticationRemoteDataSourceImpl(googleSignIn: sl(), firebaseAuth: sl()),
    );
    sl.registerLazySingleton<AuthenticationRepos>(
      () => AuthenticationReposImpl(remoteDataSource: sl()),
    );
    sl.registerLazySingleton<GetUserUseCase>(() => GetUserUseCase(sl()));
    sl.registerLazySingleton<LoginWithGoogleUseCase>(() => LoginWithGoogleUseCase(sl()));
    sl.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(sl()));
    sl.registerFactory<AuthenticationBloc>(
      () => AuthenticationBloc(
        getUserUseCase: sl(),
        logoutUseCase: sl(),
        loginWithGoogleUseCase: sl(),
      ),
    );
    //Account Feature
    sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
    sl.registerLazySingleton<AccountRemoteDataSource>(() => AccountRemoteDataSourceImpl(sl()));
    sl.registerLazySingleton<AccountRepos>(() => AccountReposImpl(remoteDataSource: sl()));
    sl.registerLazySingleton<GetAccountUseCase>(() => GetAccountUseCase(sl()));
    sl.registerLazySingleton<CreateAccountUseCase>(() => CreateAccountUseCase(sl()));
    sl.registerLazySingleton<UpdateAccountUseCase>(() => UpdateAccountUseCase(sl()));
    sl.registerLazySingleton<DeleteAccountUseCase>(() => DeleteAccountUseCase(sl()));
    sl.registerFactory<AccountBloc>(
      () => AccountBloc(
        getAccountUseCase: sl(),
        createAccountUseCase: sl(),
        updateAccountUseCase: sl(),
        deleteAccountUseCase: sl(),
      ),
    );
  }
}
