// Mocks generated by Mockito 5.2.0 from annotations
// in crosscheck/integration_test/features/main/main_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i12;

import 'package:crosscheck/core/error/failure.dart' as _i10;
import 'package:crosscheck/core/param/param.dart' as _i18;
import 'package:crosscheck/features/authentication/data/models/request/login_params.dart'
    as _i13;
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart'
    as _i2;
import 'package:crosscheck/features/authentication/domain/usecases/login_usecase.dart'
    as _i11;
import 'package:crosscheck/features/dashboard/domain/entities/dashboard_entity.dart'
    as _i24;
import 'package:crosscheck/features/dashboard/domain/repositories/dashboard_repository.dart'
    as _i6;
import 'package:crosscheck/features/dashboard/domain/usecases/get_dashboard_usecase.dart'
    as _i23;
import 'package:crosscheck/features/main/data/model/params/bottom_navigation_params.dart'
    as _i21;
import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart'
    as _i20;
import 'package:crosscheck/features/main/domain/repositories/main_repository.dart'
    as _i5;
import 'package:crosscheck/features/main/domain/usecase/get_active_bottom_navigation_usecase.dart'
    as _i22;
import 'package:crosscheck/features/main/domain/usecase/set_active_bottom_navigation_usecase.dart'
    as _i19;
import 'package:crosscheck/features/profile/domain/entities/profile_entity.dart'
    as _i30;
import 'package:crosscheck/features/profile/domain/repositories/profile_repository.dart'
    as _i7;
import 'package:crosscheck/features/profile/domain/usecases/get_profile_usecase.dart'
    as _i29;
import 'package:crosscheck/features/settings/data/models/params/settings_params.dart'
    as _i26;
import 'package:crosscheck/features/settings/domain/entities/settings_entity.dart'
    as _i28;
import 'package:crosscheck/features/settings/domain/repositories/settings_repository.dart'
    as _i8;
import 'package:crosscheck/features/settings/domain/usecase/get_theme_usecase.dart'
    as _i27;
import 'package:crosscheck/features/settings/domain/usecase/set_theme_usecase.dart'
    as _i25;
import 'package:crosscheck/features/task/domain/entities/combine_task_entity.dart'
    as _i36;
import 'package:crosscheck/features/task/domain/entities/monthly_task_entity.dart'
    as _i37;
import 'package:crosscheck/features/task/domain/entities/task_entity.dart'
    as _i32;
import 'package:crosscheck/features/task/domain/repositories/task_respository.dart'
    as _i9;
import 'package:crosscheck/features/task/domain/usecases/get_history_usecase.dart'
    as _i31;
import 'package:crosscheck/features/task/domain/usecases/get_initial_task_by_date_usecase.dart'
    as _i35;
import 'package:crosscheck/features/task/domain/usecases/get_monthly_task_usecase.dart'
    as _i38;
import 'package:crosscheck/features/task/domain/usecases/get_more_history_usecase.dart'
    as _i33;
import 'package:crosscheck/features/task/domain/usecases/get_more_task_by_date_usecase.dart'
    as _i40;
import 'package:crosscheck/features/task/domain/usecases/get_refresh_history_usecase.dart'
    as _i34;
import 'package:crosscheck/features/task/domain/usecases/get_task_by_date_usecase.dart'
    as _i39;
import 'package:crosscheck/features/walkthrough/data/models/request/walkthrough_params.dart'
    as _i15;
import 'package:crosscheck/features/walkthrough/domain/entities/walkthrough_entitiy.dart'
    as _i17;
import 'package:crosscheck/features/walkthrough/domain/repositories/walkthrough_repository.dart'
    as _i4;
import 'package:crosscheck/features/walkthrough/domain/usecases/get_is_skip_usecase.dart'
    as _i16;
import 'package:crosscheck/features/walkthrough/domain/usecases/set_is_skip_usecase.dart'
    as _i14;
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

class _FakeProfileRepository_5 extends _i1.Fake
    implements _i7.ProfileRepository {}

class _FakeSettingsRepository_6 extends _i1.Fake
    implements _i8.SettingsRepository {}

class _FakeTaskRepository_7 extends _i1.Fake implements _i9.TaskRepository {}

class _FakeFailure_8 extends _i1.Fake implements _i10.Failure {}

/// A class which mocks [LoginUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoginUsecase extends _i1.Mock implements _i11.LoginUsecase {
  MockLoginUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AuthenticationRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
              returnValue: _FakeAuthenticationRepository_0())
          as _i2.AuthenticationRepository);
  @override
  _i12.Future<_i3.Either<_i10.Failure, void>> call(_i13.LoginParams? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
              returnValue: Future<_i3.Either<_i10.Failure, void>>.value(
                  _FakeEither_1<_i10.Failure, void>()))
          as _i12.Future<_i3.Either<_i10.Failure, void>>);
}

/// A class which mocks [SetIsSkipUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockSetIsSkipUsecase extends _i1.Mock implements _i14.SetIsSkipUsecase {
  MockSetIsSkipUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.WalkthroughRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
              returnValue: _FakeWalkthroughRepository_2())
          as _i4.WalkthroughRepository);
  @override
  _i12.Future<_i3.Either<_i10.Failure, void>> call(
          _i15.WalkthroughParams? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
              returnValue: Future<_i3.Either<_i10.Failure, void>>.value(
                  _FakeEither_1<_i10.Failure, void>()))
          as _i12.Future<_i3.Either<_i10.Failure, void>>);
}

/// A class which mocks [GetIsSkipUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetIsSkipUsecase extends _i1.Mock implements _i16.GetIsSkipUsecase {
  MockGetIsSkipUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.WalkthroughRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
              returnValue: _FakeWalkthroughRepository_2())
          as _i4.WalkthroughRepository);
  @override
  _i12.Future<_i3.Either<_i10.Failure, _i17.WalkthroughEntity>> call(
          _i18.NoParam? param) =>
      (super.noSuchMethod(Invocation.method(#call, [param]),
              returnValue: Future<
                      _i3.Either<_i10.Failure, _i17.WalkthroughEntity>>.value(
                  _FakeEither_1<_i10.Failure, _i17.WalkthroughEntity>()))
          as _i12.Future<_i3.Either<_i10.Failure, _i17.WalkthroughEntity>>);
}

/// A class which mocks [SetActiveBottomNavigationUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockSetActiveBottomNavigationUsecase extends _i1.Mock
    implements _i19.SetActiveBottomNavigationUsecase {
  MockSetActiveBottomNavigationUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.MainRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeMainRepository_3()) as _i5.MainRepository);
  @override
  _i12.Future<_i3.Either<_i10.Failure, _i20.BottomNavigationEntity>> call(
          _i21.BottomNavigationParams? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
          returnValue: Future<
                  _i3.Either<_i10.Failure, _i20.BottomNavigationEntity>>.value(
              _FakeEither_1<_i10.Failure, _i20.BottomNavigationEntity>())) as _i12
          .Future<_i3.Either<_i10.Failure, _i20.BottomNavigationEntity>>);
}

/// A class which mocks [GetActiveBottomNavigationUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetActiveBottomNavigationUsecase extends _i1.Mock
    implements _i22.GetActiveBottomNavigationUsecase {
  MockGetActiveBottomNavigationUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.MainRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeMainRepository_3()) as _i5.MainRepository);
  @override
  _i12.Future<_i3.Either<_i10.Failure, _i20.BottomNavigationEntity>> call(
          _i18.NoParam? param) =>
      (super.noSuchMethod(Invocation.method(#call, [param]),
          returnValue: Future<
                  _i3.Either<_i10.Failure, _i20.BottomNavigationEntity>>.value(
              _FakeEither_1<_i10.Failure, _i20.BottomNavigationEntity>())) as _i12
          .Future<_i3.Either<_i10.Failure, _i20.BottomNavigationEntity>>);
}

/// A class which mocks [GetDashboardUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetDashboardUsecase extends _i1.Mock
    implements _i23.GetDashboardUsecase {
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
  _i7.ProfileRepository get profileRepository =>
      (super.noSuchMethod(Invocation.getter(#profileRepository),
          returnValue: _FakeProfileRepository_5()) as _i7.ProfileRepository);
  @override
  _i12.Future<_i3.Either<_i10.Failure, _i24.DashboardEntity>> call(
          _i18.NoParam? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
              returnValue:
                  Future<_i3.Either<_i10.Failure, _i24.DashboardEntity>>.value(
                      _FakeEither_1<_i10.Failure, _i24.DashboardEntity>()))
          as _i12.Future<_i3.Either<_i10.Failure, _i24.DashboardEntity>>);
}

/// A class which mocks [SetThemeUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockSetThemeUsecase extends _i1.Mock implements _i25.SetThemeUsecase {
  MockSetThemeUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.SettingsRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeSettingsRepository_6()) as _i8.SettingsRepository);
  @override
  _i12.Future<_i3.Either<_i10.Failure, void>> call(
          _i26.SettingsParams? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
              returnValue: Future<_i3.Either<_i10.Failure, void>>.value(
                  _FakeEither_1<_i10.Failure, void>()))
          as _i12.Future<_i3.Either<_i10.Failure, void>>);
}

/// A class which mocks [GetThemeUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetThemeUsecase extends _i1.Mock implements _i27.GetThemeUsecase {
  MockGetThemeUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.SettingsRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeSettingsRepository_6()) as _i8.SettingsRepository);
  @override
  _i12.Future<_i3.Either<_i10.Failure, _i28.SettingsEntity>> call(
          _i18.NoParam? param) =>
      (super.noSuchMethod(Invocation.method(#call, [param]),
              returnValue:
                  Future<_i3.Either<_i10.Failure, _i28.SettingsEntity>>.value(
                      _FakeEither_1<_i10.Failure, _i28.SettingsEntity>()))
          as _i12.Future<_i3.Either<_i10.Failure, _i28.SettingsEntity>>);
}

/// A class which mocks [GetProfileUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetProfileUsecase extends _i1.Mock implements _i29.GetProfileUsecase {
  MockGetProfileUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.ProfileRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeProfileRepository_5()) as _i7.ProfileRepository);
  @override
  _i2.AuthenticationRepository get authenticationRepository =>
      (super.noSuchMethod(Invocation.getter(#authenticationRepository),
              returnValue: _FakeAuthenticationRepository_0())
          as _i2.AuthenticationRepository);
  @override
  _i12.Future<_i3.Either<_i10.Failure, _i30.ProfileEntity>> call(
          _i18.NoParam? param) =>
      (super.noSuchMethod(Invocation.method(#call, [param]),
              returnValue:
                  Future<_i3.Either<_i10.Failure, _i30.ProfileEntity>>.value(
                      _FakeEither_1<_i10.Failure, _i30.ProfileEntity>()))
          as _i12.Future<_i3.Either<_i10.Failure, _i30.ProfileEntity>>);
}

/// A class which mocks [GetHistoryUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetHistoryUsecase extends _i1.Mock implements _i31.GetHistoryUsecase {
  MockGetHistoryUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i9.TaskRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeTaskRepository_7()) as _i9.TaskRepository);
  @override
  _i2.AuthenticationRepository get authenticationRepository =>
      (super.noSuchMethod(Invocation.getter(#authenticationRepository),
              returnValue: _FakeAuthenticationRepository_0())
          as _i2.AuthenticationRepository);
  @override
  _i12.Future<_i3.Either<_i10.Failure, List<_i32.TaskEntity>>> call(
          _i18.NoParam? param) =>
      (super.noSuchMethod(Invocation.method(#call, [param]),
              returnValue:
                  Future<_i3.Either<_i10.Failure, List<_i32.TaskEntity>>>.value(
                      _FakeEither_1<_i10.Failure, List<_i32.TaskEntity>>()))
          as _i12.Future<_i3.Either<_i10.Failure, List<_i32.TaskEntity>>>);
}

/// A class which mocks [GetMoreHistoryUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetMoreHistoryUsecase extends _i1.Mock
    implements _i33.GetMoreHistoryUsecase {
  MockGetMoreHistoryUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i9.TaskRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeTaskRepository_7()) as _i9.TaskRepository);
  @override
  _i2.AuthenticationRepository get authenticationRepository =>
      (super.noSuchMethod(Invocation.getter(#authenticationRepository),
              returnValue: _FakeAuthenticationRepository_0())
          as _i2.AuthenticationRepository);
  @override
  _i12.Future<_i3.Either<_i10.Failure, List<_i32.TaskEntity>>> call(
          _i18.NoParam? param) =>
      (super.noSuchMethod(Invocation.method(#call, [param]),
              returnValue:
                  Future<_i3.Either<_i10.Failure, List<_i32.TaskEntity>>>.value(
                      _FakeEither_1<_i10.Failure, List<_i32.TaskEntity>>()))
          as _i12.Future<_i3.Either<_i10.Failure, List<_i32.TaskEntity>>>);
}

/// A class which mocks [GetRefreshHistoryUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetRefreshHistoryUsecase extends _i1.Mock
    implements _i34.GetRefreshHistoryUsecase {
  MockGetRefreshHistoryUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i9.TaskRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeTaskRepository_7()) as _i9.TaskRepository);
  @override
  _i2.AuthenticationRepository get authenticationRepository =>
      (super.noSuchMethod(Invocation.getter(#authenticationRepository),
              returnValue: _FakeAuthenticationRepository_0())
          as _i2.AuthenticationRepository);
  @override
  _i12.Future<_i3.Either<_i10.Failure, List<_i32.TaskEntity>>> call(
          _i18.NoParam? param) =>
      (super.noSuchMethod(Invocation.method(#call, [param]),
              returnValue:
                  Future<_i3.Either<_i10.Failure, List<_i32.TaskEntity>>>.value(
                      _FakeEither_1<_i10.Failure, List<_i32.TaskEntity>>()))
          as _i12.Future<_i3.Either<_i10.Failure, List<_i32.TaskEntity>>>);
}

/// A class which mocks [GetInitialTaskByDateUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetInitialTaskByDateUsecase extends _i1.Mock
    implements _i35.GetInitialTaskByDateUsecase {
  MockGetInitialTaskByDateUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i9.TaskRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeTaskRepository_7()) as _i9.TaskRepository);
  @override
  _i2.AuthenticationRepository get authenticationRepository =>
      (super.noSuchMethod(Invocation.getter(#authenticationRepository),
              returnValue: _FakeAuthenticationRepository_0())
          as _i2.AuthenticationRepository);
  @override
  _i12.Future<_i3.Either<_i10.Failure, _i36.CombineTaskEntity>> call(
          DateTime? param) =>
      (super.noSuchMethod(Invocation.method(#call, [param]),
              returnValue: Future<
                      _i3.Either<_i10.Failure, _i36.CombineTaskEntity>>.value(
                  _FakeEither_1<_i10.Failure, _i36.CombineTaskEntity>()))
          as _i12.Future<_i3.Either<_i10.Failure, _i36.CombineTaskEntity>>);
  @override
  List<_i37.MonthlyTaskEntity> getMonthlyTaskEntities(
          _i3.Either<_i10.Failure, List<_i37.MonthlyTaskEntity>>?
              monthlyResult) =>
      (super.noSuchMethod(
              Invocation.method(#getMonthlyTaskEntities, [monthlyResult]),
              returnValue: <_i37.MonthlyTaskEntity>[])
          as List<_i37.MonthlyTaskEntity>);
  @override
  List<_i32.TaskEntity> getTaskEntities(
          _i3.Either<_i10.Failure, List<_i32.TaskEntity>>? tasksResult) =>
      (super.noSuchMethod(Invocation.method(#getTaskEntities, [tasksResult]),
          returnValue: <_i32.TaskEntity>[]) as List<_i32.TaskEntity>);
  @override
  _i10.Failure getFailure(dynamic value, _i36.CombineTaskEntity? data) =>
      (super.noSuchMethod(Invocation.method(#getFailure, [value, data]),
          returnValue: _FakeFailure_8()) as _i10.Failure);
}

/// A class which mocks [GetMonthlyTaskUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetMonthlyTaskUsecase extends _i1.Mock
    implements _i38.GetMonthlyTaskUsecase {
  MockGetMonthlyTaskUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i9.TaskRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeTaskRepository_7()) as _i9.TaskRepository);
  @override
  _i2.AuthenticationRepository get authenticationRepository =>
      (super.noSuchMethod(Invocation.getter(#authenticationRepository),
              returnValue: _FakeAuthenticationRepository_0())
          as _i2.AuthenticationRepository);
  @override
  _i12.Future<_i3.Either<_i10.Failure, List<_i37.MonthlyTaskEntity>>> call(
          DateTime? param) =>
      (super.noSuchMethod(Invocation.method(#call, [param]),
              returnValue: Future<
                      _i3.Either<_i10.Failure,
                          List<_i37.MonthlyTaskEntity>>>.value(
                  _FakeEither_1<_i10.Failure, List<_i37.MonthlyTaskEntity>>()))
          as _i12.Future<_i3.Either<_i10.Failure, List<_i37.MonthlyTaskEntity>>>);
}

/// A class which mocks [GetTaskByDateUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetTaskByDateUsecase extends _i1.Mock
    implements _i39.GetTaskByDateUsecase {
  MockGetTaskByDateUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i9.TaskRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeTaskRepository_7()) as _i9.TaskRepository);
  @override
  _i2.AuthenticationRepository get authenticationRepository =>
      (super.noSuchMethod(Invocation.getter(#authenticationRepository),
              returnValue: _FakeAuthenticationRepository_0())
          as _i2.AuthenticationRepository);
  @override
  _i12.Future<_i3.Either<_i10.Failure, List<_i32.TaskEntity>>> call(
          DateTime? param) =>
      (super.noSuchMethod(Invocation.method(#call, [param]),
              returnValue:
                  Future<_i3.Either<_i10.Failure, List<_i32.TaskEntity>>>.value(
                      _FakeEither_1<_i10.Failure, List<_i32.TaskEntity>>()))
          as _i12.Future<_i3.Either<_i10.Failure, List<_i32.TaskEntity>>>);
}

/// A class which mocks [GetMoreTaskByDateUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetMoreTaskByDateUsecase extends _i1.Mock
    implements _i40.GetMoreTaskByDateUsecase {
  MockGetMoreTaskByDateUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i9.TaskRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeTaskRepository_7()) as _i9.TaskRepository);
  @override
  _i2.AuthenticationRepository get authenticationRepository =>
      (super.noSuchMethod(Invocation.getter(#authenticationRepository),
              returnValue: _FakeAuthenticationRepository_0())
          as _i2.AuthenticationRepository);
  @override
  _i12.Future<_i3.Either<_i10.Failure, List<_i32.TaskEntity>>> call(
          DateTime? param) =>
      (super.noSuchMethod(Invocation.method(#call, [param]),
              returnValue:
                  Future<_i3.Either<_i10.Failure, List<_i32.TaskEntity>>>.value(
                      _FakeEither_1<_i10.Failure, List<_i32.TaskEntity>>()))
          as _i12.Future<_i3.Either<_i10.Failure, List<_i32.TaskEntity>>>);
}
