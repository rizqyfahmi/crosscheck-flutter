import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:crosscheck/features/task/domain/repositories/task_respository.dart';
import 'package:crosscheck/features/task/domain/usecases/count_daily_task_by_month_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/utils.dart';
import 'count_daily_task_by_month_test.mocks.dart';

@GenerateMocks([
  AuthenticationRepository,
  TaskRepository
])
void main() {
  late MockAuthenticationRepository mockAuthenticationRepository;
  late MockTaskRepository mockTaskRepository;
  late CountDailyTaskByMonthUsecase countDailyTaskByMonth;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    mockTaskRepository = MockTaskRepository();
    countDailyTaskByMonth = CountDailyTaskByMonthUsecase(
      repository: mockTaskRepository,
      authenticationRepository: mockAuthenticationRepository
    );
  });

  test("Should get counted daily task properly", () async {
    final time = DateTime(2022, 7);
    final utils = Utils();
    final expected = utils.getCountedDailyTaskEntity(time: time);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.countDailyTaskByMonth(token: Utils.token, time: time)).thenAnswer((_) async => Right(expected));

    final result = await countDailyTaskByMonth(time);

    expect(result, Right(expected));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.countDailyTaskByMonth(token: Utils.token, time: time));
  });

  test("Should returns CacheFailure when get token returns CacheFailure", () async {
    final time = DateTime(2022, 7);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Left(CacheFailure(message: Failure.cacheError)));

    final result = await countDailyTaskByMonth(time);

    expect(result, const Left(CacheFailure(message: Failure.cacheError)));
    verify(mockAuthenticationRepository.getToken());
    verifyNever(mockTaskRepository.countDailyTaskByMonth(token: Utils.token, time: time));
  });

  test("Should returns ServerFailure when count daily task by month returns ServerFailure", () async {
    final time = DateTime(2022, 7);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.countDailyTaskByMonth(token: Utils.token, time: time)).thenAnswer((_) async => const Left(ServerFailure(message: Failure.generalError)));

    final result = await countDailyTaskByMonth(time);

    expect(result, const Left(ServerFailure(message: Failure.generalError)));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.countDailyTaskByMonth(token: Utils.token, time: time));
  });

  test("Should returns CacheFailure when count daily task by month returns CacheFailure", () async {
    final time = DateTime(2022, 7);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.countDailyTaskByMonth(token: Utils.token, time: time)).thenAnswer((_) async => const Left(CacheFailure(message: Failure.cacheError)));

    final result = await countDailyTaskByMonth(time);

    expect(result, const Left(CacheFailure(message: Failure.cacheError)));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.countDailyTaskByMonth(token: Utils.token, time: time));
  });
}
