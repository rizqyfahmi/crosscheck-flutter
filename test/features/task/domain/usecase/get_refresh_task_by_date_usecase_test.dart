import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:crosscheck/features/task/domain/entities/combine_task_entity.dart';
import 'package:crosscheck/features/task/domain/entities/monthly_task_entity.dart';
import 'package:crosscheck/features/task/domain/entities/task_entity.dart';
import 'package:crosscheck/features/task/domain/repositories/task_respository.dart';
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
  late DateTime time;
  late List<MonthlyTaskEntity> mockedMonthlyTaskEntities;
  late List<TaskEntity> mockedTaskEntities;
  late CombineTaskEntity expectedResult;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    mockAuthenticationRepository = MockAuthenticationRepository();
    getRefreshTaskByDateUsecase = GetRefreshTaskByDateUsecase(
      repository: mockTaskRepository,
      authenticationRepository: mockAuthenticationRepository
    );

    time = DateTime(2022, 7, 16);
    mockedMonthlyTaskEntities = [
      MonthlyTaskEntity(id: "001", date: time, total: 2),
      MonthlyTaskEntity(id: "002", date: time.add(const Duration(days: 1)), total: 1),
      MonthlyTaskEntity(id: "003", date: time.add(const Duration(days: 2)), total: 5),
    ];
    mockedTaskEntities = [
      TaskEntity(id: "001", title: "Hello title", description: "Hello description", start: time.add(const Duration(hours: 6)), end: time.add(const Duration(hours: 8)), isAllDay: false, alerts: const []),
      TaskEntity(id: "002", title: "Hello title 2", description: "Hello description 2", start: time.add(const Duration(hours: 9)), end: time.add(const Duration(hours: 10)), isAllDay: false, alerts: const []),
    ];
    expectedResult = CombineTaskEntity(monthlyTaskEntities: mockedMonthlyTaskEntities, taskEntities: mockedTaskEntities);
  });

  test("Should get refresh task by date properly", () async {
    final time = DateTime(2022, 7, 16);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getRefreshMonthlyTask(token: Utils.token, time: time)).thenAnswer((_) async => Right(mockedMonthlyTaskEntities));
    when(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => Right(mockedTaskEntities));

    final result = await getRefreshTaskByDateUsecase(time);

    expect(result, Right(expectedResult));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getRefreshMonthlyTask(token: Utils.token, time: time));
    verify(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time));
  });

  test("Should returns ServerFailure when get token is failed returns ServerFailure", () async {
    final time = DateTime(2022, 7, 16);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Left(ServerFailure(message: Failure.generalError)));
    
    final result = await getRefreshTaskByDateUsecase(time);
  
    expect(result, const Left(ServerFailure(message: Failure.generalError)));
    verify(mockAuthenticationRepository.getToken());
    verifyNever(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time));
  });

  test("Should returns CacheFailure when get token is failed returns CacheFailure", () async {
    final time = DateTime(2022, 7, 16);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Left(CacheFailure(message: Failure.cacheError)));
    
    final result = await getRefreshTaskByDateUsecase(time);
  
    expect(result, const Left(CacheFailure(message: Failure.cacheError)));
    verify(mockAuthenticationRepository.getToken());
    verifyNever(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time));
  });

  test("Should returns ServerFailure when get refresh task by date returns ServerFailure", () async {
    final time = DateTime(2022, 7, 16);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getRefreshMonthlyTask(token: Utils.token, time: time)).thenAnswer((_) async => Right(mockedMonthlyTaskEntities));
    when(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => const Left(ServerFailure(message: Failure.generalError, data: [])));
    
    final result = await getRefreshTaskByDateUsecase(time);
  
    expect(result, Left(ServerFailure(message: Failure.generalError, data: CombineTaskEntity(monthlyTaskEntities: mockedMonthlyTaskEntities, taskEntities: const []))));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getRefreshMonthlyTask(token: Utils.token, time: time));
    verify(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time));
  });

  test("Should returns ServerFailure when get refresh task by date returns ServerFailure with data", () async {
    final time = DateTime(2022, 7, 16);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getRefreshMonthlyTask(token: Utils.token, time: time)).thenAnswer((_) async => Right(mockedMonthlyTaskEntities));
    when(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => Left(ServerFailure(message: Failure.generalError, data: mockedTaskEntities)));
    
    final result = await getRefreshTaskByDateUsecase(time);
  
    expect(result, Left(ServerFailure(message: Failure.generalError, data: CombineTaskEntity(monthlyTaskEntities: mockedMonthlyTaskEntities, taskEntities: mockedTaskEntities))));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getRefreshMonthlyTask(token: Utils.token, time: time));
    verify(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time));
  });

  test("Should returns CacheFailure when get refresh task by date returns CacheFailure", () async {
    final time = DateTime(2022, 7, 16);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getRefreshMonthlyTask(token: Utils.token, time: time)).thenAnswer((_) async => Right(mockedMonthlyTaskEntities));
    when(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => const Left(CacheFailure(message: Failure.cacheError, data: [])));
    
    final result = await getRefreshTaskByDateUsecase(time);
  
    expect(result, Left(CacheFailure(message: Failure.cacheError, data: CombineTaskEntity(monthlyTaskEntities: mockedMonthlyTaskEntities, taskEntities: const []))));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getRefreshMonthlyTask(token: Utils.token, time: time));
    verify(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time));
  });

  test("Should returns CacheFailure when get refresh task by date returns CacheFailure with data", () async {
    final time = DateTime(2022, 7, 16);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getRefreshMonthlyTask(token: Utils.token, time: time)).thenAnswer((_) async => Right(mockedMonthlyTaskEntities));
    when(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => Left(CacheFailure(message: Failure.cacheError, data: mockedTaskEntities)));
    
    final result = await getRefreshTaskByDateUsecase(time);
  
    expect(result, Left(CacheFailure(message: Failure.cacheError, data: CombineTaskEntity(monthlyTaskEntities: mockedMonthlyTaskEntities, taskEntities: mockedTaskEntities))));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getRefreshMonthlyTask(token: Utils.token, time: time));
    verify(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time));
  });

  test("Should returns ServerFailure when get refresh monthly task by date returns ServerFailure", () async {
    final time = DateTime(2022, 7, 16);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getRefreshMonthlyTask(token: Utils.token, time: time)).thenAnswer((_) async => const Left(ServerFailure(message: Failure.generalError, data: [])));
    when(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => Right(mockedTaskEntities));
    
    final result = await getRefreshTaskByDateUsecase(time);
  
    expect(result, Left(ServerFailure(message: Failure.generalError, data: CombineTaskEntity(monthlyTaskEntities: const [], taskEntities: mockedTaskEntities))));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getRefreshMonthlyTask(token: Utils.token, time: time));
    verify(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time));
  });

  test("Should returns ServerFailure when get refresh monthly task by date returns ServerFailure with data", () async {
    final time = DateTime(2022, 7, 16);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getRefreshMonthlyTask(token: Utils.token, time: time)).thenAnswer((_) async => Left(ServerFailure(message: Failure.generalError, data: mockedMonthlyTaskEntities)));
    when(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => Right(mockedTaskEntities));
    
    final result = await getRefreshTaskByDateUsecase(time);
  
    expect(result, Left(ServerFailure(message: Failure.generalError, data: CombineTaskEntity(monthlyTaskEntities: mockedMonthlyTaskEntities, taskEntities: mockedTaskEntities))));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getRefreshMonthlyTask(token: Utils.token, time: time));
    verify(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time));
  });

  test("Should returns CacheFailure when get refresh monthly task by date returns CacheFailure", () async {
    final time = DateTime(2022, 7, 16);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getRefreshMonthlyTask(token: Utils.token, time: time)).thenAnswer((_) async => const Left(CacheFailure(message: Failure.cacheError, data: [])));
    when(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => Right(mockedTaskEntities));
    
    final result = await getRefreshTaskByDateUsecase(time);
  
    expect(result, Left(CacheFailure(message: Failure.cacheError, data: CombineTaskEntity(monthlyTaskEntities: const [], taskEntities: mockedTaskEntities))));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getRefreshMonthlyTask(token: Utils.token, time: time));
    verify(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time));
  });

  test("Should returns CacheFailure when get refresh monthly task by date returns CacheFailure with data", () async {
    final time = DateTime(2022, 7, 16);
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: Utils.token)));
    when(mockTaskRepository.getRefreshMonthlyTask(token: Utils.token, time: time)).thenAnswer((_) async => Left(CacheFailure(message: Failure.cacheError, data: mockedMonthlyTaskEntities)));
    when(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time)).thenAnswer((_) async => Right(mockedTaskEntities));
    
    final result = await getRefreshTaskByDateUsecase(time);
  
    expect(result, Left(CacheFailure(message: Failure.cacheError, data: CombineTaskEntity(monthlyTaskEntities: mockedMonthlyTaskEntities, taskEntities: mockedTaskEntities))));
    verify(mockAuthenticationRepository.getToken());
    verify(mockTaskRepository.getRefreshMonthlyTask(token: Utils.token, time: time));
    verify(mockTaskRepository.getRefreshTaskByDate(token: Utils.token, time: time));
  });

}