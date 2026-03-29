import 'package:daily_language/core/errors/exceptions.dart';
import 'package:daily_language/features/account/presentation/presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void throwServerException({required String message, int statusCode = 500}) {
  throw ServerException(message: message, statusCode: statusCode);
}

Account getAccountFromState(BuildContext context) {
  final state = context.read<AccountBloc>().state;
  if (state is AccountSuccess) {
    return state.account;
  }
  throw const ServerException(
    message: 'User not authenticated',
    statusCode: 401,
  );
}
