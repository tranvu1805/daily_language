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
import 'package:daily_language/features/grammar/data/data.dart';
import 'package:daily_language/features/grammar/domain/domain.dart';
import 'package:daily_language/features/grammar/presentation/presentation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daily_language/core/utils/helper/local_storage_helper.dart';
import 'package:daily_language/core/utils/helper/notification_helper.dart';

final sl = GetIt.I;

class DI {
  static final DI instance = DI._();

  DI._();

  Future<void> init() async {
    await _initCore();
    _initAuthenticationFeature();
    _initAccountFeature();
    _initRecordFeature();
    _initWordFeature();
    _initGrammarFeature();
  }

  Future<void> _initCore() async {
    final prefs = await SharedPreferences.getInstance();
    sl.registerLazySingleton<SharedPreferences>(() => prefs);
    sl.registerLazySingleton<FlutterLocalNotificationsPlugin>(
      () => FlutterLocalNotificationsPlugin(),
    );

    sl.registerLazySingleton<LocalStorageHelper>(() => LocalStorageHelper(sl()));
    sl.registerLazySingleton<NotificationHelper>(() => NotificationHelper(sl()));
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
    sl.registerLazySingleton<http.Client>(() => http.Client());
    sl.registerLazySingleton<RecordRemoteDataSource>(
      () => RecordRemoteDataSourceImpl(sl(), sl()),
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
    sl.registerLazySingleton<TranslateVietnameseToEnglishUseCase>(
      () => TranslateVietnameseToEnglishUseCase(sl()),
    );
    sl.registerFactory<RecordBloc>(
      () => RecordBloc(
        getRecordUseCase: sl(),
        createRecordUseCase: sl(),
        updateRecordUseCase: sl(),
        deleteRecordUseCase: sl(),
        translateUseCase: sl(),
      ),
    );
    sl.registerFactory<RecordsBloc>(() => RecordsBloc(getRecordsUseCase: sl()));
  }

  void _initWordFeature() {
    sl.registerLazySingleton<AssetLoader>(() => DefaultAssetLoader());
    sl.registerLazySingleton<UserWordRemoteDataSource>(
      () => UserWordRemoteDataSourceImpl(sl()),
    );
    sl.registerLazySingleton<WordLocalDataSource>(
      () => WordLocalDataSourceImpl(assetLoader: sl()),
    );
    sl.registerLazySingleton<WordRepos>(
      () => WordReposImpl(remoteDataSource: sl(), localDataSource: sl()),
    );
    sl.registerLazySingleton<GetUserWordUseCase>(
      () => GetUserWordUseCase(sl()),
    );
    sl.registerLazySingleton<GetUserWordsUseCase>(
      () => GetUserWordsUseCase(sl()),
    );
    sl.registerLazySingleton<GetDictionaryWordsUseCase>(
      () => GetDictionaryWordsUseCase(sl()),
    );
    sl.registerLazySingleton<CreateUserWordUseCase>(
      () => CreateUserWordUseCase(sl()),
    );
    sl.registerLazySingleton<UpdateUserWordUseCase>(
      () => UpdateUserWordUseCase(sl()),
    );
    sl.registerLazySingleton<DeleteUserWordUseCase>(
      () => DeleteUserWordUseCase(sl()),
    );
    sl.registerLazySingleton<GetDictionaryWordByIdUseCase>(
      () => GetDictionaryWordByIdUseCase(sl()),
    );
    sl.registerFactory<UserWordBloc>(
      () => UserWordBloc(
        getUserWordUseCase: sl(),
        createUserWordUseCase: sl(),
        updateUserWordUseCase: sl(),
        deleteUserWordUseCase: sl(),
      ),
    );
    sl.registerFactory<UserWordsBloc>(
      () => UserWordsBloc(
        getUserWordsUseCase: sl(),
        getDictionaryWordByIdUseCase: sl(),
      ),
    );
    sl.registerFactory<WordsBloc>(
      () => WordsBloc(getDictionaryWordsUseCase: sl()),
    );
    sl.registerFactory<ReviewWordBloc>(
      () => ReviewWordBloc(
        getUserWordsUseCase: sl(),
        getDictionaryWordByIdUseCase: sl(),
        updateUserWordUseCase: sl(),
      ),
    );
  }

  void _initGrammarFeature() {
    sl.registerLazySingleton<GrammarRemoteDataSource>(
      () => GrammarRemoteDataSourceImpl(sl()),
    );
    sl.registerLazySingleton<GrammarRepository>(
      () => GrammarRepositoryImpl(sl()),
    );
    sl.registerLazySingleton<CorrectGrammarUseCase>(
      () => CorrectGrammarUseCase(sl()),
    );
    sl.registerFactory<GrammarBloc>(
      () => GrammarBloc(correctGrammarUseCase: sl()),
    );
  }
}
