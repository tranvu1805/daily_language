# Clean Architecture Rules — daily_language

> Reference for implementing any new feature from BLoC → UseCase → Repository → RemoteDataSource.
> These patterns are established in the `record` feature (the gold standard) and mirrored in `word`.

---

## 1. Layer Structure (per feature)

```
lib/features/<feature>/
├── data/
│   ├── data.dart                      ← barrel export (data_source, models, repos_impl)
│   ├── data_source/
│   │   └── <entity>_remote_data_source.dart
│   ├── models/
│   │   └── <entity>_model.dart
│   └── repositories/
│       └── <feature>_repos_impl.dart
├── domain/
│   ├── domain.dart                    ← barrel export (entities, repositories, use_cases)
│   ├── entities/
│   │   └── <entity>.dart
│   ├── repositories/
│   │   └── <feature>_repos.dart      ← abstract interface
│   └── use_cases/
│       ├── use_cases.dart             ← barrel export
│       ├── create_<entity>_use_case.dart
│       ├── get_<entity>_use_case.dart
│       ├── get_<entities>_use_case.dart
│       ├── update_<entity>_use_case.dart
│       └── delete_<entity>_use_case.dart
└── presentation/
    ├── presentation.dart              ← barrel export (bloc, pages, widgets)
    ├── bloc/
    │   ├── <entity>_bloc/             ← single item: CRUD operations
    │   │   ├── <entity>_bloc.dart
    │   │   ├── <entity>_event.dart    ← `part of` directive
    │   │   └── <entity>_state.dart    ← `part of` directive
    │   └── <entities>_bloc/           ← list: paginated + load more
    │       ├── <entities>_bloc.dart
    │       ├── <entities>_event.dart
    │       └── <entities>_state.dart
    ├── pages/
    └── widgets/
```

---

## 2. Remote Data Source

**Interface + Impl in same file.** Uses `FirebaseFirestore`.

```dart
abstract interface class XxxRemoteDataSource {
  Future<List<XxxModel>> getXxxs({required String userId, required int limit, String? lastDocId});
  Future<XxxModel> getXxx({required String userId, required String id});
  Future<void> createXxx({required String userId, required XxxModel xxx});
  Future<void> updateXxx({required String userId, required XxxModel xxx});
  Future<void> deleteXxx({required String userId, required String id});
}

class XxxRemoteDataSourceImpl implements XxxRemoteDataSource {
  final FirebaseFirestore _database;
  XxxRemoteDataSourceImpl(this._database);

  // Firestore collection path: _database.collection('xxxs').doc(userId).collection('list')
  CollectionReference<Map<String, dynamic>> _collection(String userId) =>
      _database.collection('xxxs').doc(userId).collection('list');

  // Paginated getXxxs: orderBy('createdAt', descending: true).limit(limit)
  // If lastDocId != null → startAfterDocument(lastDocSnap)
  // Models: data['id'] = doc.id before parsing

  // Error handling: throwServerException(message: 'not found', statusCode: 404)
}
```

---

## 3. Model

- Always a plain `Equatable` class with nullable fields (`String?`, `int?`, etc.)
- Has `toEntity()` method → converts to domain entity (fills nulls with defaults)
- Has `fromJson(Map<String, dynamic>)` factory or named constructor
- Has `toCreateJson()` and `toUpdateJson()` → for Firestore write (excludes `id` in create)
- Can have `fromCreateParams(XxxUseCaseParams)` and `fromUpdateParams(...)` factory constructors to map from use case params

```dart
class XxxModel extends Equatable {
  final String? id;
  // ... other nullable fields

  Xxx toEntity() => Xxx(id: id ?? '', ...);
  factory XxxModel.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toCreateJson() { ... } // no 'id', uses FieldValue.serverTimestamp() if needed
  Map<String, dynamic> toUpdateJson() { ... } // includes updatedAt: FieldValue.serverTimestamp()
  factory XxxModel.fromCreateParams(CreateXxxUseCaseParams p) { ... }
  factory XxxModel.fromUpdateParams(UpdateXxxUseCaseParams p) { ... }
}
```

---

## 4. Entity (Domain)

- `Equatable` with **non-nullable** required fields
- Has a named constructor `Xxx.empty({...})` with default values

```dart
class Xxx extends Equatable {
  final String id;
  // ... required fields (non-nullable)

  const Xxx({required this.id, ...});
  Xxx.empty({this.id = '', ...}) : createdAt = DateTime.now(), ...;

  @override
  List<Object> get props => [id, ...];
}
```

---

## 5. Repository Interface (Domain)

- `abstract interface class` — **no `class` keyword alone**
- Methods take **UseCase params directly** (not raw primitives), except `deleteXxx` can take either
- Returns `ResultFuture<T>` (= `Future<Either<Failure, T>>`) or `ResultVoid`

```dart
abstract interface class XxxRepos {
  ResultFuture<List<Xxx>> getXxxs({required GetXxxsUseCaseParams params});
  ResultFuture<Xxx>       getXxx({required GetXxxUseCaseParams params});
  ResultVoid createXxx({required CreateXxxUseCaseParams params});
  ResultVoid updateXxx({required UpdateXxxUseCaseParams params});
  ResultVoid deleteXxx({required DeleteXxxUseCaseParams params});
}
```

---

## 6. Repository Impl (Data)

- Wraps every call in `ApiService.handle(() async { ... })`
- Maps `XxxModel` → `Xxx` entity via `model.toEntity()`
- Constructs models via `XxxModel.fromCreateParams(params)` or `XxxModel.toCreate(...)`

```dart
class XxxReposImpl implements XxxRepos {
  final XxxRemoteDataSource _remoteDataSource;

  XxxReposImpl({required XxxRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  ResultFuture<List<Xxx>> getXxxs({required GetXxxsUseCaseParams params}) {
    return ApiService.handle(() async {
      final models = await _remoteDataSource.getXxxs(
        userId: params.userId,
        limit: pageSize,           // from core/constants/app.dart
        lastDocId: params.lastDocId,
      );
      return models.map((m) => m.toEntity()).toList();
    });
  }
  // ... same pattern for getXxx, createXxx, updateXxx, deleteXxx
}
```

---

## 7. Use Cases (Domain)

Each use case has:
1. A class implementing `UseCaseWithParams<ReturnType, ParamsType>`
2. A collocated `XxxUseCaseParams extends Equatable` class in the **same file**
3. Constructor: `const XxxUseCase(this._repository)` (positional, not named)
4. `call()` method simply delegates to the repository

```dart
class GetXxxsUseCase implements UseCaseWithParams<List<Xxx>, GetXxxsUseCaseParams> {
  final XxxRepos _repository;
  const GetXxxsUseCase(this._repository);

  @override
  ResultFuture<List<Xxx>> call(GetXxxsUseCaseParams params) async =>
      await _repository.getXxxs(params: params);
}

class GetXxxsUseCaseParams extends Equatable {
  final String userId;
  final int limit;               // required for list use cases
  final String? lastDocId;

  const GetXxxsUseCaseParams({required this.userId, required this.limit, this.lastDocId});

  @override
  List<Object?> get props => [userId, limit, lastDocId];
}
```

---

## 8. BLoC — Single Item (`XxxBloc`)

Handles: get single item, create, update, delete.

```dart
class XxxBloc extends Bloc<XxxEvent, XxxState> {
  final GetXxxUseCase _getXxxUseCase;
  final CreateXxxUseCase _createXxxUseCase;
  final UpdateXxxUseCase _updateXxxUseCase;
  final DeleteXxxUseCase _deleteXxxUseCase;

  XxxBloc({
    required GetXxxUseCase getXxxUseCase,
    required CreateXxxUseCase createXxxUseCase,
    required UpdateXxxUseCase updateXxxUseCase,
    required DeleteXxxUseCase deleteXxxUseCase,
  }) : _getXxxUseCase = getXxxUseCase, ... , super(XxxInitial()) {
    on<XxxRequested>(_onXxxRequested);
    on<XxxCreated>(_onCreated);
    on<XxxUpdated>(_onUpdated);
    on<XxxDeleted>(_onDeleted);
  }
  // Each handler: emit(XxxInProgress()) → call useCase → result.fold(failure, success)
}
```

### XxxEvent (sealed, `part of`)
```dart
sealed class XxxEvent extends Equatable { ... }
final class XxxRequested extends XxxEvent { final GetXxxUseCaseParams param; ... }
final class XxxCreated   extends XxxEvent { final CreateXxxUseCaseParams param; ... }
final class XxxUpdated   extends XxxEvent { final UpdateXxxUseCaseParams param; ... }
final class XxxDeleted   extends XxxEvent { final DeleteXxxUseCaseParams param; ... }
// ⚠️ XxxDeleted takes the full DeleteXxxUseCaseParams (not just String id)
```

### XxxState (sealed, `part of`)
```dart
sealed class XxxState extends Equatable { ... }
final class XxxInitial       extends XxxState {}
final class XxxInProgress    extends XxxState {}
final class XxxCreateSuccess extends XxxState {}
final class XxxUpdateSuccess extends XxxState {}
final class XxxDeleteSuccess extends XxxState {}
final class XxxSuccess extends XxxState { final Xxx xxx; ... } // holds the entity
final class XxxFailure extends XxxState { final String error; ... }
```

---

## 9. BLoC — List (`XxxsBloc`)

Handles paginated loading with **load-more** and **refresh**.

```dart
class XxxsBloc extends Bloc<XxxsEvent, XxxsState> {
  final GetXxxsUseCase _getXxxsUseCase;

  XxxsBloc({required GetXxxsUseCase getXxxsUseCase})
    : _getXxxsUseCase = getXxxsUseCase,
      super(const XxxsState()) {
    on<XxxsRequested>(_onRequested);
    on<XxxsRefreshed>(_onRefreshed);
  }

  // _onRequested: guard (hasReachedMax or loading) → emit loading → call useCase
  //   success: emit copyWith(items: [...state.items, ...newItems], lastDocId: ..., hasReachedMax: newItems.length < pageSize)
  // _onRefreshed: emit(const XxxsState()) → add(XxxsRequested(...))
}
```

### XxxsEvent
```dart
final class XxxsRequested extends XxxsEvent { final GetXxxsUseCaseParams param; ... }
final class XxxsRefreshed extends XxxsEvent { final GetXxxsUseCaseParams param; ... }
```

### XxxsState
```dart
enum XxxsStatus { initial, loading, success, failure }
enum XxxsAction { none, request, refresh }

final class XxxsState extends Equatable {
  final List<Xxx> items;        // named after the entity (e.g. userWords, records)
  final XxxsStatus status;
  final XxxsAction action;
  final bool hasReachedMax;
  final String? lastDocId;
  final String error;

  XxxsState copyWith({...}) { ... }
}
```

---

## 10. Dependency Injection (`service_locator.dart`)

Uses `get_it`. Each feature has a private `_initXxxFeature()` method called from `DI.init()`.

```dart
void _initXxxFeature() {
  // 1. Remote data source (LazySingleton)
  sl.registerLazySingleton<XxxRemoteDataSource>(
    () => XxxRemoteDataSourceImpl(sl()),  // sl() resolves FirebaseFirestore
  );
  // 2. Repository (LazySingleton)
  sl.registerLazySingleton<XxxRepos>(() => XxxReposImpl(remoteDataSource: sl()));
  // 3. Use cases (LazySingleton each)
  sl.registerLazySingleton<GetXxxUseCase>(() => GetXxxUseCase(sl()));
  sl.registerLazySingleton<GetXxxsUseCase>(() => GetXxxsUseCase(sl()));
  sl.registerLazySingleton<CreateXxxUseCase>(() => CreateXxxUseCase(sl()));
  sl.registerLazySingleton<UpdateXxxUseCase>(() => UpdateXxxUseCase(sl()));
  sl.registerLazySingleton<DeleteXxxUseCase>(() => DeleteXxxUseCase(sl()));
  // 4. BLoC (Factory — new instance per creation)
  sl.registerFactory<XxxBloc>(() => XxxBloc(
    getXxxUseCase: sl(),
    createXxxUseCase: sl(),
    updateXxxUseCase: sl(),
    deleteXxxUseCase: sl(),
  ));
  sl.registerFactory<XxxsBloc>(() => XxxsBloc(getXxxsUseCase: sl()));
}
```

> **Rule**: RemoteDataSource, Repos, UseCases → `LazySingleton`. BLoC → `Factory`.

---

## 11. BLoC Provisioning in Router

All BLoCs for a feature are provided at the **shell level** (inside `StatefulShellRoute`) via `MultiBlocProvider`. They are NOT provided at the page level.

```dart
StatefulShellRoute.indexedStack(
  builder: (context, state, shellRoutes) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => sl<XxxBloc>()),
      BlocProvider(create: (context) => sl<XxxsBloc>()),
    ],
    child: AppPage(navigationShell: shellRoutes),
  ),
  branches: [ ... ],
)
```

---

## 12. Page Usage Pattern (Paginated List)

```dart
// Load initial
context.read<XxxsBloc>().add(
  XxxsRequested(param: GetXxxsUseCaseParams(userId: _account.uid, limit: 20)),
);

// Load more (scroll-triggered)
final state = context.read<XxxsBloc>().state;
context.read<XxxsBloc>().add(
  XxxsRequested(param: GetXxxsUseCaseParams(userId: _account.uid, limit: 20, lastDocId: state.lastDocId)),
);

// Refresh (pull-to-refresh)
context.read<XxxsBloc>().add(
  XxxsRefreshed(param: GetXxxsUseCaseParams(userId: _account.uid, limit: 20)),
);
```

---

## 13. Key Utilities & Types

| Symbol | Location | Description |
|---|---|---|
| `ResultFuture<T>` | `core/utils/helper/type_definition.dart` | `Future<Either<Failure, T>>` |
| `ResultVoid` | `core/utils/helper/type_definition.dart` | `Future<Either<Failure, void>>` |
| `ApiService.handle(fn)` | `core/network/api_service.dart` | Wraps async Firestore in try/catch → Left/Right |
| `throwServerException(...)` | `core/utils/helper/method_utils.dart` | Throws a typed `ServerException` |
| `pageSize` | `core/constants/app.dart` | Pagination page size constant |
| `sl` | `core/di/service_locator.dart` | `GetIt.I` instance |
| `UseCaseWithParams<R, P>` | `core/use_case/use_case.dart` | Base interface for use cases |
| `getAccountFromState(context)` | `core/utils/...` | Helper to get current user `Account` from BLoC state in context |

---

## 14. Barrel Exports

Every layer has a barrel `dart` file:
- `data/data.dart` → exports data_source, models, repos_impl
- `domain/domain.dart` → exports entities, repositories, use_cases/use_cases.dart
- `presentation/presentation.dart` → exports bloc files, pages/pages.dart, widgets/widgets.dart
- `domain/use_cases/use_cases.dart` → exports all individual use case files
