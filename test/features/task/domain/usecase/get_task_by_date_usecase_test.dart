
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:crosscheck/features/task/domain/entities/task_entity.dart';
import 'package:crosscheck/features/task/domain/repositories/task_respository.dart';
import 'package:crosscheck/features/task/domain/usecases/get_task_by_date_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/utils.dart';
import 'get_task_by_date_usecase_test.mocks.dart';

@GenerateMocks([
  TaskRepository,
  AuthenticationRepository
])
void main() {
  late MockTaskRepository mockTaskRepository;
  late MockAuthenticationRepository mockAuthenticationRepository;
  late GetTaskByDateUsecase getTaskByDateUsecase;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    mockAuthenticationRepository = MockAuthenticationRepository();
    getTaskByDateUsecase = GetTaskByDateUsecase(
      repository: mockTaskRepository, 
      authenticationRepository: mockAuthenticationRepository
    );
  });

  test("Should returns empty list of tasks properly when get task by date at the time data is still empty", () async {
    final time = DateTime(2022, 7, 16);
    final List<TaskEntity> expected = [];
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => Right(expected));
    
    final result = await getTaskByDateUsecase(time);
    
    expect(result, Right(expected));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getTaskByDate(token: Utils.token, time: time));
  });

  test("Should returns list of tasks properly when get task by date is success", () async {
    final time = DateTime(2022, 7, 16);
    final utils = Utils();
    final List<TaskEntity> expected = utils.getTaskEntities();
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => Right(expected));
    
    final result = await getTaskByDateUsecase(time);
  
    expect(result, Right(expected));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getTaskByDate(token: Utils.token, time: time));
  });

  test("Should returns ServerFailure when get token is failed that is caught by ServerFailure", () async {
    final time = DateTime(2022, 7, 16);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Left(ServerFailure(message: Failure.generalError)));
    
    final result = await getTaskByDateUsecase(time);
  
    expect(result, const Left(ServerFailure(message: Failure.generalError)));
    verify(mockAuthenticationRepository.getToken());
    verifyNever(mockTaskRepository.getTaskByDate(token: Utils.token, time: time));
  });

  test("Should returns CacheFailure when get token is failed that is caught by CacheFailure", () async {
    final time = DateTime(2022, 7, 16);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Left(CacheFailure(message: Failure.cacheError)));
    
    final result = await getTaskByDateUsecase(time);
  
    expect(result, const Left(CacheFailure(message: Failure.cacheError)));
    verify(mockAuthenticationRepository.getToken());
    verifyNever(mockTaskRepository.getHistory(any));
  });

  test("Should returns ServerFailure when get task by date is failed that is caught by ServerFailure", () async {
    final time = DateTime(2022, 7, 16);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => const Left(ServerFailure(message: Failure.generalError)));
    
    final result = await getTaskByDateUsecase(time);
  
    expect(result, const Left(ServerFailure(message: Failure.generalError)));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getTaskByDate(token: Utils.token, time: time));
  });

  test("Should returns CacheFailure when get history is failed that is caught by CacheFailure", () async {
    final time = DateTime(2022, 7, 16);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => const Left(CacheFailure(message: Failure.cacheError)));
    
    final result = await getTaskByDateUsecase(time);
  
    expect(result, const Left(CacheFailure(message: Failure.cacheError)));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getTaskByDate(token: Utils.token, time: time));
  });
}