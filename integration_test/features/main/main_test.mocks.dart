// Mocks generated by Mockito 5.2.0 from annotations
// in crosscheck/integration_test/features/main/main_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i9;

import 'package:crosscheck/core/error/failure.dart' as _i10;
import 'package:crosscheck/core/param/param.dart' as _i16;
import 'package:crosscheck/features/authentication/data/models/request/login_params.dart'
    as _i11;
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart'
    as _i2;
import 'package:crosscheck/features/authentication/domain/usecases/login_usecase.dart'
    as _i8;
import 'package:crosscheck/features/dashboard/domain/entities/dashboard_entity.dart'
    as _i22;
import 'package:crosscheck/features/dashboard/domain/repositories/dashboard_repository.dart'
    as _i6;
import 'package:crosscheck/features/dashboard/domain/usecases/get_dashboard_usecase.dart'
    as _i21;
import 'package:crosscheck/features/main/data/model/bottom_navigation_model.dart'
    as _i19;
import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart'
    as _i18;
import 'package:crosscheck/features/main/domain/repositories/main_repository.dart'
    as _i5;
import 'package:crosscheck/features/main/domain/usecase/get_active_bottom_navigation_usecase.dart'
    as _i20;
import 'package:crosscheck/features/main/domain/usecase/set_active_bottom_navigation_usecase.dart'
    as _i17;
import 'package:crosscheck/features/settings/data/models/params/settings_params.dart'
    as _i24;
import 'package:crosscheck/features/settings/domain/entities/settings_entity.dart'
    as _i26;
import 'package:crosscheck/features/settings/domain/repositories/settings_repository.dart'
    as _i7;
import 'package:crosscheck/features/settings/domain/usecase/get_theme_usecase.dart'
    as _i25;
import 'package:crosscheck/features/settings/domain/usecase/set_theme_usecase.dart'
    as _i23;
import 'package:crosscheck/features/walkthrough/data/models/request/walkthrough_params.dart'
    as _i13;
import 'package:crosscheck/features/walkthrough/domain/entities/walkthrough_entitiy.dart'
    as _i15;
import 'package:crosscheck/features/walkthrough/domain/repositories/walkthrough_repository.dart'
    as _i4;
import 'package:crosscheck/features/walkthrough/domain/usecases/get_is_skip_usecase.dart'
    as _i14;
import 'package:crosscheck/features/walkthrough/domain/usecases/set_is_skip_usecase.dart'
    as _i12;
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

class _FakeWalkthroughRepository_2 extends _i1.Fake
    implements _i4.WalkthroughRepository {}

class _FakeMainRepository_3 extends _i1.Fake implements _i5.MainRepository {}

class _FakeDashboardRepository_4 extends _i1.Fake
    implements _i6.DashboardRepository {}

class _FakeSettingsRepository_5 extends _i1.Fake
    implements _i7.SettingsRepository {}

/// A class which mocks [LoginUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoginUsecase extends _i1.Mock implements _i8.LoginUsecase {
  MockLoginUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AuthenticationRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
              returnValue: _FakeAuthenticationRepository_0())
          as _i2.AuthenticationRepository);
  @override
  _i9.Future<_i3.Either<_i10.Failure, void>> call(_i11.LoginParams? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
              returnValue: Future<_i3.Either<_i10.Failure, void>>.value(
                  _FakeEither_1<_i10.Failure, void>()))
          as _i9.Future<_i3.Either<_i10.Failure, void>>);
}

/// A class which mocks [SetIsSkipUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockSetIsSkipUsecase extends _i1.Mock implements _i12.SetIsSkipUsecase {
  MockSetIsSkipUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.WalkthroughRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
              returnValue: _FakeWalkthroughRepository_2())
          as _i4.WalkthroughRepository);
  @override
  _i9.Future<_i3.Either<_i10.Failure, void>> call(
          _i13.WalkthroughParams? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
              returnValue: Future<_i3.Either<_i10.Failure, void>>.value(
                  _FakeEither_1<_i10.Failure, void>()))
          as _i9.Future<_i3.Either<_i10.Failure, void>>);
}

/// A class which mocks [GetIsSkipUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetIsSkipUsecase extends _i1.Mock implements _i14.GetIsSkipUsecase {
  MockGetIsSkipUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.WalkthroughRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
              returnValue: _FakeWalkthroughRepository_2())
          as _i4.WalkthroughRepository);
  @override
  _i9.Future<_i3.Either<_i10.Failure, _i15.WalkthroughEntity>> call(
          _i16.NoParam? param) =>
      (super.noSuchMethod(Invocation.method(#call, [param]),
          returnValue:
              Future<_i3.Either<_i10.Failure, _i15.WalkthroughEntity>>.value(
                  _FakeEither_1<_i10.Failure, _i15.WalkthroughEntity>())) as _i9
          .Future<_i3.Either<_i10.Failure, _i15.WalkthroughEntity>>);
}

/// A class which mocks [SetActiveBottomNavigationUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockSetActiveBottomNavigationUsecase extends _i1.Mock
    implements _i17.SetActiveBottomNavigationUsecase {
  MockSetActiveBottomNavigationUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.MainRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeMainRepository_3()) as _i5.MainRepository);
  @override
  _i9.Future<_i3.Either<_i10.Failure, _i18.BottomNavigationEntity>> call(
          _i19.BottomNavigationModel? param) =>
      (super.noSuchMethod(Invocation.method(#call, [param]),
          returnValue: Future<
                  _i3.Either<_i10.Failure, _i18.BottomNavigationEntity>>.value(
              _FakeEither_1<_i10.Failure, _i18.BottomNavigationEntity>())) as _i9
          .Future<_i3.Either<_i10.Failure, _i18.BottomNavigationEntity>>);
}

/// A class which mocks [GetActiveBottomNavigationUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetActiveBottomNavigationUsecase extends _i1.Mock
    implements _i20.GetActiveBottomNavigationUsecase {
  MockGetActiveBottomNavigationUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.MainRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeMainRepository_3()) as _i5.MainRepository);
  @override
  _i9.Future<_i3.Either<_i10.Failure, _i18.BottomNavigationEntity>> call(
          _i16.NoParam? param) =>
      (super.noSuchMethod(Invocation.method(#call, [param]),
              returnValue: Future<
                      _i3.Either<_i10.Failure,
                          _i18.BottomNavigationEntity>>.value(
                  _FakeEither_1<_i10.Failure, _i18.BottomNavigationEntity>()))
          as _i9.Future<_i3.Either<_i10.Failure, _i18.BottomNavigationEntity>>);
}

/// A class which mocks [GetDashboardUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetDashboardUsecase extends _i1.Mock
    implements _i21.GetDashboardUsecase {
  MockGetDashboardUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.DashboardRepository get repository => (super.noSuchMethod(
      Invocation.getter(#repository),
      returnValue: _FakeDashboardRepository_4()) as _i6.DashboardRepository);
  @override
  _i2.AuthenticationRepository get authenticationRepository =>
      (super.noSuchMethod(Invocation.getter(#authenticationRepository),
              returnValue: _FakeAuthenticationRepository_0())
          as _i2.AuthenticationRepository);
  @override
  _i9.Future<_i3.Either<_i10.Failure, _i22.DashboardEntity>> call(
          _i16.NoParam? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
              returnValue:
                  Future<_i3.Either<_i10.Failure, _i22.DashboardEntity>>.value(
                      _FakeEither_1<_i10.Failure, _i22.DashboardEntity>()))
          as _i9.Future<_i3.Either<_i10.Failure, _i22.DashboardEntity>>);
}

/// A class which mocks [SetThemeUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockSetThemeUsecase extends _i1.Mock implements _i23.SetThemeUsecase {
  MockSetThemeUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.SettingsRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeSettingsRepository_5()) as _i7.SettingsRepository);
  @override
  _i9.Future<_i3.Either<_i10.Failure, void>> call(
          _i24.SettingsParams? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
              returnValue: Future<_i3.Either<_i10.Failure, void>>.value(
                  _FakeEither_1<_i10.Failure, void>()))
          as _i9.Future<_i3.Either<_i10.Failure, void>>);
}

/// A class which mocks [GetThemeUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetThemeUsecase extends _i1.Mock implements _i25.GetThemeUsecase {
  MockGetThemeUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.SettingsRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeSettingsRepository_5()) as _i7.SettingsRepository);
  @override
  _i9.Future<_i3.Either<_i10.Failure, _i26.SettingsEntity>> call(
          _i16.NoParam? param) =>
      (super.noSuchMethod(Invocation.method(#call, [param]),
              returnValue:
                  Future<_i3.Either<_i10.Failure, _i26.SettingsEntity>>.value(
                      _FakeEither_1<_i10.Failure, _i26.SettingsEntity>()))
          as _i9.Future<_i3.Either<_i10.Failure, _i26.SettingsEntity>>);
}
