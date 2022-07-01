// Mocks generated by Mockito 5.2.0 from annotations
// in crosscheck/test/features/dashboard/presentation/view/dashboard_view_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i10;

import 'package:crosscheck/core/error/failure.dart' as _i14;
import 'package:crosscheck/core/param/param.dart' as _i18;
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart'
    as _i6;
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_bloc.dart'
    as _i9;
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_event.dart'
    as _i11;
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_state.dart'
    as _i2;
import 'package:crosscheck/features/dashboard/domain/entities/dashboard_entity.dart'
    as _i20;
import 'package:crosscheck/features/dashboard/domain/repositories/dashboard_repository.dart'
    as _i5;
import 'package:crosscheck/features/dashboard/domain/usecases/get_dashboard_usecase.dart'
    as _i19;
import 'package:crosscheck/features/main/data/model/params/bottom_navigation_params.dart'
    as _i16;
import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart'
    as _i15;
import 'package:crosscheck/features/main/domain/repositories/main_repository.dart'
    as _i3;
import 'package:crosscheck/features/main/domain/usecase/get_active_bottom_navigation_usecase.dart'
    as _i17;
import 'package:crosscheck/features/main/domain/usecase/set_active_bottom_navigation_usecase.dart'
    as _i13;
import 'package:crosscheck/features/profile/domain/usecases/get_profile_usecase.dart'
    as _i7;
import 'package:crosscheck/features/profile/presentation/bloc/profile_bloc.dart'
    as _i21;
import 'package:crosscheck/features/profile/presentation/bloc/profile_event.dart'
    as _i22;
import 'package:crosscheck/features/profile/presentation/bloc/profile_state.dart'
    as _i8;
import 'package:dartz/dartz.dart' as _i4;
import 'package:flutter_bloc/flutter_bloc.dart' as _i12;
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

class _FakeAuthenticationState_0 extends _i1.Fake
    implements _i2.AuthenticationState {}

class _FakeMainRepository_1 extends _i1.Fake implements _i3.MainRepository {}

class _FakeEither_2<L, R> extends _i1.Fake implements _i4.Either<L, R> {}

class _FakeDashboardRepository_3 extends _i1.Fake
    implements _i5.DashboardRepository {}

class _FakeAuthenticationRepository_4 extends _i1.Fake
    implements _i6.AuthenticationRepository {}

class _FakeGetProfileUsecase_5 extends _i1.Fake
    implements _i7.GetProfileUsecase {}

class _FakeProfileState_6 extends _i1.Fake implements _i8.ProfileState {}

/// A class which mocks [AuthenticationBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthenticationBloc extends _i1.Mock
    implements _i9.AuthenticationBloc {
  MockAuthenticationBloc() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AuthenticationState get state => (super.noSuchMethod(
      Invocation.getter(#state),
      returnValue: _FakeAuthenticationState_0()) as _i2.AuthenticationState);
  @override
  _i10.Stream<_i2.AuthenticationState> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: Stream<_i2.AuthenticationState>.empty())
          as _i10.Stream<_i2.AuthenticationState>);
  @override
  bool get isClosed =>
      (super.noSuchMethod(Invocation.getter(#isClosed), returnValue: false)
          as bool);
  @override
  void add(_i11.AuthenticationEvent? event) =>
      super.noSuchMethod(Invocation.method(#add, [event]),
          returnValueForMissingStub: null);
  @override
  void onEvent(_i11.AuthenticationEvent? event) =>
      super.noSuchMethod(Invocation.method(#onEvent, [event]),
          returnValueForMissingStub: null);
  @override
  void emit(_i2.AuthenticationState? state) =>
      super.noSuchMethod(Invocation.method(#emit, [state]),
          returnValueForMissingStub: null);
  @override
  void on<E extends _i11.AuthenticationEvent>(
          _i12.EventHandler<E, _i2.AuthenticationState>? handler,
          {_i12.EventTransformer<E>? transformer}) =>
      super.noSuchMethod(
          Invocation.method(#on, [handler], {#transformer: transformer}),
          returnValueForMissingStub: null);
  @override
  void onTransition(
          _i12.Transition<_i11.AuthenticationEvent, _i2.AuthenticationState>?
              transition) =>
      super.noSuchMethod(Invocation.method(#onTransition, [transition]),
          returnValueForMissingStub: null);
  @override
  _i10.Future<void> close() => (super.noSuchMethod(
      Invocation.method(#close, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i10.Future<void>);
  @override
  void onChange(_i12.Change<_i2.AuthenticationState>? change) =>
      super.noSuchMethod(Invocation.method(#onChange, [change]),
          returnValueForMissingStub: null);
  @override
  void addError(Object? error, [StackTrace? stackTrace]) =>
      super.noSuchMethod(Invocation.method(#addError, [error, stackTrace]),
          returnValueForMissingStub: null);
  @override
  void onError(Object? error, StackTrace? stackTrace) =>
      super.noSuchMethod(Invocation.method(#onError, [error, stackTrace]),
          returnValueForMissingStub: null);
}

/// A class which mocks [SetActiveBottomNavigationUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockSetActiveBottomNavigationUsecase extends _i1.Mock
    implements _i13.SetActiveBottomNavigationUsecase {
  MockSetActiveBottomNavigationUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.MainRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeMainRepository_1()) as _i3.MainRepository);
  @override
  _i10.Future<_i4.Either<_i14.Failure, _i15.BottomNavigationEntity>> call(
          _i16.BottomNavigationParams? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
          returnValue: Future<
                  _i4.Either<_i14.Failure, _i15.BottomNavigationEntity>>.value(
              _FakeEither_2<_i14.Failure, _i15.BottomNavigationEntity>())) as _i10
          .Future<_i4.Either<_i14.Failure, _i15.BottomNavigationEntity>>);
}

/// A class which mocks [GetActiveBottomNavigationUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetActiveBottomNavigationUsecase extends _i1.Mock
    implements _i17.GetActiveBottomNavigationUsecase {
  MockGetActiveBottomNavigationUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.MainRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeMainRepository_1()) as _i3.MainRepository);
  @override
  _i10.Future<_i4.Either<_i14.Failure, _i15.BottomNavigationEntity>> call(
          _i18.NoParam? param) =>
      (super.noSuchMethod(Invocation.method(#call, [param]),
          returnValue: Future<
                  _i4.Either<_i14.Failure, _i15.BottomNavigationEntity>>.value(
              _FakeEither_2<_i14.Failure, _i15.BottomNavigationEntity>())) as _i10
          .Future<_i4.Either<_i14.Failure, _i15.BottomNavigationEntity>>);
}

/// A class which mocks [GetDashboardUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetDashboardUsecase extends _i1.Mock
    implements _i19.GetDashboardUsecase {
  MockGetDashboardUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.DashboardRepository get repository => (super.noSuchMethod(
      Invocation.getter(#repository),
      returnValue: _FakeDashboardRepository_3()) as _i5.DashboardRepository);
  @override
  _i6.AuthenticationRepository get authenticationRepository =>
      (super.noSuchMethod(Invocation.getter(#authenticationRepository),
              returnValue: _FakeAuthenticationRepository_4())
          as _i6.AuthenticationRepository);
  @override
  _i10.Future<_i4.Either<_i14.Failure, _i20.DashboardEntity>> call(
          _i18.NoParam? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
              returnValue:
                  Future<_i4.Either<_i14.Failure, _i20.DashboardEntity>>.value(
                      _FakeEither_2<_i14.Failure, _i20.DashboardEntity>()))
          as _i10.Future<_i4.Either<_i14.Failure, _i20.DashboardEntity>>);
}

/// A class which mocks [ProfileBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockProfileBloc extends _i1.Mock implements _i21.ProfileBloc {
  MockProfileBloc() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.GetProfileUsecase get getProfileUsecase =>
      (super.noSuchMethod(Invocation.getter(#getProfileUsecase),
          returnValue: _FakeGetProfileUsecase_5()) as _i7.GetProfileUsecase);
  @override
  _i8.ProfileState get state => (super.noSuchMethod(Invocation.getter(#state),
      returnValue: _FakeProfileState_6()) as _i8.ProfileState);
  @override
  _i10.Stream<_i8.ProfileState> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: Stream<_i8.ProfileState>.empty())
          as _i10.Stream<_i8.ProfileState>);
  @override
  bool get isClosed =>
      (super.noSuchMethod(Invocation.getter(#isClosed), returnValue: false)
          as bool);
  @override
  void add(_i22.ProfileEvent? event) =>
      super.noSuchMethod(Invocation.method(#add, [event]),
          returnValueForMissingStub: null);
  @override
  void onEvent(_i22.ProfileEvent? event) =>
      super.noSuchMethod(Invocation.method(#onEvent, [event]),
          returnValueForMissingStub: null);
  @override
  void emit(_i8.ProfileState? state) =>
      super.noSuchMethod(Invocation.method(#emit, [state]),
          returnValueForMissingStub: null);
  @override
  void on<E extends _i22.ProfileEvent>(
          _i12.EventHandler<E, _i8.ProfileState>? handler,
          {_i12.EventTransformer<E>? transformer}) =>
      super.noSuchMethod(
          Invocation.method(#on, [handler], {#transformer: transformer}),
          returnValueForMissingStub: null);
  @override
  void onTransition(
          _i12.Transition<_i22.ProfileEvent, _i8.ProfileState>? transition) =>
      super.noSuchMethod(Invocation.method(#onTransition, [transition]),
          returnValueForMissingStub: null);
  @override
  _i10.Future<void> close() => (super.noSuchMethod(
      Invocation.method(#close, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i10.Future<void>);
  @override
  void onChange(_i12.Change<_i8.ProfileState>? change) =>
      super.noSuchMethod(Invocation.method(#onChange, [change]),
          returnValueForMissingStub: null);
  @override
  void addError(Object? error, [StackTrace? stackTrace]) =>
      super.noSuchMethod(Invocation.method(#addError, [error, stackTrace]),
          returnValueForMissingStub: null);
  @override
  void onError(Object? error, StackTrace? stackTrace) =>
      super.noSuchMethod(Invocation.method(#onError, [error, stackTrace]),
          returnValueForMissingStub: null);
}
