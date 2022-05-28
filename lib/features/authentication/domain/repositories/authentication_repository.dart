import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/authentication/data/models/request/registration_params.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, AuthenticationEntity>> registration(RegistrationParams params);
}