
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:crosscheck/features/task/domain/entities/combine_task_entity.dart';
import 'package:crosscheck/features/task/domain/entities/monthly_task_entity.dart';
import 'package:crosscheck/features/task/domain/entities/task_entity.dart';
import 'package:crosscheck/features/task/domain/repositories/task_respository.dart';
import 'package:crosscheck/features/task/domain/usecases/get_initial_task_by_date_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/utils.dart';
import 'get_initial_task_by_date_usecase_test.mocks.dart';

@GenerateMocks([
  AuthenticationRepository,
  TaskRepository
])
void main() {
  late MockAuthenticationRepository mockAuthenticationRepository;
  late MockTaskRepository mockTaskRepository;
  late GetInitialTaskByDateUsecase getInitialTaskByDateUsecase;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    mockAuthenticationRepository = MockAuthenticationRepository();
    getInitialTaskByDateUsecase = GetInitialTaskByDateUsecase(
        repository: mockTaskRepository,
        authenticationRepository: mockAuthenticationRepository);
  });

  test("Should returns initialized combine task by date properly", () async {
    final time = DateTime(2022, 7, 16);
    final List<MonthlyTaskEntity> mockedMonthlyTaskEntities = [];
    final List<TaskEntity> mockedTaskEntities = [];
    final CombineTaskEntity expectedResult = CombineTaskEntity(monthlyTaskEntities: mockedMonthlyTaskEntities, taskEntities: mockedTaskEntities);

    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getMonthlyTask(token: Utils.token, time: time)).thenAnswer((_) async => Right(mockedMonthlyTaskEntities));
    when(mockTaskRepository.getTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => Right(mockedTaskEntities));

    final result = await getInitialTaskByDateUsecase(time);
    
    expect(result, Right(expectedResult));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getTaskByDate(token: Utils.token, time: time));
    verify(mockTaskRepository.getMonthlyTask(token: Utils.token, time: time));
  });

  test("Should returns combine task by date properly", () async {
    final time = DateTime(2022, 7, 16);
    final List<MonthlyTaskEntity> mockedMonthlyTaskEntities = [
      MonthlyTaskEntity(id: "001", date: time, total: 2),
      MonthlyTaskEntity(id: "002", date: time.add(const Duration(days: 1)), total: 1),
      MonthlyTaskEntity(id: "003", date: time.add(const Duration(days: 2)), total: 5),
    ];
    final List<TaskEntity> mockedTaskEntities = [
      TaskEntity(id: "001", title: "Hello title", description: "Hello description", start: time.add(const Duration(hours: 6)), end: time.add(const Duration(hours: 8)), isAllDay: false, alerts: const []),
      TaskEntity(id: "002", title: "Hello title 2", description: "Hello description 2", start: time.add(const Duration(hours: 9)), end: time.add(const Duration(hours: 10)), isAllDay: false, alerts: const []),
    ];
    final CombineTaskEntity expectedResult = CombineTaskEntity(monthlyTaskEntities: mockedMonthlyTaskEntities, taskEntities: mockedTaskEntities);

    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getMonthlyTask(token: Utils.token, time: time)).thenAnswer((_) async => Right(mockedMonthlyTaskEntities));
    when(mockTaskRepository.getTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => Right(mockedTaskEntities));

    final result = await getInitialTaskByDateUsecase(time);
    
    expect(result, Right(expectedResult));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getTaskByDate(token: Utils.token, time: time));
    verify(mockTaskRepository.getMonthlyTask(token: Utils.token, time: time));
  });
  
  test("Should returns ServerFailure that contains combine task entity as its data when getTaskByDate returns ServerFailure", () async {
    final time = DateTime(2022, 7, 16);
    final List<MonthlyTaskEntity> mockedMonthlyTaskEntities = [
      MonthlyTaskEntity(id: "001", date: time, total: 2),
      MonthlyTaskEntity(id: "002", date: time.add(const Duration(days: 1)), total: 1),
      MonthlyTaskEntity(id: "003", date: time.add(const Duration(days: 2)), total: 5),
    ];
    final List<TaskEntity> mockedTaskEntities = [
      TaskEntity(id: "001", title: "Hello title", description: "Hello description", start: time.add(const Duration(hours: 6)), end: time.add(const Duration(hours: 8)), isAllDay: false, alerts: const []),
      TaskEntity(id: "002", title: "Hello title 2", description: "Hello description 2", start: time.add(const Duration(hours: 9)), end: time.add(const Duration(hours: 10)), isAllDay: false, alerts: const []),
    ];
    final CombineTaskEntity expectedResult = CombineTaskEntity(monthlyTaskEntities: mockedMonthlyTaskEntities, taskEntities: mockedTaskEntities);

    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getMonthlyTask(token: Utils.token, time: time)).thenAnswer((_) async => Right(mockedMonthlyTaskEntities));
    when(mockTaskRepository.getTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => Left(ServerFailure(message: Failure.generalError, data: mockedTaskEntities)));

    final result = await getInitialTaskByDateUsecase(time);
    
    expect(result, Left(ServerFailure(message: Failure.generalError, data: expectedResult)));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getTaskByDate(token: Utils.token, time: time));
    verify(mockTaskRepository.getMonthlyTask(token: Utils.token, time: time));
  });

  test("Should returns CacheFailure that contains combine task entity as its data when getTaskByDate returns CacheFailure", () async {
    final time = DateTime(2022, 7, 16);
    final List<MonthlyTaskEntity> mockedMonthlyTaskEntities = [
      MonthlyTaskEntity(id: "001", date: time, total: 2),
      MonthlyTaskEntity(id: "002", date: time.add(const Duration(days: 1)), total: 1),
      MonthlyTaskEntity(id: "003", date: time.add(const Duration(days: 2)), total: 5),
    ];
    final List<TaskEntity> mockedTaskEntities = [
      TaskEntity(id: "001", title: "Hello title", description: "Hello description", start: time.add(const Duration(hours: 6)), end: time.add(const Duration(hours: 8)), isAllDay: false, alerts: const []),
      TaskEntity(id: "002", title: "Hello title 2", description: "Hello description 2", start: time.add(const Duration(hours: 9)), end: time.add(const Duration(hours: 10)), isAllDay: false, alerts: const []),
    ];
    final CombineTaskEntity expectedResult = CombineTaskEntity(monthlyTaskEntities: mockedMonthlyTaskEntities, taskEntities: mockedTaskEntities);

    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getMonthlyTask(token: Utils.token, time: time)).thenAnswer((_) async => Right(mockedMonthlyTaskEntities));
    when(mockTaskRepository.getTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => Left(CacheFailure(message: Failure.cacheError, data: mockedTaskEntities)));

    final result = await getInitialTaskByDateUsecase(time);
    
    expect(result, Left(CacheFailure(message: Failure.cacheError, data: expectedResult)));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getTaskByDate(token: Utils.token, time: time));
    verify(mockTaskRepository.getMonthlyTask(token: Utils.token, time: time));
  });

  test("Should returns ServerFailure that contains combine task entity as its data when getMonthlyTask returns ServerFailure", () async {
    final time = DateTime(2022, 7, 16);
    final List<MonthlyTaskEntity> mockedMonthlyTaskEntities = [
      MonthlyTaskEntity(id: "001", date: time, total: 2),
      MonthlyTaskEntity(id: "002", date: time.add(const Duration(days: 1)), total: 1),
      MonthlyTaskEntity(id: "003", date: time.add(const Duration(days: 2)), total: 5),
    ];
    final List<TaskEntity> mockedTaskEntities = [
      TaskEntity(id: "001", title: "Hello title", description: "Hello description", start: time.add(const Duration(hours: 6)), end: time.add(const Duration(hours: 8)), isAllDay: false, alerts: const []),
      TaskEntity(id: "002", title: "Hello title 2", description: "Hello description 2", start: time.add(const Duration(hours: 9)), end: time.add(const Duration(hours: 10)), isAllDay: false, alerts: const []),
    ];
    final CombineTaskEntity expectedResult = CombineTaskEntity(monthlyTaskEntities: mockedMonthlyTaskEntities, taskEntities: mockedTaskEntities);

    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getMonthlyTask(token: Utils.token, time: time)).thenAnswer((_) async => Left(ServerFailure(message: Failure.generalError, data: mockedMonthlyTaskEntities)));
    when(mockTaskRepository.getTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => Right(mockedTaskEntities));

    final result = await getInitialTaskByDateUsecase(time);
    
    expect(result, Left(ServerFailure(message: Failure.generalError, data: expectedResult)));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getTaskByDate(token: Utils.token, time: time));
    verify(mockTaskRepository.getMonthlyTask(token: Utils.token, time: time));
  });

  test("Should returns CacheFailure that contains combine task entity as its data when getMonthlyTask returns CacheFailure", () async {
    final time = DateTime(2022, 7, 16);
    final List<MonthlyTaskEntity> mockedMonthlyTaskEntities = [
      MonthlyTaskEntity(id: "001", date: time, total: 2),
      MonthlyTaskEntity(id: "002", date: time.add(const Duration(days: 1)), total: 1),
      MonthlyTaskEntity(id: "003", date: time.add(const Duration(days: 2)), total: 5),
    ];
    final List<TaskEntity> mockedTaskEntities = [
      TaskEntity(id: "001", title: "Hello title", description: "Hello description", start: time.add(const Duration(hours: 6)), end: time.add(const Duration(hours: 8)), isAllDay: false, alerts: const []),
      TaskEntity(id: "002", title: "Hello title 2", description: "Hello description 2", start: time.add(const Duration(hours: 9)), end: time.add(const Duration(hours: 10)), isAllDay: false, alerts: const []),
    ];
    final CombineTaskEntity expectedResult = CombineTaskEntity(monthlyTaskEntities: mockedMonthlyTaskEntities, taskEntities: mockedTaskEntities);

    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getMonthlyTask(token: Utils.token, time: time)).thenAnswer((_) async => Left(CacheFailure(message: Failure.cacheError, data: mockedMonthlyTaskEntities)));
    when(mockTaskRepository.getTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => Right(mockedTaskEntities));

    final result = await getInitialTaskByDateUsecase(time);
    
    expect(result, Left(CacheFailure(message: Failure.cacheError, data: expectedResult)));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getTaskByDate(token: Utils.token, time: time));
    verify(mockTaskRepository.getMonthlyTask(token: Utils.token, time: time));
  });

  test("Should returns UnexpectedFailure that contains combine task entity as its data when getMonthlyTask and getTaskByDate returns Failure", () async {
    final time = DateTime(2022, 7, 16);
    final List<MonthlyTaskEntity> mockedMonthlyTaskEntities = [
      MonthlyTaskEntity(id: "001", date: time, total: 2),
      MonthlyTaskEntity(id: "002", date: time.add(const Duration(days: 1)), total: 1),
      MonthlyTaskEntity(id: "003", date: time.add(const Duration(days: 2)), total: 5),
    ];
    final List<TaskEntity> mockedTaskEntities = [
      TaskEntity(id: "001", title: "Hello title", description: "Hello description", start: time.add(const Duration(hours: 6)), end: time.add(const Duration(hours: 8)), isAllDay: false, alerts: const []),
      TaskEntity(id: "002", title: "Hello title 2", description: "Hello description 2", start: time.add(const Duration(hours: 9)), end: time.add(const Duration(hours: 10)), isAllDay: false, alerts: const []),
    ];
    final CombineTaskEntity expectedResult = CombineTaskEntity(monthlyTaskEntities: mockedMonthlyTaskEntities, taskEntities: mockedTaskEntities);

    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getMonthlyTask(token: Utils.token, time: time)).thenAnswer((_) async => Left(CacheFailure(message: Failure.cacheError, data: mockedMonthlyTaskEntities)));
    when(mockTaskRepository.getTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => Right(mockedTaskEntities));

    final result = await getInitialTaskByDateUsecase(time);
    
    expect(result, Left(CacheFailure(message: Failure.cacheError, data: expectedResult)));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getTaskByDate(token: Utils.token, time: time));
    verify(mockTaskRepository.getMonthlyTask(token: Utils.token, time: time));
  });


}