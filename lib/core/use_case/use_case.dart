import 'package:daily_language/core/utils/helper/type_definition.dart';

abstract interface class UseCase<T> {
  ResultFuture<T> call();
}

abstract interface class UseCaseWithParams<T, Params> {
  ResultFuture<T> call(Params params);
}
