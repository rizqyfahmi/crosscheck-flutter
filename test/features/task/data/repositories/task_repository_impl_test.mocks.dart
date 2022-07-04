// Mocks generated by Mockito 5.2.0 from annotations
// in crosscheck/test/features/task/data/repositories/task_repository_impl_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:crosscheck/core/network/network_info.dart' as _i6;
import 'package:crosscheck/features/task/data/datasource/task_local_data_source.dart'
    as _i5;
import 'package:crosscheck/features/task/data/datasource/task_remote_data_source.dart'
    as _i2;
import 'package:crosscheck/features/task/data/models/data/task_model.dart'
    as _i4;
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

/// A class which mocks [TaskRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockTaskRemoteDataSource extends _i1.Mock
    implements _i2.TaskRemoteDataSource {
  MockTaskRemoteDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.TaskModel>> getHistory({String? token}) =>
      (super.noSuchMethod(Invocation.method(#getHistory, [], {#token: token}),
              returnValue: Future<List<_i4.TaskModel>>.value(<_i4.TaskModel>[]))
          as _i3.Future<List<_i4.TaskModel>>);
}

/// A class which mocks [TaskLocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockTaskLocalDataSource extends _i1.Mock
    implements _i5.TaskLocalDataSource {
  MockTaskLocalDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.TaskModel>> getCachedHistory() =>
      (super.noSuchMethod(Invocation.method(#getCachedHistory, []),
              returnValue: Future<List<_i4.TaskModel>>.value(<_i4.TaskModel>[]))
          as _i3.Future<List<_i4.TaskModel>>);
  @override
  _i3.Future<void> cacheHistory(List<_i4.TaskModel>? models) =>
      (super.noSuchMethod(Invocation.method(#cacheHistory, [models]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>);
}

/// A class which mocks [NetworkInfo].
///
/// See the documentation for Mockito's code generation for more information.
class MockNetworkInfo extends _i1.Mock implements _i6.NetworkInfo {
  MockNetworkInfo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<bool> get isConnected =>
      (super.noSuchMethod(Invocation.getter(#isConnected),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
}
