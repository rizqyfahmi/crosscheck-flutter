// Mocks generated by Mockito 5.2.0 from annotations
// in crosscheck/test/features/dashboard/presentation/bloc/dashboard_bloc_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i5;

import 'package:crosscheck/core/error/failure.dart' as _i6;
import 'package:crosscheck/features/dashboard/data/models/params/dashboard_params.dart'
    as _i8;
import 'package:crosscheck/features/dashboard/domain/entities/dashboard_entity.dart'
    as _i7;
import 'package:crosscheck/features/dashboard/domain/repositories/dashboard_repository.dart'
    as _i2;
import 'package:crosscheck/features/dashboard/domain/usecases/get_dashboard_usecase.dart'
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

class _FakeDashboardRepository_0 extends _i1.Fake
    implements _i2.DashboardRepository {}

class _FakeEither_1<L, R> extends _i1.Fake implements _i3.Either<L, R> {}

/// A class which mocks [GetDashboardUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetDashboardUsecase extends _i1.Mock
    implements _i4.GetDashboardUsecase {
  MockGetDashboardUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.DashboardRepository get repository => (super.noSuchMethod(
      Invocation.getter(#repository),
      returnValue: _FakeDashboardRepository_0()) as _i2.DashboardRepository);
  @override
  _i5.Future<_i3.Either<_i6.Failure, _i7.DashboardEntity>> call(
          _i8.DashboardParams? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
              returnValue:
                  Future<_i3.Either<_i6.Failure, _i7.DashboardEntity>>.value(
                      _FakeEither_1<_i6.Failure, _i7.DashboardEntity>()))
          as _i5.Future<_i3.Either<_i6.Failure, _i7.DashboardEntity>>);
}
