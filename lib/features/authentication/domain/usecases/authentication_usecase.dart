import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/core/usecase/usecase.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:dartz/dartz.dart';

class AuthenticationUsecase implements Usecase<AuthenticationEntity, NoParam> {

  final AuthenticationRepository repository;

  const AuthenticationUsecase({required this.repository});
  
  @override
  Future<Either<Failure, AuthenticationEntity>> call(NoParam param) async {
    return await repository.getToken();
  }
  
}