import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_language/l10n/app_localizations.dart';
import 'package:equatable/equatable.dart';

import 'exceptions.dart';

abstract class Failure extends Equatable {
  final String message;
  final int statusCode;

  const Failure({required this.message, required this.statusCode});

  String toMessage(AppLocalizations l10n) {
    return switch (message) {
      'dataNotFound' => l10n.dataNotFound,
      'googleSignInFailed' => l10n.googleSignInFailed,
      'wordAlreadyExists' => l10n.wordAlreadyExists,
      'permissionDenied' => l10n.permissionDenied,
      'alreadyExists' => l10n.alreadyExists,
      'resourceExhausted' => l10n.resourceExhausted,
      'failedPrecondition' => l10n.failedPrecondition,
      'aborted' => l10n.aborted,
      'outOfRange' => l10n.outOfRange,
      'unavailable' => l10n.unavailable,
      'dataLoss' => l10n.dataLoss,
      'deadlineExceeded' => l10n.deadlineExceeded,
      'cancelled' => l10n.cancelled,
      'userNotFound' => l10n.userNotFound,
      'wrongPassword' => l10n.wrongPassword,
      'emailAlreadyInUse' => l10n.emailAlreadyInUse,
      'weakPassword' => l10n.weakPassword,
      'userDisabled' => l10n.userDisabled,
      'tooManyRequests' => l10n.tooManyRequests,
      'operationNotAllowed' => l10n.operationNotAllowed,
      'accountExistsWithDifferentCredential' =>
        l10n.accountExistsWithDifferentCredential,
      'invalidCredential' => l10n.invalidCredential,
      'networkRequestFailed' => l10n.networkRequestFailed,
      'connectionTimeout' => l10n.connectionTimeout,
      'cacheError' => l10n.cacheError(message),
      'unauthenticated' => l10n.unauthenticated,
      _ =>
        message.isEmpty
            ? l10n.unknownError('Unknown')
            : l10n.unknownError(message),
    };
  }

  @override
  List<Object> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, required super.statusCode});

  factory ServerFailure.fromException(ServerException exception) {
    final message = switch (exception.message.toLowerCase()) {
      'not found' => 'dataNotFound',
      'google sign-in failed' => 'googleSignInFailed',
      'word already exists in your collection' => 'wordAlreadyExists',
      'user not authenticated' => 'unauthenticated',
      'unauthenticated' => 'unauthenticated',
      _ => exception.message,
    };
    return ServerFailure(message: message, statusCode: exception.statusCode);
  }

  factory ServerFailure.fromFirebaseException(FirebaseException exception) {
    final message = switch (exception.code) {
      'permission-denied' => 'permissionDenied',
      'not-found' => 'dataNotFound',
      'already-exists' => 'alreadyExists',
      'resource-exhausted' => 'resourceExhausted',
      'failed-precondition' => 'failedPrecondition',
      'aborted' => 'aborted',
      'out-of-range' => 'outOfRange',
      'unavailable' => 'unavailable',
      'data-loss' => 'dataLoss',
      'deadline-exceeded' => 'deadlineExceeded',
      'cancelled' => 'cancelled',
      'user-not-found' => 'userNotFound',
      'wrong-password' => 'wrongPassword',
      'email-already-in-use' => 'emailAlreadyInUse',
      'invalid-email' => 'invalidEmail',
      'weak-password' => 'weakPassword',
      'user-disabled' => 'userDisabled',
      'too-many-requests' => 'tooManyRequests',
      'operation-not-allowed' => 'operationNotAllowed',
      'account-exists-with-different-credential' =>
        'accountExistsWithDifferentCredential',
      'invalid-credential' => 'invalidCredential',
      'network-request-failed' => 'networkRequestFailed',
      _ => exception.message ?? 'unknownError',
    };
    return ServerFailure(message: message, statusCode: 500);
  }
}

class ConnectFailure extends Failure {
  const ConnectFailure({required super.message, required super.statusCode});

  factory ConnectFailure.fromException(TimeoutException exception) {
    return const ConnectFailure(message: 'connectionTimeout', statusCode: 555);
  }
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, required super.statusCode});

  factory CacheFailure.fromException(Exception exception) {
    return const CacheFailure(message: 'cacheError', statusCode: 555);
  }
}
