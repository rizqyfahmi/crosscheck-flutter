import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:crosscheck/features/task/domain/repositories/task_respository.dart';
import 'package:crosscheck/features/task/domain/usecases/get_monthly_task_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/utils.dart';
import 'get_monthly_task_usecase_test.mocks.dart';

@GenerateMocks([
  AuthenticationRepository,
  TaskRepository
])
void main() {
  late MockAuthenticationRepository mockAuthenticationRepository;
  late MockTaskRepository mockTaskRepository;
  late GetMonthlyTaskUsecase getMonthlyTaskUsescase;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    mockTaskRepository = MockTaskRepository();
    getMonthlyTaskUsescase = GetMonthlyTaskUsecase(
      repository: mockTaskRepository,
      authenticationRepository: mockAuthenticationRepository
    );
  });

  test("Should get monthly task properly", () async {
    final time = DateTime(2022, 7);
    final utils = Utils();
    final expected = utils.getMonthlyTaskEntity(time: time);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getMonthlyTask(token: Utils.token, time: time)).thenAnswer((_) async => Right(expected));

    final result = await getMonthlyTaskUsescase(time);

    expect(result, Right(expected));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getMonthlyTask(token: Utils.token, time: time));
  });

  test("Should returns CacheFailure when get token returns CacheFailure", () async {
    final time = DateTime(2022, 7);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Left(CacheFailure(message: Failure.cacheError)));

    final result = await getMonthlyTaskUsescase(time);

    expect(result, const Left(CacheFailure(message: Failure.cacheError)));
    verify(mockAuthenticationRepository.getToken());
    verifyNever(mockTaskRepository.getMonthlyTask(token: Utils.token, time: time));
  });

  test("Should returns ServerFailure when monthly task returns ServerFailure", () async {
    final time = DateTime(2022, 7);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getMonthlyTask(token: Utils.token, time: time)).thenAnswer((_) async => const Left(ServerFailure(message: Failure.generalError)));

    final result = await getMonthlyTaskUsescase(time);

    expect(result, const Left(ServerFailure(message: Failure.generalError)));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getMonthlyTask(token: Utils.token, time: time));
  });

  test("Should returns CacheFailure when monthly task returns CacheFailure", () async {
    final time = DateTime(2022, 7);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getMonthlyTask(token: Utils.token, time: time)).thenAnswer((_) async => const Left(CacheFailure(message: Failure.cacheError)));

    final result = await getMonthlyTaskUsescase(time);

    expect(result, const Left(CacheFailure(message: Failure.cacheError)));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getMonthlyTask(token: Utils.token, time: time));
  });
}
