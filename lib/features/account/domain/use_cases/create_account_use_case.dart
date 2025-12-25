import 'package:daily_language/core/use_case/use_case.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/account/domain/domain.dart';
import 'package:equatable/equatable.dart';

class CreateAccountUseCase implements UseCaseWithParams<void, CreateAccountUseCaseParams> {
  final AccountRepos _repository;

  const CreateAccountUseCase(this._repository);

  @override
  ResultVoid call(CreateAccountUseCaseParams params) async =>
      await _repository.createAccount(params: params);
}

class CreateAccountUseCaseParams extends Equatable {
  final String uid;
  final String email;
  final String fullName;

  const CreateAccountUseCaseParams({
    required this.uid,
    required this.email,
    required this.fullName,
  });

  const CreateAccountUseCaseParams.empty({this.uid = '', this.email = '', this.fullName = ''});

  @override
  List<Object> get props => [uid, email, fullName];
}
