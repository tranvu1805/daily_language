import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'exceptions.dart';

abstract class Failure extends Equatable {
  final String message;
  final int statusCode;

  const Failure({required this.message, required this.statusCode});

  @override
  List<Object> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, required super.statusCode});

  factory ServerFailure.fromException(ServerException exception) {
    final message = switch (exception.message.toLowerCase()) {
      'unique violation' => 'Tài khoản đã tồn tại',
      'account not found' => 'Tài khoản không tồn tại',
      'file too large' => 'Tệp quá lớn',
      'request timed out' => 'Yêu cầu đã hết thời gian chờ',
      'the username/email or password is incorrect, please re-enter' =>
        'Số điện thoại hoặc mật khẩu không chính xác',
      'the password is incorrect, please re-enter' => 'Mật khẩu không chính xác, vui lòng nhập lại',
      _ => 'Lỗi không xác định',
    };
    return ServerFailure(message: message, statusCode: exception.statusCode);
  }

  factory ServerFailure.fromFirebaseException(FirebaseException exception) {
    final message = switch (exception.message?.toLowerCase()) {
      'unique violation' => 'Tài khoản đã tồn tại',
      'account not found' => 'Tài khoản không tồn tại',
      'file too large' => 'Tệp quá lớn',
      'request timed out' => 'Yêu cầu đã hết thời gian chờ',
      'the username/email or password is incorrect, please re-enter' =>
        'Số điện thoại hoặc mật khẩu không chính xác',
      'the password is incorrect, please re-enter' => 'Mật khẩu không chính xác, vui lòng nhập lại',
      _ => 'Lỗi không xác định',
    };
    return ServerFailure(message: message, statusCode: 500);
  }
}

class ConnectFailure extends Failure {
  const ConnectFailure({required super.message, required super.statusCode});

  factory ConnectFailure.fromException(TimeoutException exception) {
    final message = switch (exception.message?.toLowerCase()) {
      _ => 'Lỗi kết nối quá thời gian chờ',
    };
    return ConnectFailure(message: message, statusCode: 555);
  }
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, required super.statusCode});

  factory CacheFailure.fromException(Exception exception) {
    final message = switch (exception.toString().toLowerCase()) {
      _ => 'Lỗi bộ nhớ cache: ${exception.toString()}',
    };
    return CacheFailure(message: message, statusCode: 555);
  }
}
