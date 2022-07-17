import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:crosscheck/features/task/domain/repositories/task_respository.dart';
import 'package:crosscheck/features/task/domain/usecases/get_more_task_by_date_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/utils.dart';
import 'get_more_task_by_date_usecase_test.mocks.dart';

@GenerateMocks([
  TaskRepository,
  AuthenticationRepository
])
void main() {
  late MockTaskRepository mockTaskRepository;
  late MockAuthenticationRepository mockAuthenticationRepository;
  late GetMoreTaskByDateUsecase getMoreTaskByDateUsecase;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    mockAuthenticationRepository = MockAuthenticationRepository();
    getMoreTaskByDateUsecase = GetMoreTaskByDateUsecase(
      repository: mockTaskRepository,
      authenticationRepository: mockAuthenticationRepository
    );
  });

  test("Should returns next/more list of tasks properly when get more task by date", () async {
    final time = DateTime(2022, 7, 16);
    final expected = [...Utils().taskEntities, ...Utils().moreTaskModels];
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getMoreTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => Right(expected));

    final result = await getMoreTaskByDateUsecase(time);

    expect(result, Right(expected));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getMoreTaskByDate(token: Utils.token, time: time));
  });

  test("Should returns ServerFailure when get more task by date at the time get token is failed that is caught by ServerFailure", () async {
    final time = DateTime(2022, 7, 16);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Left(ServerFailure(message: Failure.generalError)));
    
    final result = await getMoreTaskByDateUsecase(time);
  
    expect(result, const Left(ServerFailure(message: Failure.generalError)));
    verify(mockAuthenticationRepository.getToken());
    verifyNever(mockTaskRepository.getMoreTaskByDate(token: Utils.token, time: time));
  });

  test("Should returns CacheFailure when get more task by date at the time get token is failed that is caught by CacheFailure", () async {
    final time = DateTime(2022, 7, 16);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Left(CacheFailure(message: Failure.cacheError)));
    
    final result = await getMoreTaskByDateUsecase(time);
  
    expect(result, const Left(CacheFailure(message: Failure.cacheError)));
    verify(mockAuthenticationRepository.getToken());
    verifyNever(mockTaskRepository.getMoreTaskByDate(token: Utils.token, time: time));
  });

  test("Should returns ServerFailure when get more task by date is failed that is caught by ServerFailure", () async {
    final time = DateTime(2022, 7, 16);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getMoreTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => const Left(ServerFailure(message: Failure.generalError)));
    
    final result = await getMoreTaskByDateUsecase(time);
  
    expect(result, const Left(ServerFailure(message: Failure.generalError)));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getMoreTaskByDate(token: Utils.token, time: time));
  });

  test("Should returns CacheFailure when get more task by date is failed that is caught by CacheFailure", () async {
    final time = DateTime(2022, 7, 16);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getMoreTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => const Left(CacheFailure(message: Failure.cacheError)));
    
    final result = await getMoreTaskByDateUsecase(time);
  
    expect(result, const Left(CacheFailure(message: Failure.cacheError)));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getMoreTaskByDate(token: Utils.token, time: time));
  });
}