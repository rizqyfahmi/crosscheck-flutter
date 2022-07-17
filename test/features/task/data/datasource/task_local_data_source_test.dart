import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/features/task/data/datasource/task_local_data_source.dart';
import 'package:crosscheck/features/task/data/models/data/monthly_task_model.dart';
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
  late MockBox<MonthlyTaskModel> mockMonthlyTaskBox;
  late TaskLocalDataSource taskLocalDataSource;

  setUp(() {
    mockBox = MockBox();
    mockMonthlyTaskBox = MockBox();
    taskLocalDataSource = TaskLocalDataSourceImpl(taskBox: mockBox, monthlyTaskBox: mockMonthlyTaskBox);
  });

  /*--------------------------------------------------- Get History ---------------------------------------------------*/
  test("Should cache all histories properly", () async {
    when(mockBox.isOpen).thenReturn(true);
    when(mockBox.put(any, any)).thenAnswer((_) async => Future.value());

    await taskLocalDataSource.cacheTask(Utils().taskModels);

    verify(mockBox.isOpen);
    verify(mockBox.put(any, any));
  });

  test("Should throws CacheException when cache all histories where box is not open", () async {
    when(mockBox.isOpen).thenReturn(false);

    final call = taskLocalDataSource.cacheTask;

    expect(() => call(Utils().taskModels), throwsA(
      predicate((error) => error is CacheException)
    ));
    verify(mockBox.isOpen);
    verifyNever(mockBox.put(any, any));
  });

  test("Should get cached history properly", () async {
    when(mockBox.isOpen).thenReturn(true);
    when(mockBox.values.toList()).thenReturn(Utils().taskModels);
    
    final result = await taskLocalDataSource.getCachedTask();

    expect(result, Utils().taskModels);
    verify(mockBox.isOpen);
    verify(mockBox.values.toList());
  });

  test("Should empty histories when get cached history where box is not open", () async {
    when(mockBox.isOpen).thenReturn(false);

    final result = await taskLocalDataSource.getCachedTask();

    expect(result, []);
    verify(mockBox.isOpen);
    verifyNever(mockBox.values.toList());
  });

  test("Should clear all cached histories properly", () async {
    when(mockBox.isOpen).thenReturn(true);
    when(mockBox.keys).thenReturn(["0", "1", "2"]);
    when(mockBox.deleteAll(any)).thenAnswer((_) async => Future.value());

    await taskLocalDataSource.clearCachedTask();
    verify(mockBox.isOpen);
    verify(mockBox.deleteAll(any));
  });

  test("Should throws CacheException when clear all cached histories where box is not open", () async {
    when(mockBox.isOpen).thenReturn(false);

    final call = taskLocalDataSource.clearCachedTask;

    expect(() => call(), throwsA(
      predicate((error) => error is CacheException)
    ));
    verify(mockBox.isOpen);
    verifyNever(mockBox.deleteAll(any));
  });

  /*--------------------------------------------------- Get Monthly Task ---------------------------------------------------*/
  test("Should cache monthly task properly", () async {
    final time = DateTime(2022, 7);
    final utils = Utils();
    final expected = utils.getMonthlyTaskModel(time: time);
    when(mockMonthlyTaskBox.isOpen).thenReturn(true);
    when(mockMonthlyTaskBox.put(any, any)).thenAnswer((_) async => Future.value());

    await taskLocalDataSource.cacheMonthlyTask(expected);

    verify(mockMonthlyTaskBox.isOpen);
    verify(mockMonthlyTaskBox.put(any, any));
  });

  test("Should throws CacheException when cache monthly task at the time box is not open", () async {
    final time = DateTime(2022, 7);
    final utils = Utils();
    final expected = utils.getMonthlyTaskModel(time: time);
    when(mockMonthlyTaskBox.isOpen).thenReturn(false);

    final call = taskLocalDataSource.cacheMonthlyTask;

    expect(() => call(expected), throwsA(
      predicate((error) => error is CacheException)
    ));
    verify(mockMonthlyTaskBox.isOpen);
    verifyNever(mockMonthlyTaskBox.put(any, any));
  });

  test("Should get cache monthly task properly", () async {
    final time = DateTime(2022, 7);
    final mocks = [
      MonthlyTaskModel(id: "01", date: DateTime(2022, 6, 15), total: 5),
      MonthlyTaskModel(id: "02", date: DateTime(2022, 7, 1), total: 8),
      MonthlyTaskModel(id: "03", date: DateTime(2022, 7, 8), total: 3),
      MonthlyTaskModel(id: "04", date: DateTime(2022, 7, 25), total: 7),
      MonthlyTaskModel(id: "05", date: DateTime(2022, 8, 5), total: 2),
    ];
    final expected = [
      MonthlyTaskModel(id: "02", date: DateTime(2022, 7, 1), total: 8),
      MonthlyTaskModel(id: "03", date: DateTime(2022, 7, 8), total: 3),
      MonthlyTaskModel(id: "04", date: DateTime(2022, 7, 25), total: 7),
    ];
    when(mockMonthlyTaskBox.isOpen).thenReturn(true);
    when(mockMonthlyTaskBox.values.toList()).thenReturn(mocks);
    
    final result = await taskLocalDataSource.getCacheMonthlyTask(time);

    expect(result, expected);
    verify(mockMonthlyTaskBox.isOpen);
    verify(mockMonthlyTaskBox.values.toList());
  });

  test("Should empty list when get cache monthly task at the time box is not open", () async {
    final time = DateTime(2022, 7);
    when(mockMonthlyTaskBox.isOpen).thenReturn(false);

    final result = await taskLocalDataSource.getCacheMonthlyTask(time);

    expect(result, []);
    verify(mockMonthlyTaskBox.isOpen);
    verifyNever(mockMonthlyTaskBox.values.toList());
  });

  test("Should clear cache monthly task properly", () async {
    when(mockMonthlyTaskBox.isOpen).thenReturn(true);
    when(mockMonthlyTaskBox.keys).thenReturn(["0", "1", "2"]);
    when(mockMonthlyTaskBox.deleteAll(any)).thenAnswer((_) async => Future.value());

    await taskLocalDataSource.clearCachedMonthlyTask();
    verify(mockMonthlyTaskBox.isOpen);
    verify(mockMonthlyTaskBox.deleteAll(any));
  });

  test("Should throws CacheException when clear cache monthly task at the time box is not open", () async {
    when(mockMonthlyTaskBox.isOpen).thenReturn(false);

    final call = taskLocalDataSource.clearCachedMonthlyTask;

    expect(() => call(), throwsA(
      predicate((error) => error is CacheException)
    ));
    verify(mockMonthlyTaskBox.isOpen);
    verifyNever(mockMonthlyTaskBox.deleteAll(any));
  });

  /*--------------------------------------------------- Get Task by Date ---------------------------------------------------*/
  test("Should get task by date properly", () async {
    final time = DateTime(2022, 7, 3);
    final mocks = [
      TaskModel(id: "01", title: "hello title 1", description: "hello description 1", start: DateTime(2022, 7, 1), end: DateTime(2022, 7, 3), isAllDay: false, alerts: const []),
      TaskModel(id: "02", title: "hello title 2", description: "hello description 2", start: DateTime(2022, 7, 1), end: DateTime(2022, 7, 5), isAllDay: false, alerts: const []),
      TaskModel(id: "03", title: "hello title 3", description: "hello description 3", start: DateTime(2022, 7, 3), end: DateTime(2022, 7, 6), isAllDay: false, alerts: const []),
      TaskModel(id: "04", title: "hello title 4", description: "hello description 4", start: DateTime(2022, 7, 4), end: DateTime(2022, 7, 10), isAllDay: false, alerts: const []),
      TaskModel(id: "05", title: "hello title 5", description: "hello description 5", start: DateTime(2022, 7, 6), end: DateTime(2022, 7, 10), isAllDay: false, alerts: const []),
    ];
    final expected = [
      TaskModel(id: "01", title: "hello title 1", description: "hello description 1", start: DateTime(2022, 7, 1), end: DateTime(2022, 7, 3), isAllDay: false, alerts: const []),
      TaskModel(id: "02", title: "hello title 2", description: "hello description 2", start: DateTime(2022, 7, 1), end: DateTime(2022, 7, 5), isAllDay: false, alerts: const []),
      TaskModel(id: "03", title: "hello title 3", description: "hello description 3", start: DateTime(2022, 7, 3), end: DateTime(2022, 7, 6), isAllDay: false, alerts: const []),
    ];
    when(mockBox.isOpen).thenReturn(true);
    when(mockBox.values.toList()).thenReturn(mocks);
    
    final result = await taskLocalDataSource.getCachedTaskByDate(time);

    expect(result, expected);
    verify(mockBox.isOpen);
    verify(mockBox.values.toList());
  });

  test("Should returns empty task when get cached task by date where box is not open", () async {
    final time = DateTime(2022, 7, 3);
    when(mockBox.isOpen).thenReturn(false);

    final result = await taskLocalDataSource.getCachedTaskByDate(time);

    expect(result, []);
    verify(mockBox.isOpen);
    verifyNever(mockBox.values.toList());
  });
}