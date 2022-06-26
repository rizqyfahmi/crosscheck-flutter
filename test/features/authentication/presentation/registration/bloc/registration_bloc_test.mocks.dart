// Mocks generated by Mockito 5.2.0 from annotations
// in crosscheck/test/features/authentication/presentation/registration/bloc/registration_bloc_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i5;

import 'package:crosscheck/core/error/failure.dart' as _i6;
import 'package:crosscheck/features/authentication/data/models/request/registration_params.dart'
    as _i7;
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart'
    as _i2;
import 'package:crosscheck/features/authentication/domain/usecases/registration_usecase.dart'
    as _i4;
import 'package:dartz/dartz.dart' as _i3;
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

class _FakeAuthenticationRepository_0 extends _i1.Fake
    implements _i2.AuthenticationRepository {}

class _FakeEither_1<L, R> extends _i1.Fake implements _i3.Either<L, R> {}

/// A class which mocks [RegistrationUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockRegistrationUsecase extends _i1.Mock
    implements _i4.RegistrationUsecase {
  MockRegistrationUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AuthenticationRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
              returnValue: _FakeAuthenticationRepository_0())
          as _i2.AuthenticationRepository);
  @override
  _i5.Future<_i3.Either<_i6.Failure, void>> call(
          _i7.RegistrationParams? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
              returnValue: Future<_i3.Either<_i6.Failure, void>>.value(
                  _FakeEither_1<_i6.Failure, void>()))
          as _i5.Future<_i3.Either<_i6.Failure, void>>);
  @override
  List<Map<String, dynamic>> getFieldValidation(
          _i7.RegistrationParams? params) =>
      (super.noSuchMethod(Invocation.method(#getFieldValidation, [params]),
          returnValue: <Map<String, dynamic>>[]) as List<Map<String, dynamic>>);
}
