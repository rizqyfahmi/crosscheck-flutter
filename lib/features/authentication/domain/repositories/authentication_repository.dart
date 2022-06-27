import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, void>> registration({
    required String name,
    required String email,
    required String password,
    required String confirmPassword
  });
  
  Future<Either<Failure, void>> login({
    required String username,
    required String password
  });

  Future<Either<Failure, AuthenticationEntity>> getToken();
}