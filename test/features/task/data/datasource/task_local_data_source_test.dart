import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/features/task/data/datasource/task_local_data_source.dart';
import 'package:crosscheck/features/task/data/models/data/task_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/utils.dart';
import 'task_local_data_source_test.mocks.dart';

@GenerateMocks([
  Box
])
void main() {
  late MockBox<TaskModel> mockBox;
  late TaskLocalDataSource taskLocalDataSource;

  setUp(() {
    mockBox = MockBox();
    taskLocalDataSource = TaskLocalDataSourceImpl(box: mockBox);
  });

  test("Should cache all histories properly", () async {
    when(mockBox.isOpen).thenReturn(true);
    when(mockBox.put(any, any)).thenAnswer((_) async => Future.value());

    await taskLocalDataSource.cacheHistory(Utils().taskModels);

    verify(mockBox.isOpen);
    verify(mockBox.put(any, any));
  });

  test("Should throws CacheException when cache all histories where box is not open", () async {
    when(mockBox.isOpen).thenReturn(false);

    final call = taskLocalDataSource.cacheHistory;

    expect(() => call(Utils().taskModels), throwsA(
      predicate((error) => error is CacheException)
    ));
    verify(mockBox.isOpen);
    verifyNever(mockBox.put(any, any));
  });

  test("Should get cached history properly", () async {
    when(mockBox.isOpen).thenReturn(true);
    when(mockBox.values.toList()).thenReturn(Utils().taskModels);
    
    final result = await taskLocalDataSource.getCachedHistory();

    expect(result, Utils().taskModels);
    verify(mockBox.isOpen);
    verify(mockBox.values.toList());
  });

  test("Should empty histories when get cached history where box is not open", () async {
    when(mockBox.isOpen).thenReturn(false);

    final result = await taskLocalDataSource.getCachedHistory();

    expect(result, []);
    verify(mockBox.isOpen);
    verifyNever(mockBox.values.toList());
  });

  test("Should clear all cached histories properly", () async {
    when(mockBox.isOpen).thenReturn(true);
    when(mockBox.keys).thenReturn(["0", "1", "2"]);
    when(mockBox.deleteAll(any)).thenAnswer((_) async => Future.value());

    await taskLocalDataSource.clearCachedHistory();
    verify(mockBox.isOpen);
    verify(mockBox.deleteAll(any));
  });

  test("Should throws CacheException when clear all cached histories where box is not open", () async {
    when(mockBox.isOpen).thenReturn(false);

    final call = taskLocalDataSource.clearCachedHistory;

    expect(() => call(), throwsA(
      predicate((error) => error is CacheException)
    ));
    verify(mockBox.isOpen);
    verifyNever(mockBox.deleteAll(any));
  });
}