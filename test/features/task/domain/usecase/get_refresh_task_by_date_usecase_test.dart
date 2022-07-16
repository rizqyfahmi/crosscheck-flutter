import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:crosscheck/features/task/domain/repositories/task_respository.dart';
import 'package:crosscheck/features/task/domain/usecases/get_refresh_history_usecase.dart';
import 'package:crosscheck/features/task/domain/usecases/get_refresh_task_by_date_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/utils.dart';
import 'get_more_history_usecase_test.mocks.dart';

@GenerateMocks([
  TaskRepository,
  AuthenticationRepository
])
void main() {
  late MockTaskRepository mockTaskRepository;
  late MockAuthenticationRepository mockAuthenticationRepository;
  late GetRefreshTaskByDateUsecase getRefreshTaskByDateUsecase;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    mockAuthenticationRepository = MockAuthenticationRepository();
    getRefreshTaskByDateUsecase = GetRefreshTaskByDateUsecase(
      repository: mockTaskRepository,
      authenticationRepository: mockAuthenticationRepository
    );
  });

  test("Should refresh list of tasks properly when get refresh task by date", () async {
    final time = DateTime(2022, 7, 16);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => Right(Utils().taskEntities));

    final result = await getRefreshTaskByDateUsecase(time);

    expect(result.toString(), Right(Utils().taskEntities).toString());
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time));
  });

  test("Should returns ServerFailure when get refresh task by date at the time get token is failed that is caught by ServerFailure", () async {
    final time = DateTime(2022, 7, 16);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Left(ServerFailure(message: Failure.generalError)));
    
    final result = await getRefreshTaskByDateUsecase(time);
  
    expect(result, const Left(ServerFailure(message: Failure.generalError)));
    verify(mockAuthenticationRepository.getToken());
    verifyNever(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time));
  });

  test("Should returns CacheFailure when get refresh task by date at the time get token is failed that is caught by CacheFailure", () async {
    final time = DateTime(2022, 7, 16);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Left(CacheFailure(message: Failure.cacheError)));
    
    final result = await getRefreshTaskByDateUsecase(time);
  
    expect(result, const Left(CacheFailure(message: Failure.cacheError)));
    verify(mockAuthenticationRepository.getToken());
    verifyNever(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time));
  });

  test("Should returns ServerFailure when get refresh task by date is failed that is caught by ServerFailure", () async {
    final time = DateTime(2022, 7, 16);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => const Left(ServerFailure(message: Failure.generalError)));
    
    final result = await getRefreshTaskByDateUsecase(time);
  
    expect(result, const Left(ServerFailure(message: Failure.generalError)));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time));
  });

  test("Should returns CacheFailure when get refresh task by date is failed that is caught by CacheFailure", () async {
    final time = DateTime(2022, 7, 16);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => const Left(CacheFailure(message: Failure.cacheError)));
    
    final result = await getRefreshTaskByDateUsecase(time);
  
    expect(result, const Left(CacheFailure(message: Failure.cacheError)));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time));
  });

}