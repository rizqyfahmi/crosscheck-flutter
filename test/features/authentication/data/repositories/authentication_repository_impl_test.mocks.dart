// Mocks generated by Mockito 5.2.0 from annotations
// in crosscheck/test/features/authentication/data/repositories/authentication_repository_impl_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i5;

import 'package:crosscheck/core/network/network_info.dart' as _i9;
import 'package:crosscheck/features/authentication/data/datasources/authentication_local_data_source.dart'
    as _i8;
import 'package:crosscheck/features/authentication/data/datasources/authentication_remote_data_source.dart'
    as _i4;
import 'package:crosscheck/features/authentication/data/models/data/authentication_model.dart'
    as _i3;
import 'package:crosscheck/features/authentication/data/models/request/login_params.dart'
    as _i7;
import 'package:crosscheck/features/authentication/data/models/request/registration_params.dart'
    as _i6;
import 'package:crosscheck/features/authentication/data/models/response/authentication_response_model.dart'
    as _i2;
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

class _FakeAuthenticationResponseModel_0 extends _i1.Fake
    implements _i2.AuthenticationResponseModel {}

class _FakeAuthenticationModel_1 extends _i1.Fake
    implements _i3.AuthenticationModel {}

/// A class which mocks [AuthenticationRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthenticationRemoteDataSource extends _i1.Mock
    implements _i4.AuthenticationRemoteDataSource {
  MockAuthenticationRemoteDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<_i2.AuthenticationResponseModel> registration(
          _i6.RegistrationParams? params) =>
      (super.noSuchMethod(Invocation.method(#registration, [params]),
              returnValue: Future<_i2.AuthenticationResponseModel>.value(
                  _FakeAuthenticationResponseModel_0()))
          as _i5.Future<_i2.AuthenticationResponseModel>);
  @override
  _i5.Future<_i2.AuthenticationResponseModel> login(_i7.LoginParams? params) =>
      (super.noSuchMethod(Invocation.method(#login, [params]),
              returnValue: Future<_i2.AuthenticationResponseModel>.value(
                  _FakeAuthenticationResponseModel_0()))
          as _i5.Future<_i2.AuthenticationResponseModel>);
}

/// A class which mocks [AuthenticationLocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthenticationLocalDataSource extends _i1.Mock
    implements _i8.AuthenticationLocalDataSource {
  MockAuthenticationLocalDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<void> setToken(_i3.AuthenticationModel? model) =>
      (super.noSuchMethod(Invocation.method(#setToken, [model]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i5.Future<void>);
  @override
  _i5.Future<_i3.AuthenticationModel> getToken() =>
      (super.noSuchMethod(Invocation.method(#getToken, []),
              returnValue: Future<_i3.AuthenticationModel>.value(
                  _FakeAuthenticationModel_1()))
          as _i5.Future<_i3.AuthenticationModel>);
}

/// A class which mocks [NetworkInfo].
///
/// See the documentation for Mockito's code generation for more information.
class MockNetworkInfo extends _i1.Mock implements _i9.NetworkInfo {
  MockNetworkInfo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<bool> get isConnected =>
      (super.noSuchMethod(Invocation.getter(#isConnected),
          returnValue: Future<bool>.value(false)) as _i5.Future<bool>);
}
