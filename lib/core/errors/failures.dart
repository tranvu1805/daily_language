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
      'not found' => 'Dữ liệu không tồn tại',
      'google sign-in failed' => 'Đăng nhập Google thất bại',
      'word already exists in your collection' => 'Từ này đã có trong bộ sưu tập của bạn',
      _ => 'Lỗi không xác định: ${exception.message}',
    };
    return ServerFailure(message: message, statusCode: exception.statusCode);
  }

  factory ServerFailure.fromFirebaseException(FirebaseException exception) {
    final message = switch (exception.code) {
      // Firestore errors
      'permission-denied' => 'Bạn không có quyền thực hiện thao tác này',
      'not-found' => 'Không tìm thấy dữ liệu',
      'already-exists' => 'Dữ liệu đã tồn tại',
      'resource-exhausted' => 'Đã vượt quá giới hạn, vui lòng thử lại sau',
      'failed-precondition' => 'Thao tác không hợp lệ',
      'aborted' => 'Thao tác bị hủy, vui lòng thử lại',
      'out-of-range' => 'Giá trị nằm ngoài phạm vi cho phép',
      'unavailable' => 'Dịch vụ tạm thời không khả dụng, vui lòng thử lại sau',
      'data-loss' => 'Dữ liệu bị mất hoặc hỏng',
      'deadline-exceeded' => 'Yêu cầu đã hết thời gian chờ',
      'cancelled' => 'Yêu cầu đã bị hủy',
      // Firebase Auth errors
      'user-not-found' => 'Tài khoản không tồn tại',
      'wrong-password' => 'Mật khẩu không chính xác',
      'email-already-in-use' => 'Email đã được sử dụng',
      'invalid-email' => 'Email không hợp lệ',
      'weak-password' => 'Mật khẩu quá yếu',
      'user-disabled' => 'Tài khoản đã bị vô hiệu hóa',
      'too-many-requests' => 'Quá nhiều yêu cầu, vui lòng thử lại sau',
      'operation-not-allowed' => 'Thao tác không được phép',
      'account-exists-with-different-credential' =>
        'Tài khoản đã tồn tại với phương thức đăng nhập khác',
      'invalid-credential' => 'Thông tin xác thực không hợp lệ',
      'network-request-failed' => 'Lỗi kết nối mạng, vui lòng kiểm tra lại',
      _ => 'Lỗi không xác định: ${exception.message}',
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
