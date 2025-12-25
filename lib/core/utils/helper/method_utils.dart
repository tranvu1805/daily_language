import 'dart:convert';

import 'package:daily_language/core/errors/exceptions.dart';
import 'package:daily_language/features/authentication/domain/domain.dart';
import 'package:daily_language/features/authentication/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

void throwServerException(http.Response response, int statusCode) {
  if (response.statusCode != statusCode) {
    final body = jsonDecode(response.body);
    final message = body['errors']?[0]['message'] ?? 'Unknown error';
    throw ServerException(message: message, statusCode: response.statusCode);
  }
}

User getUserFromState(BuildContext context) {
  final state = context.read<AuthenticationBloc>().state;
  if (state is AuthenticationSuccess) {
    return state.user;
  }
  throw Exception('User not authenticated');
}
