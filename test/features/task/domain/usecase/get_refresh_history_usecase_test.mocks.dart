// Mocks generated by Mockito 5.2.0 from annotations
// in crosscheck/test/features/task/domain/usecase/get_refresh_history_usecase_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:crosscheck/core/error/failure.dart' as _i5;
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart'
    as _i9;
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart'
    as _i8;
import 'package:crosscheck/features/task/domain/entities/monthly_task_entity.dart'
    as _i7;
import 'package:crosscheck/features/task/domain/entities/task_entity.dart'
    as _i6;
import 'package:crosscheck/features/task/domain/repositories/task_respository.dart'
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

/// A class which mocks [TaskRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockTaskRepository extends _i1.Mock implements _i3.TaskRepository {
  MockTaskRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.TaskEntity>>> getHistory(
          String? token) =>
      (super.noSuchMethod(Invocation.method(#getHistory, [token]),
              returnValue:
                  Future<_i2.Either<_i5.Failure, List<_i6.TaskEntity>>>.value(
                      _FakeEither_0<_i5.Failure, List<_i6.TaskEntity>>()))
          as _i4.Future<_i2.Either<_i5.Failure, List<_i6.TaskEntity>>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.TaskEntity>>> getMoreHistory(
          String? token) =>
      (super.noSuchMethod(Invocation.method(#getMoreHistory, [token]),
              returnValue:
                  Future<_i2.Either<_i5.Failure, List<_i6.TaskEntity>>>.value(
                      _FakeEither_0<_i5.Failure, List<_i6.TaskEntity>>()))
          as _i4.Future<_i2.Either<_i5.Failure, List<_i6.TaskEntity>>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.TaskEntity>>> getRefreshHistory(
          String? token) =>
      (super.noSuchMethod(Invocation.method(#getRefreshHistory, [token]),
              returnValue:
                  Future<_i2.Either<_i5.Failure, List<_i6.TaskEntity>>>.value(
                      _FakeEither_0<_i5.Failure, List<_i6.TaskEntity>>()))
          as _i4.Future<_i2.Either<_i5.Failure, List<_i6.TaskEntity>>>);
  @override
  _i4.Future<
      _i2.Either<_i5.Failure, List<_i7.MonthlyTaskEntity>>> countDailyTaskByMonth(
          {String? token, DateTime? time}) =>
      (super.noSuchMethod(
              Invocation.method(
                  #countDailyTaskByMonth, [], {#token: token, #time: time}),
              returnValue:
                  Future<_i2.Either<_i5.Failure, List<_i7.MonthlyTaskEntity>>>.value(
                      _FakeEither_0<_i5.Failure, List<_i7.MonthlyTaskEntity>>()))
          as _i4.Future<_i2.Either<_i5.Failure, List<_i7.MonthlyTaskEntity>>>);
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
