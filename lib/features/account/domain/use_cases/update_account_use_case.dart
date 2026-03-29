import 'package:daily_language/core/use_case/use_case.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/account/domain/domain.dart';
import 'package:equatable/equatable.dart';

class UpdateAccountUseCase implements UseCaseWithParams<void, UpdateAccountUseCaseParams> {
  final AccountRepos _repository;

  const UpdateAccountUseCase(this._repository);

  @override
  ResultVoid call(UpdateAccountUseCaseParams params) async =>
      await _repository.updateAccount(params: params);
}

class UpdateAccountUseCaseParams extends Equatable {
  final String uid;
  final String fullName;
  final String phoneNumber;
  final int? streak;
  final int? maxStreak;
  final DateTime? lastActivityAt;

  const UpdateAccountUseCaseParams({
    required this.uid,
    required this.fullName,
    required this.phoneNumber,
    this.streak,
    this.maxStreak,
    this.lastActivityAt,
  });

  const UpdateAccountUseCaseParams.empty({
    this.uid = '',
    this.fullName = '',
    this.phoneNumber = '',
    this.streak,
    this.maxStreak,
    this.lastActivityAt,
  });

  @override
  List<Object?> get props => [
    uid,
    fullName,
    phoneNumber,
    streak,
    maxStreak,
    lastActivityAt,
  ];
}
