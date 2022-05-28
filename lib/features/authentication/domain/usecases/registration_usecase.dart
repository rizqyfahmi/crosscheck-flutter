import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/usecase/usecase.dart';
import 'package:crosscheck/features/authentication/data/models/request/registration_params.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:dartz/dartz.dart';

class RegistrationUsecase implements Usecase<AuthenticationEntity, RegistrationParams>{
  @override
  Future<Either<Failure, AuthenticationEntity>>? call(RegistrationParams param) {
    return null;
  }
  
}