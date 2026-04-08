import 'package:daily_language/core/errors/failures.dart';
import 'package:daily_language/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension L10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

extension FailureExtension on Failure {
  String toMessage(BuildContext context) => message.toLocalizedError(context);
}

extension LocalizedString on String {
  String toLocalizedError(BuildContext context) {
    if (isEmpty) return '';
    final l10n = context.l10n;
    return switch (this) {
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
      'cacheError' => l10n.cacheError(this),
      'unauthenticated' => l10n.unauthenticated,
      _ => l10n.unknownError(this),
    };
  }
}
