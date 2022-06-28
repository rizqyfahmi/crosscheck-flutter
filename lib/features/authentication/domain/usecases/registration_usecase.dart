import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/usecase/usecase.dart';
import 'package:crosscheck/features/authentication/data/models/request/registration_params.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:dartz/dartz.dart';

class RegistrationUsecase implements Usecase<void, RegistrationParams> {
  final AuthenticationRepository repository;

  RegistrationUsecase({
    required this.repository
  });

  @override
  Future<Either<Failure, void>> call(RegistrationParams params) async {
    
    final errors = getFieldValidation(params);
    if (errors.isNotEmpty) {
      return Left(ServerFailure(message: Failure.validationError, errors: errors));
    }

    final result = await repository.registration(
      name: params.name,
      email: params.email,
      password: params.password,
      confirmPassword: params.confirmPassword
    );

    return result.fold(
      (error) => Left(error), 
      (data) => const Right(null)
    );
  }

  List<Map<String, dynamic>> getFieldValidation(RegistrationParams params) {
    List<Map<String, dynamic>> result = [];

    if (params.name == "") {
      result.add({
        "field": "name",
        "message":  "The name field is required" 
      });
    }

    if (params.email == "") {
      result.add({
        "field": "email",
        "message":  "The email field is required" 
      });
    }

    if (params.password == "") {
      result.add({
        "field": "password",
        "message":  "The password field is required" 
      });
    }

    if (params.confirmPassword == "") {
      result.add({
        "field": "confirmPassword",
        "message":  "The confirmation password field is required" 
      });

      return result;      
    }

    if (params.password != params.confirmPassword) {
      result.add({
        "field": "confirmPassword",
        "message":  "The password and confirmation password do not match" 
      });
    }

    return result;
  }
}