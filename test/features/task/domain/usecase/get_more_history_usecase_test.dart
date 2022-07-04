import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:crosscheck/features/task/domain/repositories/task_respository.dart';
import 'package:crosscheck/features/task/domain/usecases/get_more_history_usecase.dart';
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
  late GetMoreHistoryUsecase getMoreHistoryUsecase;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    mockAuthenticationRepository = MockAuthenticationRepository();
    getMoreHistoryUsecase = GetMoreHistoryUsecase(
      repository: mockTaskRepository,
      authenticationRepository: mockAuthenticationRepository
    );
  });

  test("Should returns next/more list of tasks(history) properly", () async {
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getMoreHistory(any)).thenAnswer((_) async => Right([...Utils().taskEntities, ...Utils().moreTaskModels]));

    final result = await getMoreHistoryUsecase(NoParam());

    expect(result.toString() == Right([...Utils().taskEntities, ...Utils().moreTaskModels]).toString(), true);
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getMoreHistory(any));
  });

  test("Should returns ServerFailure when get token is failed that is caught by ServerFailure", () async {
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Left(ServerFailure(message: Failure.generalError)));
    when(mockTaskRepository.getMoreHistory(any)).thenAnswer((_) async => Right(Utils().taskEntities));
    
    final result = await getMoreHistoryUsecase(NoParam());
  
    expect(result, const Left(ServerFailure(message: Failure.generalError)));
    verify(mockAuthenticationRepository.getToken());
    verifyNever(mockTaskRepository.getMoreHistory(any));
  });

  test("Should returns CacheFailure when get token is failed that is caught by CacheFailure", () async {
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Left(CacheFailure(message: Failure.cacheError)));
    when(mockTaskRepository.getMoreHistory(any)).thenAnswer((_) async => Right(Utils().taskEntities));
    
    final result = await getMoreHistoryUsecase(NoParam());
  
    expect(result, const Left(CacheFailure(message: Failure.cacheError)));
    verify(mockAuthenticationRepository.getToken());
    verifyNever(mockTaskRepository.getMoreHistory(any));
  });

  test("Should returns ServerFailure when get more history is failed that is caught by ServerFailure", () async {
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getMoreHistory(any)).thenAnswer((_) async => const Left(ServerFailure(message: Failure.generalError)));
    
    final result = await getMoreHistoryUsecase(NoParam());
  
    expect(result, const Left(ServerFailure(message: Failure.generalError)));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getMoreHistory(any));
  });

  test("Should returns CacheFailure when get more history is failed that is caught by CacheFailure", () async {
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getMoreHistory(any)).thenAnswer((_) async => const Left(CacheFailure(message: Failure.cacheError)));
    
    final result = await getMoreHistoryUsecase(NoParam());
  
    expect(result, const Left(CacheFailure(message: Failure.cacheError)));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getMoreHistory(any));
  });
}