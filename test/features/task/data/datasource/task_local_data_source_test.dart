import 'package:crosscheck/core/error/failure.dart';
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

  test("Should cache history properly", () async {
    when(mockBox.isOpen).thenReturn(true);
    when(mockBox.put(any, any)).thenAnswer((_) async => Future.value());

    await taskLocalDataSource.cacheHistory(Utils().taskModels);

    verify(mockBox.isOpen);
    verify(mockBox.put(any, any));
  });

  test("Should returns CacheFailure when cache history where box is not open", () async {
    when(mockBox.isOpen).thenReturn(false);
    when(mockBox.put(any, any)).thenAnswer((_) async => Future.value());

    final call = taskLocalDataSource.cacheHistory;

    expect(() => call(Utils().taskModels), throwsA(
      predicate((error) => error is CacheFailure)
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

  test("Should returns CacheFailure when get cached history where box is not open", () async {
    when(mockBox.isOpen).thenReturn(false);
    when(mockBox.values.toList()).thenReturn(Utils().taskModels);

    final call = taskLocalDataSource.getCachedHistory;

    expect(() => call(), throwsA(
      predicate((error) => error is CacheFailure)
    ));
    verify(mockBox.isOpen);
    verifyNever(mockBox.values.toList());
  });
}