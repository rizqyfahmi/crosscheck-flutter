import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/usecase/usecase.dart';
import 'package:crosscheck/features/authentication/data/models/request/login_params.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:dartz/dartz.dart';

class LoginUsecase implements Usecase<void, LoginParams> {
  final AuthenticationRepository repository;

  LoginUsecase({
    required this.repository
  });

  @override
  Future<Either<Failure, void>> call(params) async {

    if (params.username == "" || params.password == "") {
      return Left(ServerFailure(message: Failure.loginRequiredFieldError));
    }
    
    final response = await repository.login(
      username: params.username,
      password: params.password
    );

    return response.fold(
      (error) => Left(error), 
      (result) => const Right(null) 
    );
  }
  
}