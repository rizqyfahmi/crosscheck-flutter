// Mocks generated by Mockito 5.2.0 from annotations
// in crosscheck/test/features/authentication/data/repositories/authentication_repository_impl_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:crosscheck/core/network/network_info.dart' as _i7;
import 'package:crosscheck/features/authentication/data/datasources/authentication_local_data_source.dart'
    as _i6;
import 'package:crosscheck/features/authentication/data/datasources/authentication_remote_data_source.dart'
    as _i3;
import 'package:crosscheck/features/authentication/data/models/request/registration_params.dart'
    as _i5;
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

/// A class which mocks [AuthenticationRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthenticationRemoteDataSource extends _i1.Mock
    implements _i3.AuthenticationRemoteDataSource {
  MockAuthenticationRemoteDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.AuthenticationResponseModel> registration(
          _i5.RegistrationParams? params) =>
      (super.noSuchMethod(Invocation.method(#registration, [params]),
              returnValue: Future<_i2.AuthenticationResponseModel>.value(
                  _FakeAuthenticationResponseModel_0()))
          as _i4.Future<_i2.AuthenticationResponseModel>);
}

/// A class which mocks [AuthenticationLocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthenticationLocalDataSource extends _i1.Mock
    implements _i6.AuthenticationLocalDataSource {
  MockAuthenticationLocalDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<bool> setToken(String? token) =>
      (super.noSuchMethod(Invocation.method(#setToken, [token]),
          returnValue: Future<bool>.value(false)) as _i4.Future<bool>);
}

/// A class which mocks [NetworkInfo].
///
/// See the documentation for Mockito's code generation for more information.
class MockNetworkInfo extends _i1.Mock implements _i7.NetworkInfo {
  MockNetworkInfo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<bool> get isConnected =>
      (super.noSuchMethod(Invocation.getter(#isConnected),
          returnValue: Future<bool>.value(false)) as _i4.Future<bool>);
}
