import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/features/task/data/datasource/task_local_data_source.dart';
import 'package:crosscheck/features/task/data/models/data/counted_daily_task_model.dart';
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
  late MockBox<CountedDailyTaskModel> mockCountedDailyTaskBox;
  late TaskLocalDataSource taskLocalDataSource;

  setUp(() {
    mockBox = MockBox();
    mockCountedDailyTaskBox = MockBox();
    taskLocalDataSource = TaskLocalDataSourceImpl(taskBox: mockBox, countedDailyTaskBox: mockCountedDailyTaskBox);
  });

  /*--------------------------------------------------- Get History ---------------------------------------------------*/
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

  /*--------------------------------------------------- Get Count Daily Task by Month ---------------------------------------------------*/
  test("Should cache counted daily task by month properly", () async {
    final time = DateTime(2022, 7);
    final utils = Utils();
    final expected = utils.getCountedDailyTaskModel(time: time);
    when(mockCountedDailyTaskBox.isOpen).thenReturn(true);
    when(mockCountedDailyTaskBox.put(any, any)).thenAnswer((_) async => Future.value());

    await taskLocalDataSource.cacheCountDailyTask(expected);

    verify(mockCountedDailyTaskBox.isOpen);
    verify(mockCountedDailyTaskBox.put(any, any));
  });

  test("Should throws CacheException when cache counted daily task by month at the time box is not open", () async {
    final time = DateTime(2022, 7);
    final utils = Utils();
    final expected = utils.getCountedDailyTaskModel(time: time);
    when(mockCountedDailyTaskBox.isOpen).thenReturn(false);

    final call = taskLocalDataSource.cacheCountDailyTask;

    expect(() => call(expected), throwsA(
      predicate((error) => error is CacheException)
    ));
    verify(mockCountedDailyTaskBox.isOpen);
    verifyNever(mockCountedDailyTaskBox.put(any, any));
  });

  test("Should get cache counted daily task by month properly", () async {
    final time = DateTime(2022, 7);
    final utils = Utils();
    final expected = utils.getCountedDailyTaskModel(time: time);
    when(mockCountedDailyTaskBox.isOpen).thenReturn(true);
    when(mockCountedDailyTaskBox.values.toList()).thenReturn(expected);
    
    final result = await taskLocalDataSource.getCacheCountDailyTask();

    expect(result, expected);
    verify(mockCountedDailyTaskBox.isOpen);
    verify(mockCountedDailyTaskBox.values.toList());
  });

  test("Should empty list when get cache counted daily task by month at the time box is not open", () async {
    when(mockCountedDailyTaskBox.isOpen).thenReturn(false);

    final result = await taskLocalDataSource.getCacheCountDailyTask();

    expect(result, []);
    verify(mockCountedDailyTaskBox.isOpen);
    verifyNever(mockCountedDailyTaskBox.values.toList());
  });

  test("Should clear cache counted daily task by month properly", () async {
    when(mockCountedDailyTaskBox.isOpen).thenReturn(true);
    when(mockCountedDailyTaskBox.keys).thenReturn(["0", "1", "2"]);
    when(mockCountedDailyTaskBox.deleteAll(any)).thenAnswer((_) async => Future.value());

    await taskLocalDataSource.clearCachedDailyTask();
    verify(mockCountedDailyTaskBox.isOpen);
    verify(mockCountedDailyTaskBox.deleteAll(any));
  });

  test("Should throws CacheException when clear cache counted daily task by month at the time box is not open", () async {
    when(mockCountedDailyTaskBox.isOpen).thenReturn(false);

    final call = taskLocalDataSource.clearCachedDailyTask;

    expect(() => call(), throwsA(
      predicate((error) => error is CacheException)
    ));
    verify(mockCountedDailyTaskBox.isOpen);
    verifyNever(mockCountedDailyTaskBox.deleteAll(any));
  });
}