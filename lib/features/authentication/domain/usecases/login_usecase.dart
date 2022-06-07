import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/usecase/usecase.dart';
import 'package:crosscheck/features/authentication/data/models/request/login_params.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:dartz/dartz.dart';

class LoginUsecase implements Usecase<AuthenticationEntity, LoginParams> {
  final AuthenticationRepository repository;

  LoginUsecase({
    required this.repository
  });

  @override
  Future<Either<Failure, AuthenticationEntity>> call(params) async {

    if (params.username == "" || params.password == "") {
      return Left(ServerFailure(message: Failure.loginRequiredFieldError));
    }
    
    final response = await repository.login(params);

    return response.fold(
      (error) => Left(error), 
      (result) async {
        await repository.setToken(result.token);
        return Right(result);
      } 
    );
  }
  
}