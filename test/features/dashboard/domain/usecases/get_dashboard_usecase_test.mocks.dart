// Mocks generated by Mockito 5.2.0 from annotations
// in crosscheck/test/features/dashboard/domain/usecases/get_dashboard_usecase_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:crosscheck/core/error/failure.dart' as _i5;
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart'
    as _i9;
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart'
    as _i8;
import 'package:crosscheck/features/dashboard/data/models/params/dashboard_params.dart'
    as _i7;
import 'package:crosscheck/features/dashboard/domain/entities/dashboard_entity.dart'
    as _i6;
import 'package:crosscheck/features/dashboard/domain/repositories/dashboard_repository.dart'
    as _i3;
import 'package:dartz/dartz.dart' as _i2;
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

class _FakeEither_0<L, R> extends _i1.Fake implements _i2.Either<L, R> {}

/// A class which mocks [DashboardRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockDashboardRepository extends _i1.Mock
    implements _i3.DashboardRepository {
  MockDashboardRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.DashboardEntity>> getDashboard(
          _i7.DashboardParams? params) =>
      (super.noSuchMethod(Invocation.method(#getDashboard, [params]),
              returnValue:
                  Future<_i2.Either<_i5.Failure, _i6.DashboardEntity>>.value(
                      _FakeEither_0<_i5.Failure, _i6.DashboardEntity>()))
          as _i4.Future<_i2.Either<_i5.Failure, _i6.DashboardEntity>>);
}

/// A class which mocks [AuthenticationRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthenticationRepository extends _i1.Mock
    implements _i8.AuthenticationRepository {
  MockAuthenticationRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, void>> registration(
          {String? name,
          String? email,
          String? password,
          String? confirmPassword}) =>
      (super.noSuchMethod(
              Invocation.method(#registration, [], {
                #name: name,
                #email: email,
                #password: password,
                #confirmPassword: confirmPassword
              }),
              returnValue: Future<_i2.Either<_i5.Failure, void>>.value(
                  _FakeEither_0<_i5.Failure, void>()))
          as _i4.Future<_i2.Either<_i5.Failure, void>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, void>> login(
          {String? username, String? password}) =>
      (super.noSuchMethod(
              Invocation.method(
                  #login, [], {#username: username, #password: password}),
              returnValue: Future<_i2.Either<_i5.Failure, void>>.value(
                  _FakeEither_0<_i5.Failure, void>()))
          as _i4.Future<_i2.Either<_i5.Failure, void>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i9.AuthenticationEntity>> getToken() =>
      (super.noSuchMethod(Invocation.method(#getToken, []),
              returnValue: Future<
                      _i2.Either<_i5.Failure, _i9.AuthenticationEntity>>.value(
                  _FakeEither_0<_i5.Failure, _i9.AuthenticationEntity>()))
          as _i4.Future<_i2.Either<_i5.Failure, _i9.AuthenticationEntity>>);
}
