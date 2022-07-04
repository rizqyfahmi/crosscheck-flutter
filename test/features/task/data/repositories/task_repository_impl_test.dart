
import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/network/network_info.dart';
import 'package:crosscheck/features/task/data/datasource/task_local_data_source.dart';
import 'package:crosscheck/features/task/data/datasource/task_remote_data_source.dart';
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
    when(mockTaskLocalDataSource.cacheHistory(any)).thenAnswer((_) async => Future.value());
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockTaskLocalDataSource.getCachedHistory()).thenAnswer((_) async => []);

    final result = await taskRepository.getHistory(Utils.token);

    expect(result.toString() == Right(Utils().taskModels).toString(), true);
    verify(mockTaskLocalDataSource.getCachedHistory());
    verify(mockNetworkInfo.isConnected);
    verify(mockTaskRemoteDataSource.getHistory(token: Utils.token));
    verify(mockTaskLocalDataSource.cacheHistory(any));
  });

  test("Should returns CacheFailure when set list of tasks(history) from remote into local data source returns CacheException", () async {
    when(mockTaskRemoteDataSource.getHistory(token: Utils.token)).thenAnswer((_) async => TaskResponseModel(message: Utils.successMessage, data: Utils().taskModels));
    when(mockTaskLocalDataSource.cacheHistory(any)).thenThrow(const CacheException(message: Failure.cacheError));
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockTaskLocalDataSource.getCachedHistory()).thenAnswer((_) async => []);

    final result = await taskRepository.getHistory(Utils.token);

    expect(result, const Left(CacheFailure(message: Failure.cacheError)));
    verify(mockTaskLocalDataSource.getCachedHistory());
    verify(mockNetworkInfo.isConnected);
    verify(mockTaskRemoteDataSource.getHistory(token: Utils.token));
    verify(mockTaskLocalDataSource.cacheHistory(any));
  });

  test("Should returns ServerFailure when get list of tasks(history) from remote data source returns ServerException", () async {
    when(mockTaskRemoteDataSource.getHistory(token: Utils.token)).thenThrow(const ServerException(message: Failure.generalError));
    when(mockTaskLocalDataSource.cacheHistory(any)).thenAnswer((_) async => Future.value());
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockTaskLocalDataSource.getCachedHistory()).thenAnswer((_) async => []);

    final result = await taskRepository.getHistory(Utils.token);

    expect(result, const Left(ServerFailure(message: Failure.generalError)));
    verify(mockTaskLocalDataSource.getCachedHistory());
    verify(mockNetworkInfo.isConnected);
    verify(mockTaskRemoteDataSource.getHistory(token: Utils.token));
    verifyNever(mockTaskLocalDataSource.cacheHistory(any));
  });

  test("Should returns empty list of task(history) properly when device is offline and the local data source is still empty", () async {
    when(mockTaskRemoteDataSource.getHistory(token: Utils.token)).thenAnswer((_) async => TaskResponseModel(message: Utils.successMessage, data: Utils().taskModels));
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    when(mockTaskLocalDataSource.getCachedHistory()).thenAnswer((_) async => []);
    when(mockTaskLocalDataSource.cacheHistory(any)).thenAnswer((_) async => Future.value());

    final result = await taskRepository.getHistory(Utils.token);

    expect(result.toString() == const Right([]).toString(), true);
    verify(mockTaskLocalDataSource.getCachedHistory());
    verify(mockNetworkInfo.isConnected);
    verifyNever(mockTaskRemoteDataSource.getHistory(token: Utils.token));
    verifyNever(mockTaskLocalDataSource.cacheHistory(any));
  });

  test("Should returns list of task(history) from local data source when the local data source is not empty", () async {
    when(mockTaskRemoteDataSource.getHistory(token: Utils.token)).thenAnswer((_) async => TaskResponseModel(message: Utils.successMessage, data: Utils().taskModels));
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockTaskLocalDataSource.getCachedHistory()).thenAnswer((_) async => Utils().taskModels);
    when(mockTaskLocalDataSource.cacheHistory(any)).thenAnswer((_) async => Future.value());

    final result = await taskRepository.getHistory(Utils.token);

    expect(result.toString() == Right(Utils().taskModels).toString(), true);
    verify(mockTaskLocalDataSource.getCachedHistory());
    verifyNever(mockNetworkInfo.isConnected);
    verifyNever(mockTaskRemoteDataSource.getHistory(token: Utils.token));
    verifyNever(mockTaskLocalDataSource.cacheHistory(any));
  });

  test("Should returns CacheFailure when get history list of tasks(history) from local data source returns CacheException", () async {
    when(mockTaskRemoteDataSource.getHistory(token: Utils.token)).thenAnswer((_) async => TaskResponseModel(message: Utils.successMessage, data: Utils().taskModels));
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockTaskLocalDataSource.getCachedHistory()).thenAnswer((_) async => Utils().taskModels);
    when(mockTaskLocalDataSource.cacheHistory(any)).thenAnswer((_) async => Future.value());

    final result = await taskRepository.getHistory(Utils.token);

    expect(result.toString() == Right(Utils().taskModels).toString(), true);
    verify(mockTaskLocalDataSource.getCachedHistory());
    verifyNever(mockNetworkInfo.isConnected);
    verifyNever(mockTaskRemoteDataSource.getHistory(token: Utils.token));
    verifyNever(mockTaskLocalDataSource.cacheHistory(any));
  });

  /*--------------------------------------------------- Get More History ---------------------------------------------------*/ 
  test("Should returns next/more list of tasks(history) from remote data source properly when device is online", () async {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockTaskLocalDataSource.getCachedHistory()).thenAnswer((_) async => Utils().taskModels);
    when(mockTaskLocalDataSource.cacheHistory(any)).thenAnswer((_) async => Future.value());
    when(mockTaskRemoteDataSource.getMoreHistory(token: Utils.token, limit: 10, offset: 10)).thenAnswer((_) async => TaskResponseModel(message: Utils.successMessage, data: Utils().moreTaskModels));

    final result = await taskRepository.getMoreHistory(Utils.token);

    expect(result.toString() == Right([...Utils().taskModels, ...Utils().moreTaskModels]).toString(), true);
    verify(mockTaskLocalDataSource.getCachedHistory());
    verify(mockNetworkInfo.isConnected);
    verify(mockTaskRemoteDataSource.getMoreHistory(token: Utils.token, limit: 10, offset: 10));
    verify(mockTaskLocalDataSource.cacheHistory(any));
  });

  test("Should returns CacheFailure when store combined latest local + more history from remote into local data source throws CacheException", () async {
    when(mockTaskLocalDataSource.getCachedHistory()).thenAnswer((_) async => Utils().taskModels);
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockTaskLocalDataSource.cacheHistory(any)).thenThrow(const CacheException(message: Failure.cacheError));
    when(mockTaskRemoteDataSource.getMoreHistory(token: Utils.token, limit: 10, offset: 10)).thenAnswer((_) async => TaskResponseModel(message: Utils.successMessage, data: Utils().moreTaskModels));

    final result = await taskRepository.getMoreHistory(Utils.token);

    expect(result, const Left(CacheFailure(message: Failure.cacheError)));
    verify(mockTaskLocalDataSource.getCachedHistory());
    verify(mockNetworkInfo.isConnected);
    verify(mockTaskRemoteDataSource.getMoreHistory(token: Utils.token, limit: 10, offset: 10));
    verify(mockTaskLocalDataSource.cacheHistory(any));
  });

  test("Should returns ServerFailure when get more history throws ServerException", () async {
    when(mockTaskLocalDataSource.getCachedHistory()).thenAnswer((_) async => Utils().taskModels);
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockTaskRemoteDataSource.getMoreHistory(token: Utils.token, limit: 10, offset: 10)).thenThrow(const ServerException(message: Failure.generalError));

    final result = await taskRepository.getMoreHistory(Utils.token);

    expect(result, const Left(ServerFailure(message: Failure.generalError)));
    verify(mockTaskLocalDataSource.getCachedHistory());
    verify(mockNetworkInfo.isConnected);
    verify(mockTaskRemoteDataSource.getMoreHistory(token: Utils.token, limit: 10, offset: 10));
    verifyNever(mockTaskLocalDataSource.cacheHistory(any));
  });

  test("Should returns NetworkFailure when device is offline", () async {
    when(mockTaskLocalDataSource.getCachedHistory()).thenAnswer((_) async => Utils().taskModels);
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

    final result = await taskRepository.getMoreHistory(Utils.token);
    expect(result.toString(), Left(NetworkFailure(message: Failure.networkError, data: Utils().taskModels)).toString());
    verify(mockTaskLocalDataSource.getCachedHistory());
    verify(mockNetworkInfo.isConnected);
    verifyNever(mockTaskRemoteDataSource.getMoreHistory(token: Utils.token, limit: 10, offset: 10));
    verifyNever(mockTaskLocalDataSource.cacheHistory(any));
  });

  test("Should retrun CacheFailure when get cached history throws CacheException", () async {
    when(mockTaskLocalDataSource.getCachedHistory()).thenThrow(const CacheException(message: Failure.cacheError));

    final result = await taskRepository.getMoreHistory(Utils.token);
    expect(result, const Left(CacheFailure(message: Failure.cacheError)));
    verify(mockTaskLocalDataSource.getCachedHistory());
    verifyNever(mockNetworkInfo.isConnected);
    verifyNever(mockTaskRemoteDataSource.getMoreHistory(token: Utils.token, limit: 10, offset: 10));
    verifyNever(mockTaskLocalDataSource.cacheHistory(any));
  });
}