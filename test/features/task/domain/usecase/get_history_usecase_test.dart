import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:crosscheck/features/task/domain/repositories/task_respository.dart';
import 'package:crosscheck/features/task/domain/usecases/get_history_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/utils.dart';
import 'get_history_usecase_test.mocks.dart';

@GenerateMocks([
  AuthenticationRepository,
  TaskRepository
])
void main() {
  late MockAuthenticationRepository mockAuthenticationRepository;
  late MockTaskRepository mockTaskRepository;
  late GetHistoryUsecase getHistoryUsecase;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    mockTaskRepository = MockTaskRepository();
    getHistoryUsecase = GetHistoryUsecase(repository: mockTaskRepository, authenticationRepository: mockAuthenticationRepository);
  });

  test("Should returns empty list of tasks (history) properly when get history is success where the data is still empty", () async {
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getHistory(any)).thenAnswer((_) async => const Right([]));
    
    final result = await getHistoryUsecase(NoParam());
  
    // can't compare Right<List<Object>> so that it needs to parse into string
    expect(result.toString() == const Right([]).toString(), true);
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getHistory(any));
  });

  test("Should returns list of tasks (history) properly when get history is success", () async {
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getHistory(any)).thenAnswer((_) async => Right(Utils().taskEntities));
    
    final result = await getHistoryUsecase(NoParam());
  
    // can't compare Right<List<Object>> so that it needs to parse into string
    expect(result.toString() == Right(Utils().taskEntities).toString(), true);
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getHistory(any));
  });

  test("Should returns ServerFailure when get token is failed that is caught by ServerFailure", () async {
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Left(ServerFailure(message: Failure.generalError)));
    when(mockTaskRepository.getHistory(any)).thenAnswer((_) async => Right(Utils().taskEntities));
    
    final result = await getHistoryUsecase(NoParam());
  
    expect(result, const Left(ServerFailure(message: Failure.generalError)));
    verify(mockAuthenticationRepository.getToken());
    verifyNever(mockTaskRepository.getHistory(any));
  });

  test("Should returns CacheFailure when get token is failed that is caught by CacheFailure", () async {
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Left(CacheFailure(message: Failure.cacheError)));
    when(mockTaskRepository.getHistory(any)).thenAnswer((_) async => Right(Utils().taskEntities));
    
    final result = await getHistoryUsecase(NoParam());
  
    expect(result, const Left(CacheFailure(message: Failure.cacheError)));
    verify(mockAuthenticationRepository.getToken());
    verifyNever(mockTaskRepository.getHistory(any));
  });

  test("Should returns ServerFailure when get history is failed that is caught by ServerFailure", () async {
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getHistory(any)).thenAnswer((_) async => const Left(ServerFailure(message: Failure.generalError)));
    
    final result = await getHistoryUsecase(NoParam());
  
    expect(result, const Left(ServerFailure(message: Failure.generalError)));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getHistory(any));
  });

  test("Should returns CacheFailure when get history is failed that is caught by CacheFailure", () async {
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getHistory(any)).thenAnswer((_) async => const Left(CacheFailure(message: Failure.cacheError)));
    
    final result = await getHistoryUsecase(NoParam());
  
    expect(result, const Left(CacheFailure(message: Failure.cacheError)));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getHistory(any));
  });
}