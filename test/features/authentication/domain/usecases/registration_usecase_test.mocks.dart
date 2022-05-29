// Mocks generated by Mockito 5.2.0 from annotations
// in crosscheck/test/features/authentication/domain/usecases/registration_usecase_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:crosscheck/core/error/failure.dart' as _i5;
import 'package:crosscheck/features/authentication/data/models/request/registration_params.dart'
    as _i7;
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart'
    as _i6;
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart'
    as _i2;
import 'package:dartz/dartz.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

/// A class which mocks [AuthenticationRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthenticationRepository extends _i1.Mock
    implements _i2.AuthenticationRepository {
  MockAuthenticationRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i4.Either<_i5.Failure, _i6.AuthenticationEntity>>? registration(
          _i7.RegistrationParams? params) =>
      (super.noSuchMethod(Invocation.method(#registration, [params]))
          as _i3.Future<_i4.Either<_i5.Failure, _i6.AuthenticationEntity>>?);
  @override
  _i3.Future<void>? setToken(String? token) => (super.noSuchMethod(
      Invocation.method(#setToken, [token]),
      returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>?);
}
