import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/usecase/usecase.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:dartz/dartz.dart';

class LoginUsecase implements Usecase {
  final AuthenticationRepository repository;

  LoginUsecase({
    required this.repository
  });

  @override
  Future<Either<Failure, dynamic>> call(params) async {
    
    final response = await repository.login(params);

    return response.fold((error) => Left(error), (result) => Right(result));
  }
  
}