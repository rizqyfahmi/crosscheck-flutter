import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/task/domain/usecases/get_history_usecase.dart';
import 'package:crosscheck/features/task/domain/usecases/get_more_history_usecase.dart';
import 'package:crosscheck/features/task/domain/usecases/get_refresh_history_usecase.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_bloc.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_event.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_model.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/utils.dart';
import 'task_bloc_test.mocks.dart';

@GenerateMocks([
  GetHistoryUsecase,
  GetMoreHistoryUsecase,
  GetRefreshHistoryUsecase
])
void main() {
  late MockGetHistoryUsecase mockGetHistoryUsecase;
  late MockGetMoreHistoryUsecase mockGetMoreHistoryUsecase;
  late MockGetRefreshHistoryUsecase mockGetRefreshHistoryUsecase;
  late TaskBloc taskBloc;
  late List<TaskModel> models;

  setUp(() {
    mockGetHistoryUsecase = MockGetHistoryUsecase();
    mockGetMoreHistoryUsecase = MockGetMoreHistoryUsecase();
    mockGetRefreshHistoryUsecase = MockGetRefreshHistoryUsecase();
    taskBloc = TaskBloc(
      getHistoryUsecase: mockGetHistoryUsecase, 
      getMoreHistoryUsecase: mockGetMoreHistoryUsecase, 
      getRefreshHistoryUsecase: mockGetRefreshHistoryUsecase
    );

    models = Utils().taskEntities.map((entity) => TaskModel.fromTaskEntity(entity)).toList();
  });

  test("Should returns TaskInit at first time", () {
    expect(taskBloc.state, TaskInit());
  });

  test("Should returns TaskIdle when close response/error dialog", () {
    taskBloc.add(TaskResetGeneralError());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskIdle(models: [])
    ]));
  });

  /*--------------------------------------------------- Get History ---------------------------------------------------*/ 
  test("Should returns TaskIdle when get history returns TaskEntity", () {
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async => Right(Utils().taskEntities));

    taskBloc.add(TaskGetHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: []),
      TaskLoaded(models: models),
      TaskIdle(models: models)
    ]));
  });

  test("Should returns TaskGeneralError when get history returns ServerFailure with no data", () {
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async => const Left(ServerFailure(message: Failure.generalError, data: [])));
    taskBloc.add(TaskGetHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: []),
      const TaskGeneralError(models: [], message: Failure.generalError)
    ]));
  });

  test("Should returns TaskGeneralError when get history returns CacheFailure with no data", () {
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async => const Left(CacheFailure(message: Failure.cacheError, data: [])));
    taskBloc.add(TaskGetHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: []),
      const TaskGeneralError(models: [], message: Failure.cacheError)
    ]));
  });

  test("Should returns TaskGeneralError when get history returns NetworkFailure with no data", () {
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async => const Left(NetworkFailure(message: Failure.networkError, data: [])));
    taskBloc.add(TaskGetHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: []),
      const TaskGeneralError(models: [], message: Failure.networkError)
    ]));
  });

  test("Should returns TaskGeneralError when get history returns ServerFailure with data", () {
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async => Left(ServerFailure(message: Failure.generalError, data: Utils().taskEntities)));
    taskBloc.add(TaskGetHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: []),
      TaskGeneralError(models: models, message: Failure.generalError)
    ]));
  });

  test("Should returns TaskGeneralError when get history returns CacheFailure with data", () {
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async => Left(CacheFailure(message: Failure.cacheError, data: Utils().taskEntities)));
    taskBloc.add(TaskGetHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: []),
      TaskGeneralError(models: models, message: Failure.cacheError)
    ]));
  });

  test("Should returns TaskGeneralError when get history returns NetworkFailure with data", () {
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async => Left(NetworkFailure(message: Failure.networkError, data: Utils().taskEntities)));
    taskBloc.add(TaskGetHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: []),
      TaskGeneralError(models: models, message: Failure.networkError)
    ]));
  });

  /*--------------------------------------------------- Get More History ---------------------------------------------------*/ 
  test("Should returns TaskIdle when get more history returns TaskEntity", () {
    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async => Right(Utils().taskEntities));

    taskBloc.add(TaskGetMoreHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: []),
      TaskLoaded(models: models),
      TaskIdle(models: models)
    ]));
  });

  test("Should returns TaskGeneralError when get more history returns ServerFailure with no data", () {
    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async => const Left(ServerFailure(message: Failure.generalError, data: [])));
    taskBloc.add(TaskGetMoreHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: []),
      const TaskGeneralError(models: [], message: Failure.generalError)
    ]));
  });

  test("Should returns TaskGeneralError when get more history returns CacheFailure with no data", () {
    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async => const Left(CacheFailure(message: Failure.cacheError, data: [])));
    taskBloc.add(TaskGetMoreHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: []),
      const TaskGeneralError(models: [], message: Failure.cacheError)
    ]));
  });

  test("Should returns TaskGeneralError when get more history returns NetworkFailure with no data", () {
    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async => const Left(NetworkFailure(message: Failure.networkError, data: [])));
    taskBloc.add(TaskGetMoreHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: []),
      const TaskGeneralError(models: [], message: Failure.networkError)
    ]));
  });

  test("Should returns TaskGeneralError when get more history returns ServerFailure with data", () {
    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async => Left(ServerFailure(message: Failure.generalError, data: Utils().taskEntities)));
    taskBloc.add(TaskGetMoreHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: []),
      TaskGeneralError(models: models, message: Failure.generalError)
    ]));
  });

  test("Should returns TaskGeneralError when get more history returns CacheFailure with data", () {
    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async => Left(CacheFailure(message: Failure.cacheError, data: Utils().taskEntities)));
    taskBloc.add(TaskGetMoreHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: []),
      TaskGeneralError(models: models, message: Failure.cacheError)
    ]));
  });

  test("Should returns TaskGeneralError when get more history returns NetworkFailure with data", () {
    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async => Left(NetworkFailure(message: Failure.networkError, data: Utils().taskEntities)));
    taskBloc.add(TaskGetMoreHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: []),
      TaskGeneralError(models: models, message: Failure.networkError)
    ]));
  });

  /*--------------------------------------------------- Get Refresh History ---------------------------------------------------*/ 
  test("Should returns TaskIdle when get refresh history returns TaskEntity", () {
    when(mockGetRefreshHistoryUsecase(any)).thenAnswer((_) async => Right(Utils().taskEntities));

    taskBloc.add(TaskGetRefreshHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: []),
      TaskLoaded(models: models),
      TaskIdle(models: models)
    ]));
  });

  test("Should returns TaskGeneralError when get refresh history returns ServerFailure with no data", () {
    when(mockGetRefreshHistoryUsecase(any)).thenAnswer((_) async => const Left(ServerFailure(message: Failure.generalError, data: [])));
    taskBloc.add(TaskGetRefreshHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: []),
      const TaskGeneralError(models: [], message: Failure.generalError)
    ]));
  });

  test("Should returns TaskGeneralError when get refresh history returns CacheFailure with no data", () {
    when(mockGetRefreshHistoryUsecase(any)).thenAnswer((_) async => const Left(CacheFailure(message: Failure.cacheError, data: [])));
    taskBloc.add(TaskGetRefreshHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: []),
      const TaskGeneralError(models: [], message: Failure.cacheError)
    ]));
  });

  test("Should returns TaskGeneralError when get refresh history returns NetworkFailure with no data", () {
    when(mockGetRefreshHistoryUsecase(any)).thenAnswer((_) async => const Left(NetworkFailure(message: Failure.networkError, data: [])));
    taskBloc.add(TaskGetRefreshHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: []),
      const TaskGeneralError(models: [], message: Failure.networkError)
    ]));
  });

  test("Should returns TaskGeneralError when get refresh history returns ServerFailure with data", () {
    when(mockGetRefreshHistoryUsecase(any)).thenAnswer((_) async => Left(ServerFailure(message: Failure.generalError, data: Utils().taskEntities)));
    taskBloc.add(TaskGetRefreshHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: []),
      TaskGeneralError(models: models, message: Failure.generalError)
    ]));
  });

  test("Should returns TaskGeneralError when get refresh history returns CacheFailure with data", () {
    when(mockGetRefreshHistoryUsecase(any)).thenAnswer((_) async => Left(CacheFailure(message: Failure.cacheError, data: Utils().taskEntities)));
    taskBloc.add(TaskGetRefreshHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: []),
      TaskGeneralError(models: models, message: Failure.cacheError)
    ]));
  });

  test("Should returns TaskGeneralError when get refresh history returns NetworkFailure with data", () {
    when(mockGetRefreshHistoryUsecase(any)).thenAnswer((_) async => Left(NetworkFailure(message: Failure.networkError, data: Utils().taskEntities)));
    taskBloc.add(TaskGetRefreshHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: []),
      TaskGeneralError(models: models, message: Failure.networkError)
    ]));
  });
}