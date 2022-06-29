// Mocks generated by Mockito 5.2.0 from annotations
// in crosscheck/test/features/settings/data/repositories/settings_repository_impl_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:crosscheck/features/settings/data/datasource/settings_local_data_source.dart'
    as _i3;
import 'package:crosscheck/features/settings/data/models/data/settings_model.dart'
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

class _FakeSettingsModel_0 extends _i1.Fake implements _i2.SettingsModel {}

/// A class which mocks [SettingsLocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockSettingsLocalDataSource extends _i1.Mock
    implements _i3.SettingsLocalDataSource {
  MockSettingsLocalDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<void> setTheme(_i2.SettingsModel? model) =>
      (super.noSuchMethod(Invocation.method(#setTheme, [model]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<_i2.SettingsModel> getTheme() => (super.noSuchMethod(
          Invocation.method(#getTheme, []),
          returnValue: Future<_i2.SettingsModel>.value(_FakeSettingsModel_0()))
      as _i4.Future<_i2.SettingsModel>);
}
