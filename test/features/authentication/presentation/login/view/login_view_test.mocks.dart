// Mocks generated by Mockito 5.2.0 from annotations
// in crosscheck/test/features/authentication/presentation/login/view/login_view_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i8;

import 'package:crosscheck/core/error/failure.dart' as _i13;
import 'package:crosscheck/features/authentication/data/models/request/login_params.dart'
    as _i15;
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart'
    as _i14;
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart'
    as _i5;
import 'package:crosscheck/features/authentication/domain/usecases/login_usecase.dart'
    as _i3;
import 'package:crosscheck/features/authentication/presentation/authentication/view_models/authentication_bloc.dart'
    as _i7;
import 'package:crosscheck/features/authentication/presentation/authentication/view_models/authentication_event.dart'
    as _i9;
import 'package:crosscheck/features/authentication/presentation/authentication/view_models/authentication_state.dart'
    as _i2;
import 'package:crosscheck/features/authentication/presentation/login/view_models/login_bloc.dart'
    as _i11;
import 'package:crosscheck/features/authentication/presentation/login/view_models/login_event.dart'
    as _i12;
import 'package:crosscheck/features/authentication/presentation/login/view_models/login_state.dart'
    as _i4;
import 'package:dartz/dartz.dart' as _i6;
import 'package:flutter_bloc/flutter_bloc.dart' as _i10;
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

class _FakeLoginUsecase_1 extends _i1.Fake implements _i3.LoginUsecase {}

class _FakeLoginState_2 extends _i1.Fake implements _i4.LoginState {}

class _FakeAuthenticationRepository_3 extends _i1.Fake
    implements _i5.AuthenticationRepository {}

class _FakeEither_4<L, R> extends _i1.Fake implements _i6.Either<L, R> {}

/// A class which mocks [AuthenticationBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthenticationBloc extends _i1.Mock
    implements _i7.AuthenticationBloc {
  MockAuthenticationBloc() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AuthenticationState get state => (super.noSuchMethod(
      Invocation.getter(#state),
      returnValue: _FakeAuthenticationState_0()) as _i2.AuthenticationState);
  @override
  _i8.Stream<_i2.AuthenticationState> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: Stream<_i2.AuthenticationState>.empty())
          as _i8.Stream<_i2.AuthenticationState>);
  @override
  bool get isClosed =>
      (super.noSuchMethod(Invocation.getter(#isClosed), returnValue: false)
          as bool);
  @override
  void add(_i9.AuthenticationEvent? event) =>
      super.noSuchMethod(Invocation.method(#add, [event]),
          returnValueForMissingStub: null);
  @override
  void onEvent(_i9.AuthenticationEvent? event) =>
      super.noSuchMethod(Invocation.method(#onEvent, [event]),
          returnValueForMissingStub: null);
  @override
  void emit(_i2.AuthenticationState? state) =>
      super.noSuchMethod(Invocation.method(#emit, [state]),
          returnValueForMissingStub: null);
  @override
  void on<E extends _i9.AuthenticationEvent>(
          _i10.EventHandler<E, _i2.AuthenticationState>? handler,
          {_i10.EventTransformer<E>? transformer}) =>
      super.noSuchMethod(
          Invocation.method(#on, [handler], {#transformer: transformer}),
          returnValueForMissingStub: null);
  @override
  void onTransition(
          _i10.Transition<_i9.AuthenticationEvent, _i2.AuthenticationState>?
              transition) =>
      super.noSuchMethod(Invocation.method(#onTransition, [transition]),
          returnValueForMissingStub: null);
  @override
  _i8.Future<void> close() => (super.noSuchMethod(Invocation.method(#close, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  void onChange(_i10.Change<_i2.AuthenticationState>? change) =>
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

/// A class which mocks [LoginBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoginBloc extends _i1.Mock implements _i11.LoginBloc {
  MockLoginBloc() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.LoginUsecase get loginUsecase =>
      (super.noSuchMethod(Invocation.getter(#loginUsecase),
          returnValue: _FakeLoginUsecase_1()) as _i3.LoginUsecase);
  @override
  _i4.LoginState get state => (super.noSuchMethod(Invocation.getter(#state),
      returnValue: _FakeLoginState_2()) as _i4.LoginState);
  @override
  _i8.Stream<_i4.LoginState> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: Stream<_i4.LoginState>.empty())
          as _i8.Stream<_i4.LoginState>);
  @override
  bool get isClosed =>
      (super.noSuchMethod(Invocation.getter(#isClosed), returnValue: false)
          as bool);
  @override
  void add(_i12.LoginEvent? event) =>
      super.noSuchMethod(Invocation.method(#add, [event]),
          returnValueForMissingStub: null);
  @override
  void onEvent(_i12.LoginEvent? event) =>
      super.noSuchMethod(Invocation.method(#onEvent, [event]),
          returnValueForMissingStub: null);
  @override
  void emit(_i4.LoginState? state) =>
      super.noSuchMethod(Invocation.method(#emit, [state]),
          returnValueForMissingStub: null);
  @override
  void on<E extends _i12.LoginEvent>(
          _i10.EventHandler<E, _i4.LoginState>? handler,
          {_i10.EventTransformer<E>? transformer}) =>
      super.noSuchMethod(
          Invocation.method(#on, [handler], {#transformer: transformer}),
          returnValueForMissingStub: null);
  @override
  void onTransition(
          _i10.Transition<_i12.LoginEvent, _i4.LoginState>? transition) =>
      super.noSuchMethod(Invocation.method(#onTransition, [transition]),
          returnValueForMissingStub: null);
  @override
  _i8.Future<void> close() => (super.noSuchMethod(Invocation.method(#close, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  void onChange(_i10.Change<_i4.LoginState>? change) =>
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

/// A class which mocks [LoginUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoginUsecase extends _i1.Mock implements _i3.LoginUsecase {
  MockLoginUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.AuthenticationRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
              returnValue: _FakeAuthenticationRepository_3())
          as _i5.AuthenticationRepository);
  @override
  _i8.Future<_i6.Either<_i13.Failure, _i14.AuthenticationEntity>> call(
          _i15.LoginParams? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
          returnValue: Future<
                  _i6.Either<_i13.Failure, _i14.AuthenticationEntity>>.value(
              _FakeEither_4<_i13.Failure, _i14.AuthenticationEntity>())) as _i8
          .Future<_i6.Either<_i13.Failure, _i14.AuthenticationEntity>>);
}