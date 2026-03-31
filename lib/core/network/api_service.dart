import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_language/core/errors/exceptions.dart';
import 'package:daily_language/core/errors/failures.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:fpdart/fpdart.dart';

class ApiService {
  static ResultFuture<T> handle<T>(Future<T> Function() action) async {
    try {
      final result = await action().timeout(const Duration(seconds: 20));
      return Right(result);
    } on FirebaseException catch (e) {
      return Left(ServerFailure.fromFirebaseException(e));
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } on TimeoutException catch (e) {
      return Left(ConnectFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 505));
    }
  }
}
