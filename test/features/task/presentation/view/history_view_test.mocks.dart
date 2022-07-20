// Mocks generated by Mockito 5.2.0 from annotations
// in crosscheck/test/features/task/presentation/view/history_view_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i7;

import 'package:crosscheck/core/error/failure.dart' as _i5;
import 'package:crosscheck/core/param/param.dart' as _i9;
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart'
    as _i3;
import 'package:crosscheck/features/task/domain/entities/combine_task_entity.dart'
    as _i13;
import 'package:crosscheck/features/task/domain/entities/monthly_task_entity.dart'
    as _i14;
import 'package:crosscheck/features/task/domain/entities/task_entity.dart'
    as _i8;
import 'package:crosscheck/features/task/domain/repositories/task_respository.dart'
    as _i2;
import 'package:crosscheck/features/task/domain/usecases/get_history_usecase.dart'
    as _i6;
import 'package:crosscheck/features/task/domain/usecases/get_initial_task_by_date_usecase.dart'
    as _i12;
import 'package:crosscheck/features/task/domain/usecases/get_monthly_task_usecase.dart'
    as _i15;
import 'package:crosscheck/features/task/domain/usecases/get_more_history_usecase.dart'
    as _i10;
import 'package:crosscheck/features/task/domain/usecases/get_refresh_history_usecase.dart'
    as _i11;
import 'package:crosscheck/features/task/domain/usecases/get_task_by_date_usecase.dart'
    as _i16;
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

class _FakeTaskRepository_0 extends _i1.Fake implements _i2.TaskRepository {}

class _FakeAuthenticationRepository_1 extends _i1.Fake
    implements _i3.AuthenticationRepository {}

class _FakeEither_2<L, R> extends _i1.Fake implements _i4.Either<L, R> {}

class _FakeFailure_3 extends _i1.Fake implements _i5.Failure {}

/// A class which mocks [GetHistoryUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetHistoryUsecase extends _i1.Mock implements _i6.GetHistoryUsecase {
  MockGetHistoryUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.TaskRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeTaskRepository_0()) as _i2.TaskRepository);
  @override
  _i3.AuthenticationRepository get authenticationRepository =>
      (super.noSuchMethod(Invocation.getter(#authenticationRepository),
              returnValue: _FakeAuthenticationRepository_1())
          as _i3.AuthenticationRepository);
  @override
  _i7.Future<_i4.Either<_i5.Failure, List<_i8.TaskEntity>>> call(
          _i9.NoParam? param) =>
      (super.noSuchMethod(Invocation.method(#call, [param]),
              returnValue:
                  Future<_i4.Either<_i5.Failure, List<_i8.TaskEntity>>>.value(
                      _FakeEither_2<_i5.Failure, List<_i8.TaskEntity>>()))
          as _i7.Future<_i4.Either<_i5.Failure, List<_i8.TaskEntity>>>);
}

/// A class which mocks [GetMoreHistoryUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetMoreHistoryUsecase extends _i1.Mock
    implements _i10.GetMoreHistoryUsecase {
  MockGetMoreHistoryUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.TaskRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeTaskRepository_0()) as _i2.TaskRepository);
  @override
  _i3.AuthenticationRepository get authenticationRepository =>
      (super.noSuchMethod(Invocation.getter(#authenticationRepository),
              returnValue: _FakeAuthenticationRepository_1())
          as _i3.AuthenticationRepository);
  @override
  _i7.Future<_i4.Either<_i5.Failure, List<_i8.TaskEntity>>> call(
          _i9.NoParam? param) =>
      (super.noSuchMethod(Invocation.method(#call, [param]),
              returnValue:
                  Future<_i4.Either<_i5.Failure, List<_i8.TaskEntity>>>.value(
                      _FakeEither_2<_i5.Failure, List<_i8.TaskEntity>>()))
          as _i7.Future<_i4.Either<_i5.Failure, List<_i8.TaskEntity>>>);
}

/// A class which mocks [GetRefreshHistoryUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetRefreshHistoryUsecase extends _i1.Mock
    implements _i11.GetRefreshHistoryUsecase {
  MockGetRefreshHistoryUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.TaskRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeTaskRepository_0()) as _i2.TaskRepository);
  @override
  _i3.AuthenticationRepository get authenticationRepository =>
      (super.noSuchMethod(Invocation.getter(#authenticationRepository),
              returnValue: _FakeAuthenticationRepository_1())
          as _i3.AuthenticationRepository);
  @override
  _i7.Future<_i4.Either<_i5.Failure, List<_i8.TaskEntity>>> call(
          _i9.NoParam? param) =>
      (super.noSuchMethod(Invocation.method(#call, [param]),
              returnValue:
                  Future<_i4.Either<_i5.Failure, List<_i8.TaskEntity>>>.value(
                      _FakeEither_2<_i5.Failure, List<_i8.TaskEntity>>()))
          as _i7.Future<_i4.Either<_i5.Failure, List<_i8.TaskEntity>>>);
}

/// A class which mocks [GetInitialTaskByDateUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetInitialTaskByDateUsecase extends _i1.Mock
    implements _i12.GetInitialTaskByDateUsecase {
  MockGetInitialTaskByDateUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.TaskRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeTaskRepository_0()) as _i2.TaskRepository);
  @override
  _i3.AuthenticationRepository get authenticationRepository =>
      (super.noSuchMethod(Invocation.getter(#authenticationRepository),
              returnValue: _FakeAuthenticationRepository_1())
          as _i3.AuthenticationRepository);
  @override
  _i7.Future<_i4.Either<_i5.Failure, _i13.CombineTaskEntity>> call(
          DateTime? param) =>
      (super.noSuchMethod(Invocation.method(#call, [param]),
              returnValue:
                  Future<_i4.Either<_i5.Failure, _i13.CombineTaskEntity>>.value(
                      _FakeEither_2<_i5.Failure, _i13.CombineTaskEntity>()))
          as _i7.Future<_i4.Either<_i5.Failure, _i13.CombineTaskEntity>>);
  @override
  List<_i14.MonthlyTaskEntity> getMonthlyTaskEntities(
          _i4.Either<_i5.Failure, List<_i14.MonthlyTaskEntity>>?
              monthlyResult) =>
      (super.noSuchMethod(
              Invocation.method(#getMonthlyTaskEntities, [monthlyResult]),
              returnValue: <_i14.MonthlyTaskEntity>[])
          as List<_i14.MonthlyTaskEntity>);
  @override
  List<_i8.TaskEntity> getTaskEntities(
          _i4.Either<_i5.Failure, List<_i8.TaskEntity>>? tasksResult) =>
      (super.noSuchMethod(Invocation.method(#getTaskEntities, [tasksResult]),
          returnValue: <_i8.TaskEntity>[]) as List<_i8.TaskEntity>);
  @override
  _i5.Failure getFailure(dynamic value, _i13.CombineTaskEntity? data) =>
      (super.noSuchMethod(Invocation.method(#getFailure, [value, data]),
          returnValue: _FakeFailure_3()) as _i5.Failure);
}

/// A class which mocks [GetMonthlyTaskUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetMonthlyTaskUsecase extends _i1.Mock
    implements _i15.GetMonthlyTaskUsecase {
  MockGetMonthlyTaskUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.TaskRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeTaskRepository_0()) as _i2.TaskRepository);
  @override
  _i3.AuthenticationRepository get authenticationRepository =>
      (super.noSuchMethod(Invocation.getter(#authenticationRepository),
              returnValue: _FakeAuthenticationRepository_1())
          as _i3.AuthenticationRepository);
  @override
  _i7.Future<_i4.Either<_i5.Failure, List<_i14.MonthlyTaskEntity>>> call(
          DateTime? param) =>
      (super.noSuchMethod(Invocation.method(#call, [param]),
              returnValue: Future<
                      _i4.Either<_i5.Failure,
                          List<_i14.MonthlyTaskEntity>>>.value(
                  _FakeEither_2<_i5.Failure, List<_i14.MonthlyTaskEntity>>()))
          as _i7.Future<_i4.Either<_i5.Failure, List<_i14.MonthlyTaskEntity>>>);
}

/// A class which mocks [GetTaskByDateUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetTaskByDateUsecase extends _i1.Mock
    implements _i16.GetTaskByDateUsecase {
  MockGetTaskByDateUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.TaskRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeTaskRepository_0()) as _i2.TaskRepository);
  @override
  _i3.AuthenticationRepository get authenticationRepository =>
      (super.noSuchMethod(Invocation.getter(#authenticationRepository),
              returnValue: _FakeAuthenticationRepository_1())
          as _i3.AuthenticationRepository);
  @override
  _i7.Future<_i4.Either<_i5.Failure, List<_i8.TaskEntity>>> call(
          DateTime? param) =>
      (super.noSuchMethod(Invocation.method(#call, [param]),
              returnValue:
                  Future<_i4.Either<_i5.Failure, List<_i8.TaskEntity>>>.value(
                      _FakeEither_2<_i5.Failure, List<_i8.TaskEntity>>()))
          as _i7.Future<_i4.Either<_i5.Failure, List<_i8.TaskEntity>>>);
}
