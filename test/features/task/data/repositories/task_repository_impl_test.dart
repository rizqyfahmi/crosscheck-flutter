
import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/network/network_info.dart';
import 'package:crosscheck/features/task/data/datasource/task_local_data_source.dart';
import 'package:crosscheck/features/task/data/datasource/task_remote_data_source.dart';
import 'package:crosscheck/features/task/data/models/response/monthly_task_response_model.dart';
import 'package:crosscheck/features/task/data/models/response/task_response_model.dart';
import 'package:crosscheck/features/task/data/repositories/task_repository_impl.dart';
import 'package:crosscheck/features/task/domain/repositories/task_respository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/utils.dart';
import 'task_repository_impl_test.mocks.dart';

@GenerateMocks([
  TaskRemoteDataSource,
  TaskLocalDataSource,
  NetworkInfo
])
void main() {
  late MockTaskRemoteDataSource mockTaskRemoteDataSource;
  late MockTaskLocalDataSource mockTaskLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late TaskRepository taskRepository;

  setUp(() {
    mockTaskRemoteDataSource = MockTaskRemoteDataSource();
    mockTaskLocalDataSource = MockTaskLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    taskRepository = TaskRepositoryImpl(
      remote: mockTaskRemoteDataSource,
      local: mockTaskLocalDataSource,
      networkInfo: mockNetworkInfo
    );
  });

  /*--------------------------------------------------- Get History ---------------------------------------------------*/ 
  test("Should returns list of task(history) from remote data source when device is online where the local data source is still empty", () async {
    when(mockTaskRemoteDataSource.getHistory(token: Utils.token)).thenAnswer((_) async => TaskResponseModel(message: Utils.successMessage, data: Utils().taskModels));
    when(mockTaskLocalDataSource.cacheTask(any)).thenAnswer((_) async => Future.value());
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockTaskLocalDataSource.getCachedTask()).thenAnswer((_) async => []);

    final result = await taskRepository.getHistory(Utils.token);

    expect(result.toString() == Right(Utils().taskModels).toString(), true);
    verify(mockTaskLocalDataSource.getCachedTask());
    verify(mockNetworkInfo.isConnected);
    verify(mockTaskRemoteDataSource.getHistory(token: Utils.token));
    verify(mockTaskLocalDataSource.cacheTask(any));
  });

  test("Should returns CacheFailure with empty histories as the latest cached data when set histories from remote into local data source throws CacheException", () async {
    when(mockTaskRemoteDataSource.getHistory(token: Utils.token)).thenAnswer((_) async => TaskResponseModel(message: Utils.successMessage, data: Utils().taskModels));
    when(mockTaskLocalDataSource.cacheTask(any)).thenThrow(const CacheException(message: Failure.cacheError));
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockTaskLocalDataSource.getCachedTask()).thenAnswer((_) async => []);

    final result = await taskRepository.getHistory(Utils.token);

    // "data" has empty list of tasks because the local data source would be empty when we call "taskRepository.getHistory(Utils.token)" for first time
    expect(result, const Left(CacheFailure(message: Failure.cacheError, data: [])));
    verify(mockTaskLocalDataSource.getCachedTask());
    verify(mockNetworkInfo.isConnected);
    verify(mockTaskRemoteDataSource.getHistory(token: Utils.token));
    verify(mockTaskLocalDataSource.cacheTask(any));
  });

  test("Should returns ServerFailure with empty histories as the latest cached data when get histories from remote data source throws ServerException", () async {
    when(mockTaskRemoteDataSource.getHistory(token: Utils.token)).thenThrow(const ServerException(message: Failure.generalError));
    when(mockTaskLocalDataSource.cacheTask(any)).thenAnswer((_) async => Future.value());
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockTaskLocalDataSource.getCachedTask()).thenAnswer((_) async => []);

    final result = await taskRepository.getHistory(Utils.token);

    // "data" has empty list of tasks because the local data source would be empty when we call "taskRepository.getHistory(Utils.token)" for first time
    expect(result, const Left(ServerFailure(message: Failure.generalError, data: [])));
    verify(mockTaskLocalDataSource.getCachedTask());
    verify(mockNetworkInfo.isConnected);
    verify(mockTaskRemoteDataSource.getHistory(token: Utils.token));
    verifyNever(mockTaskLocalDataSource.cacheTask(any));
  });

  test("Should returns NetworkFailure with empty list of task(history) properly when device is offline and the local data source is still empty", () async {
    when(mockTaskRemoteDataSource.getHistory(token: Utils.token)).thenAnswer((_) async => TaskResponseModel(message: Utils.successMessage, data: Utils().taskModels));
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    when(mockTaskLocalDataSource.getCachedTask()).thenAnswer((_) async => []);
    when(mockTaskLocalDataSource.cacheTask(any)).thenAnswer((_) async => Future.value());

    final result = await taskRepository.getHistory(Utils.token);

     // "data" has empty list of tasks because the local data source would be empty when we call "taskRepository.getHistory(Utils.token)" for first time
    expect(result, const Left(NetworkFailure(message: Failure.networkError, data: [])));
    verify(mockTaskLocalDataSource.getCachedTask());
    verify(mockNetworkInfo.isConnected);
    verifyNever(mockTaskRemoteDataSource.getHistory(token: Utils.token));
    verifyNever(mockTaskLocalDataSource.cacheTask(any));
  });

  test("Should returns list of task(history) from local data source when the local data source is not empty", () async {
    when(mockTaskRemoteDataSource.getHistory(token: Utils.token)).thenAnswer((_) async => TaskResponseModel(message: Utils.successMessage, data: Utils().taskModels));
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockTaskLocalDataSource.getCachedTask()).thenAnswer((_) async => Utils().taskModels);
    when(mockTaskLocalDataSource.cacheTask(any)).thenAnswer((_) async => Future.value());

    final result = await taskRepository.getHistory(Utils.token);

    expect(result.toString(), Right(Utils().taskModels).toString());
    verify(mockTaskLocalDataSource.getCachedTask());
    verifyNever(mockNetworkInfo.isConnected);
    verifyNever(mockTaskRemoteDataSource.getHistory(token: Utils.token));
    verifyNever(mockTaskLocalDataSource.cacheTask(any));
  });

  test("Should returns CacheFailure when get history histories from local data source returns CacheException", () async {
    when(mockTaskRemoteDataSource.getHistory(token: Utils.token)).thenAnswer((_) async => TaskResponseModel(message: Utils.successMessage, data: Utils().taskModels));
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockTaskLocalDataSource.getCachedTask()).thenAnswer((_) async => Utils().taskModels);
    when(mockTaskLocalDataSource.cacheTask(any)).thenAnswer((_) async => Future.value());

    final result = await taskRepository.getHistory(Utils.token);

    expect(result.toString() == Right(Utils().taskModels).toString(), true);
    verify(mockTaskLocalDataSource.getCachedTask());
    verifyNever(mockNetworkInfo.isConnected);
    verifyNever(mockTaskRemoteDataSource.getHistory(token: Utils.token));
    verifyNever(mockTaskLocalDataSource.cacheTask(any));
  });

  /*--------------------------------------------------- Get More History ---------------------------------------------------*/ 
  test("Should returns next/more histories from remote data source properly when device is online", () async {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockTaskLocalDataSource.getCachedTask()).thenAnswer((_) async => Utils().taskModels);
    when(mockTaskLocalDataSource.cacheTask(any)).thenAnswer((_) async => Future.value());
    when(mockTaskRemoteDataSource.getHistory(token: Utils.token, offset: 10)).thenAnswer((_) async => TaskResponseModel(message: Utils.successMessage, data: Utils().moreTaskModels));

    final result = await taskRepository.getMoreHistory(Utils.token);

    expect(result.toString() == Right([...Utils().taskModels, ...Utils().moreTaskModels]).toString(), true);
    verify(mockTaskLocalDataSource.getCachedTask());
    verify(mockNetworkInfo.isConnected);
    verify(mockTaskRemoteDataSource.getHistory(token: Utils.token, offset: 10));
    verify(mockTaskLocalDataSource.cacheTask(any));
  });

  test("Should returns CacheFailure when store combined latest local + more history from remote into local data source throws CacheException", () async {
    when(mockTaskLocalDataSource.getCachedTask()).thenAnswer((_) async => Utils().taskModels);
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockTaskLocalDataSource.cacheTask(any)).thenThrow(const CacheException(message: Failure.cacheError));
    when(mockTaskRemoteDataSource.getHistory(token: Utils.token, offset: 10)).thenAnswer((_) async => TaskResponseModel(message: Utils.successMessage, data: Utils().moreTaskModels));

    final result = await taskRepository.getMoreHistory(Utils.token);

    // "data" has list of tasks because the local data source would have been filled when we call "taskRepository.getMoreHistory(Utils.token)" by lazy load
    expect(result, Left(CacheFailure(message: Failure.cacheError, data: Utils().taskModels)));
    verify(mockTaskLocalDataSource.getCachedTask());
    verify(mockNetworkInfo.isConnected);
    verify(mockTaskRemoteDataSource.getHistory(token: Utils.token, offset: 10));
    verify(mockTaskLocalDataSource.cacheTask(any));
  });

  test("Should returns ServerFailure when get more history throws ServerException", () async {
    when(mockTaskLocalDataSource.getCachedTask()).thenAnswer((_) async => Utils().taskModels);
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockTaskRemoteDataSource.getHistory(token: Utils.token, offset: 10)).thenThrow(const ServerException(message: Failure.generalError));

    final result = await taskRepository.getMoreHistory(Utils.token);

    // "data" has list of tasks because the local data source would have been filled when we call "taskRepository.getMoreHistory(Utils.token)" by lazy load
    expect(result, Left(ServerFailure(message: Failure.generalError, data: Utils().taskModels)));
    verify(mockTaskLocalDataSource.getCachedTask());
    verify(mockNetworkInfo.isConnected);
    verify(mockTaskRemoteDataSource.getHistory(token: Utils.token, offset: 10));
    verifyNever(mockTaskLocalDataSource.cacheTask(any));
  });

  test("Should returns NetworkFailure when device is offline", () async {
    when(mockTaskLocalDataSource.getCachedTask()).thenAnswer((_) async => Utils().taskModels);
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

    final result = await taskRepository.getMoreHistory(Utils.token);

    // "data" has list of tasks because the local data source would have been filled when we call "taskRepository.getMoreHistory(Utils.token)" by lazy load
    expect(result, Left(NetworkFailure(message: Failure.networkError, data: Utils().taskModels)));
    verify(mockTaskLocalDataSource.getCachedTask());
    verify(mockNetworkInfo.isConnected);
    verifyNever(mockTaskRemoteDataSource.getHistory(token: Utils.token, offset: 10));
    verifyNever(mockTaskLocalDataSource.cacheTask(any));
  });

  /*--------------------------------------------------- Get Refresh History (empty cached data) ---------------------------------------------------*/ 
  test("Should returns refreshed histories properly when get cached history returns empty histories", () async {
    when(mockTaskLocalDataSource.getCachedTask()).thenAnswer((_) async => []);
    when(mockTaskLocalDataSource.clearCachedTask()).thenAnswer((_) async => Future.value());
    when(mockTaskRemoteDataSource.getHistory(token: Utils.token)).thenAnswer((_) async => TaskResponseModel(message: Utils.successMessage, data: Utils().taskModels));
    when(mockTaskLocalDataSource.cacheTask(any)).thenAnswer((_) async => Future.value());

    final result = await taskRepository.getRefreshHistory(Utils.token);

    expect(result.toString(), Right(Utils().taskModels).toString());
    verify(mockTaskLocalDataSource.getCachedTask());
    verify(mockTaskLocalDataSource.clearCachedTask());
    verify(mockTaskRemoteDataSource.getHistory(token: Utils.token));
    verify(mockTaskLocalDataSource.cacheTask(any));
  });

  test("Should returns CacheFailure with empty histories when set/cache history throws CacheException and get cached history returns empty histories", () async {
    when(mockTaskLocalDataSource.getCachedTask()).thenAnswer((_) async => []);
    when(mockTaskLocalDataSource.clearCachedTask()).thenAnswer((_) async => Future.value());
    when(mockTaskRemoteDataSource.getHistory(token: Utils.token)).thenAnswer((_) async => TaskResponseModel(message: Utils.successMessage, data: Utils().taskModels));
    when(mockTaskLocalDataSource.cacheTask(any)).thenThrow(const CacheException(message: Failure.cacheError));

    final result = await taskRepository.getRefreshHistory(Utils.token);

    expect(result, const Left(CacheFailure(message: Failure.cacheError, data: [])));
    verify(mockTaskLocalDataSource.getCachedTask());
    verify(mockTaskLocalDataSource.clearCachedTask());
    verify(mockTaskRemoteDataSource.getHistory(token: Utils.token));
    verify(mockTaskLocalDataSource.cacheTask(any));
  });

  test("Should returns ServerFailure with empty histories when get history from remote data source throws ServerException and and get cached history returns empty histories", () async {
    when(mockTaskLocalDataSource.getCachedTask()).thenAnswer((_) async => []);
    when(mockTaskLocalDataSource.clearCachedTask()).thenAnswer((_) async => Future.value());
    when(mockTaskRemoteDataSource.getHistory(token: Utils.token)).thenThrow(const ServerException(message: Failure.generalError));

    final result = await taskRepository.getRefreshHistory(Utils.token);

    expect(result, const Left(ServerFailure(message: Failure.generalError, data: [])));
    verify(mockTaskLocalDataSource.getCachedTask());
    verify(mockTaskLocalDataSource.clearCachedTask());
    verify(mockTaskRemoteDataSource.getHistory(token: Utils.token));
    verifyNever(mockTaskLocalDataSource.cacheTask(any));
  });

  test("Should returns ServerFailure with empty histories when clear cached histories throws CacheException and and get cached history returns empty histories", () async {
    when(mockTaskLocalDataSource.getCachedTask()).thenAnswer((_) async => []);
    when(mockTaskLocalDataSource.clearCachedTask()).thenThrow(const CacheException(message: Failure.cacheError));

    final result = await taskRepository.getRefreshHistory(Utils.token);

    expect(result, const Left(CacheFailure(message: Failure.cacheError, data: [])));
    verify(mockTaskLocalDataSource.getCachedTask());
    verify(mockTaskLocalDataSource.clearCachedTask());
    verifyNever(mockTaskRemoteDataSource.getHistory(token: Utils.token));
    verifyNever(mockTaskLocalDataSource.cacheTask(any));
  });

  /*--------------------------------------------------- Get Refresh History (not empty cached data) ---------------------------------------------------*/ 
  test("Should returns refreshed histories properly when get cached history returns not empty histories", () async {
    when(mockTaskLocalDataSource.getCachedTask()).thenAnswer((_) async => Utils().taskModels);
    when(mockTaskLocalDataSource.clearCachedTask()).thenAnswer((_) async => Future.value());
    when(mockTaskRemoteDataSource.getHistory(token: Utils.token)).thenAnswer((_) async => TaskResponseModel(message: Utils.successMessage, data: Utils().taskModels));
    when(mockTaskLocalDataSource.cacheTask(any)).thenAnswer((_) async => Future.value());

    final result = await taskRepository.getRefreshHistory(Utils.token);

    expect(result.toString(), Right(Utils().taskModels).toString());
    verify(mockTaskLocalDataSource.getCachedTask());
    verify(mockTaskLocalDataSource.clearCachedTask());
    verify(mockTaskRemoteDataSource.getHistory(token: Utils.token));
    verify(mockTaskLocalDataSource.cacheTask(any));
  });

  test("Should returns CacheFailure with empty histories when set/cache history throws CacheException and get cached history returns not empty histories", () async {
    when(mockTaskLocalDataSource.getCachedTask()).thenAnswer((_) async => Utils().taskModels);
    when(mockTaskLocalDataSource.clearCachedTask()).thenAnswer((_) async => Future.value());
    when(mockTaskRemoteDataSource.getHistory(token: Utils.token)).thenAnswer((_) async => TaskResponseModel(message: Utils.successMessage, data: Utils().taskModels));
    when(mockTaskLocalDataSource.cacheTask(any)).thenThrow(const CacheException(message: Failure.cacheError));

    final result = await taskRepository.getRefreshHistory(Utils.token);

    expect(result, Left(CacheFailure(message: Failure.cacheError, data: Utils().taskModels)));
    verify(mockTaskLocalDataSource.getCachedTask());
    verify(mockTaskLocalDataSource.clearCachedTask());
    verify(mockTaskRemoteDataSource.getHistory(token: Utils.token));
    verify(mockTaskLocalDataSource.cacheTask(any));
  });

  test("Should returns ServerFailure with empty histories when get history from remote data source throws ServerException and and get cached history returns not empty histories", () async {
    when(mockTaskLocalDataSource.getCachedTask()).thenAnswer((_) async => Utils().taskModels);
    when(mockTaskLocalDataSource.clearCachedTask()).thenAnswer((_) async => Future.value());
    when(mockTaskRemoteDataSource.getHistory(token: Utils.token)).thenThrow(const ServerException(message: Failure.generalError));

    final result = await taskRepository.getRefreshHistory(Utils.token);

    expect(result, Left(ServerFailure(message: Failure.generalError, data: Utils().taskModels)));
    verify(mockTaskLocalDataSource.getCachedTask());
    verify(mockTaskLocalDataSource.clearCachedTask());
    verify(mockTaskRemoteDataSource.getHistory(token: Utils.token));
    verifyNever(mockTaskLocalDataSource.cacheTask(any));
  });

  test("Should returns ServerFailure with empty histories when clear cached histories throws CacheException and and get cached history returns not empty histories", () async {
    when(mockTaskLocalDataSource.getCachedTask()).thenAnswer((_) async => Utils().taskModels);
    when(mockTaskLocalDataSource.clearCachedTask()).thenThrow(const CacheException(message: Failure.cacheError));

    final result = await taskRepository.getRefreshHistory(Utils.token);

    expect(result, Left(CacheFailure(message: Failure.cacheError, data: Utils().taskModels)));
    verify(mockTaskLocalDataSource.getCachedTask());
    verify(mockTaskLocalDataSource.clearCachedTask());
    verifyNever(mockTaskRemoteDataSource.getHistory(token: Utils.token));
    verifyNever(mockTaskLocalDataSource.cacheTask(any));
  });

  /*--------------------------------------------------- Get Monthly Task ---------------------------------------------------*/
  test("Should monthly task from remote and cache its data into local properly", () async {
    final time = DateTime(2022, 7);
    final utils = Utils();
    final expected = utils.getMonthlyTaskModel(time: time);
    when(mockTaskLocalDataSource.getCacheMonthlyTask()).thenAnswer((_) async => []);
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockTaskRemoteDataSource.getMonthlyTask(token: Utils.token, time: time)).thenAnswer((_) async => MonthlyTaskResponseModel(message: Utils.successMessage, data: expected));
    when(mockTaskLocalDataSource.cacheMonthlyTask(expected)).thenAnswer((_) async => Future.value());

    final result = await taskRepository.getMonthlyTask(token: Utils.token, time: time);
    expect(result, Right(expected));

    verify(mockNetworkInfo.isConnected);
    verify(mockTaskLocalDataSource.getCacheMonthlyTask());
    verify(mockTaskRemoteDataSource.getMonthlyTask(token: Utils.token, time: time));
    verify(mockTaskLocalDataSource.cacheMonthlyTask(expected));
  });

  test("Should returns CacheFailure when cache count daily task returns CacheException", () async {
    final time = DateTime(2022, 7);
    final utils = Utils();
    final expected = utils.getMonthlyTaskModel(time: time);
    when(mockTaskLocalDataSource.getCacheMonthlyTask()).thenAnswer((_) async => []);
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockTaskRemoteDataSource.getMonthlyTask(token: Utils.token, time: time)).thenAnswer((_) async => MonthlyTaskResponseModel(message: Utils.successMessage, data: expected));
    when(mockTaskLocalDataSource.cacheMonthlyTask(expected)).thenThrow(const CacheException(message: Failure.cacheError));

    final result = await taskRepository.getMonthlyTask(token: Utils.token, time: time);
    expect(result, const Left(CacheFailure(message: Failure.cacheError, data: [])));
    
    verify(mockNetworkInfo.isConnected);
    verify(mockTaskLocalDataSource.getCacheMonthlyTask());
    verify(mockTaskRemoteDataSource.getMonthlyTask(token: Utils.token, time: time));
    verify(mockTaskLocalDataSource.cacheMonthlyTask(expected));
  });

  test("Should returns CacheFailure with latest local data when cache count daily task returns CacheException", () async {
    final time = DateTime(2022, 7);
    final utils = Utils();
    final expected = utils.getMonthlyTaskModel(time: time);
    when(mockTaskLocalDataSource.getCacheMonthlyTask()).thenAnswer((_) async => expected);
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockTaskRemoteDataSource.getMonthlyTask(token: Utils.token, time: time)).thenAnswer((_) async => MonthlyTaskResponseModel(message: Utils.successMessage, data: expected));
    when(mockTaskLocalDataSource.cacheMonthlyTask(expected)).thenThrow(const CacheException(message: Failure.cacheError));

    final result = await taskRepository.getMonthlyTask(token: Utils.token, time: time);
    expect(result, Left(CacheFailure(message: Failure.cacheError, data: expected)));
    
    verify(mockNetworkInfo.isConnected);
    verify(mockTaskLocalDataSource.getCacheMonthlyTask());
    verify(mockTaskRemoteDataSource.getMonthlyTask(token: Utils.token, time: time));
    verify(mockTaskLocalDataSource.cacheMonthlyTask(expected));
  });

  test("Should returns ServerFailure when cache count daily task returns ServerException", () async {
    final time = DateTime(2022, 7);
    final utils = Utils();
    final expected = utils.getMonthlyTaskModel(time: time);
    when(mockTaskLocalDataSource.getCacheMonthlyTask()).thenAnswer((_) async => []);
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockTaskRemoteDataSource.getMonthlyTask(token: Utils.token, time: time)).thenThrow(const ServerException(message: Failure.generalError));

    final result = await taskRepository.getMonthlyTask(token: Utils.token, time: time);
    expect(result, const Left(ServerFailure(message: Failure.generalError, data: [])));
    
    verify(mockNetworkInfo.isConnected);
    verify(mockTaskLocalDataSource.getCacheMonthlyTask());
    verify(mockTaskRemoteDataSource.getMonthlyTask(token: Utils.token, time: time));
    verifyNever(mockTaskLocalDataSource.cacheMonthlyTask(expected));
  });

  test("Should returns ServerFailure with latest local data when cache count daily task returns ServerException", () async {
    final time = DateTime(2022, 7);
    final utils = Utils();
    final expected = utils.getMonthlyTaskModel(time: time);
    when(mockTaskLocalDataSource.getCacheMonthlyTask()).thenAnswer((_) async => expected);
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockTaskRemoteDataSource.getMonthlyTask(token: Utils.token, time: time)).thenThrow(const ServerException(message: Failure.generalError));

    final result = await taskRepository.getMonthlyTask(token: Utils.token, time: time);
    expect(result, Left(ServerFailure(message: Failure.generalError, data: expected)));
    
    verify(mockNetworkInfo.isConnected);
    verify(mockTaskLocalDataSource.getCacheMonthlyTask());
    verify(mockTaskRemoteDataSource.getMonthlyTask(token: Utils.token, time: time));
    verifyNever(mockTaskLocalDataSource.cacheMonthlyTask(expected));
  });

  test("Should returns NetworkFailure when get count task by month at the time device is offline", () async {
    final time = DateTime(2022, 7);
    final utils = Utils();
    final expected = utils.getMonthlyTaskModel(time: time);
    when(mockTaskLocalDataSource.getCacheMonthlyTask()).thenAnswer((_) async => []);
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    
    final result = await taskRepository.getMonthlyTask(token: Utils.token, time: time);
    expect(result, const Left(NetworkFailure(message: Failure.networkError, data: [])));
    
    verify(mockNetworkInfo.isConnected);
    verify(mockTaskLocalDataSource.getCacheMonthlyTask());
    verifyNever(mockTaskRemoteDataSource.getMonthlyTask(token: Utils.token, time: time));
    verifyNever(mockTaskLocalDataSource.cacheMonthlyTask(expected));
  });

  test("Should returns NetworkFailure with latest local data when get count task by month at the time device is offline", () async {
    final time = DateTime(2022, 7);
    final utils = Utils();
    final expected = utils.getMonthlyTaskModel(time: time);
    when(mockTaskLocalDataSource.getCacheMonthlyTask()).thenAnswer((_) async => expected);
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    
    final result = await taskRepository.getMonthlyTask(token: Utils.token, time: time);
    expect(result, Left(NetworkFailure(message: Failure.networkError, data: expected)));
    
    verify(mockNetworkInfo.isConnected);
    verify(mockTaskLocalDataSource.getCacheMonthlyTask());
    verifyNever(mockTaskRemoteDataSource.getMonthlyTask(token: Utils.token, time: time));
    verifyNever(mockTaskLocalDataSource.cacheMonthlyTask(expected));
  });

  /*--------------------------------------------------- Get Task by Date ---------------------------------------------------*/ 
  test("Should returns list of task from remote data source when the local data source is still empty at the time device is online", () async {
    final time = DateTime(2022, 7);
    final expected = Utils().taskModels;
    when(mockTaskRemoteDataSource.getTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => TaskResponseModel(message: Utils.successMessage, data: expected));
    when(mockTaskLocalDataSource.cacheTask(any)).thenAnswer((_) async => Future.value());
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockTaskLocalDataSource.getTaskByDate(time)).thenAnswer((_) async => []);

    final result = await taskRepository.getTaskByDate(token: Utils.token, time: time);

    expect(result, Right(expected));
    verify(mockTaskLocalDataSource.getTaskByDate(time));
    verify(mockNetworkInfo.isConnected);
    verify(mockTaskRemoteDataSource.getTaskByDate(token: Utils.token, time: time));
    verify(mockTaskLocalDataSource.cacheTask(any));
  });

  test("Should returns CacheFailure with empty tasks as the latest cached data when set tasks from remote into local data source throws CacheException", () async {
    final time = DateTime(2022, 7);
    final expected = Utils().taskModels;
    when(mockTaskRemoteDataSource.getTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => TaskResponseModel(message: Utils.successMessage, data: expected));
    when(mockTaskLocalDataSource.cacheTask(any)).thenThrow(const CacheException(message: Failure.cacheError));
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockTaskLocalDataSource.getTaskByDate(time)).thenAnswer((_) async => []);

    final result = await taskRepository.getTaskByDate(token: Utils.token, time: time);

    // "data" has empty list of tasks because the local data source would be empty when we call "taskRepository.getTaskByDate" for first time
    expect(result, const Left(CacheFailure(message: Failure.cacheError, data: [])));
    verify(mockTaskLocalDataSource.getTaskByDate(time));
    verify(mockNetworkInfo.isConnected);
    verify(mockTaskRemoteDataSource.getTaskByDate(token: Utils.token, time: time));
    verify(mockTaskLocalDataSource.cacheTask(any));
  });

  test("Should returns ServerFailure with empty tasks as the latest cached data when get tasks from remote data source throws ServerException", () async {
    final time = DateTime(2022, 7);
    when(mockTaskRemoteDataSource.getTaskByDate(token: Utils.token, time: time)).thenThrow(const ServerException(message: Failure.generalError));
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockTaskLocalDataSource.getTaskByDate(time)).thenAnswer((_) async => []);

    final result = await taskRepository.getTaskByDate(token: Utils.token, time: time);

    // "data" has empty list of tasks because the local data source would be empty when we call "taskRepository.getTaskByDate" for first time
    expect(result, const Left(ServerFailure(message: Failure.generalError, data: [])));
    verify(mockTaskLocalDataSource.getTaskByDate(time));
    verify(mockNetworkInfo.isConnected);
    verify(mockTaskRemoteDataSource.getTaskByDate(token: Utils.token, time: time));
    verifyNever(mockTaskLocalDataSource.cacheTask(any));
  });

  test("Should returns NetworkFailure with empty tasks properly when device is offline and the local data source is still empty", () async {
    final time = DateTime(2022, 7);
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    when(mockTaskLocalDataSource.getTaskByDate(time)).thenAnswer((_) async => []);
    
    final result = await taskRepository.getTaskByDate(token: Utils.token, time: time);

     // "data" has empty list of tasks because the local data source would be empty when we call "taskRepository.getTaskByDate" for first time
    expect(result, const Left(NetworkFailure(message: Failure.networkError, data: [])));
    verify(mockTaskLocalDataSource.getTaskByDate(time));
    verify(mockNetworkInfo.isConnected);
    verifyNever(mockTaskRemoteDataSource.getTaskByDate(token: Utils.token, time: time));
    verifyNever(mockTaskLocalDataSource.cacheTask(any));
  });
}