import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_language/features/account/data/data.dart';
import 'package:daily_language/features/account/domain/domain.dart';
import 'package:daily_language/features/account/presentation/bloc/account_bloc/account_bloc.dart';
import 'package:daily_language/features/authentication/data/data.dart';
import 'package:daily_language/features/authentication/domain/domain.dart';
import 'package:daily_language/features/authentication/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:daily_language/features/record/data/data.dart';
import 'package:daily_language/features/record/domain/domain.dart';
import 'package:daily_language/features/record/presentation/presentation.dart';
import 'package:daily_language/features/word/data/data.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:daily_language/features/word/presentation/presentation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

final sl = GetIt.I;

class DI {
  static final DI instance = DI._();

  DI._();

  Future<void> init() async {
    _initAuthenticationFeature();
    _initAccountFeature();
    _initRecordFeature();
    _initWordFeature();
  }

  void _initAuthenticationFeature() {
    sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn.instance);
    sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    sl.registerLazySingleton<AuthenticationRemoteDataSource>(
      () => AuthenticationRemoteDataSourceImpl(
        googleSignIn: sl(),
        firebaseAuth: sl(),
      ),
    );
    sl.registerLazySingleton<AuthenticationRepos>(
      () => AuthenticationReposImpl(remoteDataSource: sl()),
    );
    sl.registerLazySingleton<GetUserUseCase>(() => GetUserUseCase(sl()));
    sl.registerLazySingleton<LoginWithGoogleUseCase>(
      () => LoginWithGoogleUseCase(sl()),
    );
    sl.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(sl()));
    sl.registerFactory<AuthenticationBloc>(
      () => AuthenticationBloc(
        getUserUseCase: sl(),
        logoutUseCase: sl(),
        loginWithGoogleUseCase: sl(),
      ),
    );
  }

  void _initAccountFeature() {
    sl.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );
    sl.registerLazySingleton<AccountRemoteDataSource>(
      () => AccountRemoteDataSourceImpl(sl()),
    );
    sl.registerLazySingleton<AccountRepos>(
      () => AccountReposImpl(remoteDataSource: sl()),
    );
    sl.registerLazySingleton<GetAccountUseCase>(() => GetAccountUseCase(sl()));
    sl.registerLazySingleton<CreateAccountUseCase>(
      () => CreateAccountUseCase(sl()),
    );
    sl.registerLazySingleton<UpdateAccountUseCase>(
      () => UpdateAccountUseCase(sl()),
    );
    sl.registerLazySingleton<DeleteAccountUseCase>(
      () => DeleteAccountUseCase(sl()),
    );
    sl.registerFactory<AccountBloc>(
      () => AccountBloc(
        getAccountUseCase: sl(),
        createAccountUseCase: sl(),
        updateAccountUseCase: sl(),
        deleteAccountUseCase: sl(),
      ),
    );
  }

  void _initRecordFeature() {
    sl.registerLazySingleton<RecordRemoteDataSource>(
      () => RecordRemoteDataSourceImpl(sl()),
    );
    sl.registerLazySingleton<RecordRepos>(
      () => RecordReposImpl(remoteDataSource: sl()),
    );
    sl.registerLazySingleton<GetRecordUseCase>(() => GetRecordUseCase(sl()));
    sl.registerLazySingleton<GetRecordsUseCase>(() => GetRecordsUseCase(sl()));
    sl.registerLazySingleton<CreateRecordUseCase>(
      () => CreateRecordUseCase(sl()),
    );
    sl.registerLazySingleton<UpdateRecordUseCase>(
      () => UpdateRecordUseCase(sl()),
    );
    sl.registerLazySingleton<DeleteRecordUseCase>(
      () => DeleteRecordUseCase(sl()),
    );
    sl.registerFactory<RecordBloc>(
      () => RecordBloc(
        getRecordUseCase: sl(),
        createRecordUseCase: sl(),
        updateRecordUseCase: sl(),
        deleteRecordUseCase: sl(),
      ),
    );
    sl.registerFactory<RecordsBloc>(() => RecordsBloc(getRecordsUseCase: sl()));
  }

  void _initWordFeature() {
    sl.registerLazySingleton<WordRemoteDataSource>(
      () => WordRemoteDataSourceImpl(sl()),
    );
    sl.registerLazySingleton<WordRepos>(
      () => WordReposImpl(remoteDataSource: sl()),
    );
    sl.registerLazySingleton<GetWordUseCase>(() => GetWordUseCase(sl()));
    sl.registerLazySingleton<GetWordsUseCase>(() => GetWordsUseCase(sl()));
    sl.registerLazySingleton<CreateWordUseCase>(
      () => CreateWordUseCase(sl()),
    );
    sl.registerLazySingleton<UpdateWordUseCase>(
      () => UpdateWordUseCase(sl()),
    );
    sl.registerLazySingleton<DeleteWordUseCase>(
      () => DeleteWordUseCase(sl()),
    );
    sl.registerFactory<WordBloc>(
      () => WordBloc(
        getWordUseCase: sl(),
        createWordUseCase: sl(),
        updateWordUseCase: sl(),
        deleteWordUseCase: sl(),
      ),
    );
    sl.registerFactory<WordsBloc>(() => WordsBloc(getWordsUseCase: sl()));
  }
}
