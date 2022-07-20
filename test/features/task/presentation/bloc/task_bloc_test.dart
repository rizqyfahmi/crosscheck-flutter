import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/task/domain/entities/combine_task_entity.dart';
import 'package:crosscheck/features/task/domain/entities/monthly_task_entity.dart';
import 'package:crosscheck/features/task/domain/entities/task_entity.dart';
import 'package:crosscheck/features/task/domain/usecases/get_history_usecase.dart';
import 'package:crosscheck/features/task/domain/usecases/get_initial_task_by_date_usecase.dart';
import 'package:crosscheck/features/task/domain/usecases/get_monthly_task_usecase.dart';
import 'package:crosscheck/features/task/domain/usecases/get_more_history_usecase.dart';
import 'package:crosscheck/features/task/domain/usecases/get_more_task_by_date_usecase.dart';
import 'package:crosscheck/features/task/domain/usecases/get_refresh_history_usecase.dart';
import 'package:crosscheck/features/task/domain/usecases/get_task_by_date_usecase.dart';
import 'package:crosscheck/features/task/presentation/bloc/monthly_task_model.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_bloc.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_event.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_model.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/utils.dart';
import 'task_bloc_test.mocks.dart';

@GenerateMocks([
  GetHistoryUsecase,
  GetMoreHistoryUsecase,
  GetRefreshHistoryUsecase,
  GetInitialTaskByDateUsecase,
  GetMonthlyTaskUsecase,
  GetTaskByDateUsecase,
  GetMoreTaskByDateUsecase
])
void main() {
  late MockGetHistoryUsecase mockGetHistoryUsecase;
  late MockGetMoreHistoryUsecase mockGetMoreHistoryUsecase;
  late MockGetRefreshHistoryUsecase mockGetRefreshHistoryUsecase;
  late MockGetInitialTaskByDateUsecase mockGetInitialTaskByDateUsecase;
  late MockGetMonthlyTaskUsecase mockGetMonthlyTaskUsecase;
  late MockGetTaskByDateUsecase mockGetTaskByDateUsecase;
  late MockGetMoreTaskByDateUsecase mockGetMoreTaskByDateUsecase;
  late TaskBloc taskBloc;
  late List<TaskModel> models;

  setUp(() {
    mockGetHistoryUsecase = MockGetHistoryUsecase();
    mockGetMoreHistoryUsecase = MockGetMoreHistoryUsecase();
    mockGetRefreshHistoryUsecase = MockGetRefreshHistoryUsecase();
    mockGetInitialTaskByDateUsecase = MockGetInitialTaskByDateUsecase();
    mockGetMonthlyTaskUsecase = MockGetMonthlyTaskUsecase();
    mockGetTaskByDateUsecase = MockGetTaskByDateUsecase();
    mockGetMoreTaskByDateUsecase = MockGetMoreTaskByDateUsecase();

    taskBloc = TaskBloc(
      getHistoryUsecase: mockGetHistoryUsecase, 
      getMoreHistoryUsecase: mockGetMoreHistoryUsecase, 
      getRefreshHistoryUsecase: mockGetRefreshHistoryUsecase,
      getInitialTaskByDateUsecase: mockGetInitialTaskByDateUsecase,
      getMonthlyTaskUsecase: mockGetMonthlyTaskUsecase,
      getTaskByDateUsecase: mockGetTaskByDateUsecase,
      getMoreTaskByDateUsecase: mockGetMoreTaskByDateUsecase
    );

    models = Utils().taskEntities.map((entity) => TaskModel.fromTaskEntity(entity)).toList();
  });

  test("Should returns TaskInit at first time", () {
    expect(taskBloc.state, TaskInit());
  });

  test("Should returns TaskIdle when close response/error dialog", () {
    taskBloc.add(TaskResetGeneralError());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskIdle(models: [], monthlyTaskModels: [])
    ]));
  });

  /*--------------------------------------------------- Get History ---------------------------------------------------*/ 
  test("Should returns TaskIdle when get history returns TaskEntity", () {
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async => Right(Utils().taskEntities));

    taskBloc.add(TaskGetHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: [], monthlyTaskModels: []),
      TaskLoaded(models: models, monthlyTaskModels: const []),
      TaskIdle(models: models, monthlyTaskModels: const [])
    ]));
  });

  test("Should returns TaskGeneralError when get history returns ServerFailure with no data", () {
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async => const Left(ServerFailure(message: Failure.generalError, data: [])));
    taskBloc.add(TaskGetHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: [], monthlyTaskModels: []),
      const TaskGeneralError(models: [], monthlyTaskModels: [], message: Failure.generalError)
    ]));
  });

  test("Should returns TaskGeneralError when get history returns CacheFailure with no data", () {
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async => const Left(CacheFailure(message: Failure.cacheError, data: [])));
    taskBloc.add(TaskGetHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: [], monthlyTaskModels: []),
      const TaskGeneralError(models: [], monthlyTaskModels: [], message: Failure.cacheError)
    ]));
  });

  test("Should returns TaskGeneralError when get history returns NetworkFailure with no data", () {
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async => const Left(NetworkFailure(message: Failure.networkError, data: [])));
    taskBloc.add(TaskGetHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: [], monthlyTaskModels: []),
      const TaskGeneralError(models: [], monthlyTaskModels: [], message: Failure.networkError)
    ]));
  });

  test("Should returns TaskGeneralError when get history returns ServerFailure with data", () {
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async => Left(ServerFailure(message: Failure.generalError, data: Utils().taskEntities)));
    taskBloc.add(TaskGetHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: [], monthlyTaskModels: []),
      TaskGeneralError(models: models, monthlyTaskModels: const [], message: Failure.generalError)
    ]));
  });

  test("Should returns TaskGeneralError when get history returns CacheFailure with data", () {
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async => Left(CacheFailure(message: Failure.cacheError, data: Utils().taskEntities)));
    taskBloc.add(TaskGetHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: [], monthlyTaskModels: []),
      TaskGeneralError(models: models, monthlyTaskModels: const [], message: Failure.cacheError)
    ]));
  });

  test("Should returns TaskGeneralError when get history returns NetworkFailure with data", () {
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async => Left(NetworkFailure(message: Failure.networkError, data: Utils().taskEntities)));
    taskBloc.add(TaskGetHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: [], monthlyTaskModels: []),
      TaskGeneralError(models: models, monthlyTaskModels: const [], message: Failure.networkError)
    ]));
  });

  /*--------------------------------------------------- Get More History ---------------------------------------------------*/ 
  test("Should returns TaskIdle when get more history returns TaskEntity", () {
    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async => Right(Utils().taskEntities));

    taskBloc.add(TaskGetMoreHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: [], monthlyTaskModels: []),
      TaskLoaded(models: models, monthlyTaskModels: const []),
      TaskIdle(models: models, monthlyTaskModels: const [])
    ]));
  });

  test("Should returns TaskGeneralError when get more history returns ServerFailure with no data", () {
    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async => const Left(ServerFailure(message: Failure.generalError, data: [])));
    taskBloc.add(TaskGetMoreHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: [], monthlyTaskModels: []),
      const TaskGeneralError(models: [], monthlyTaskModels: [], message: Failure.generalError)
    ]));
  });

  test("Should returns TaskGeneralError when get more history returns CacheFailure with no data", () {
    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async => const Left(CacheFailure(message: Failure.cacheError, data: [])));
    taskBloc.add(TaskGetMoreHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: [], monthlyTaskModels: []),
      const TaskGeneralError(models: [], monthlyTaskModels: [], message: Failure.cacheError)
    ]));
  });

  test("Should returns TaskGeneralError when get more history returns NetworkFailure with no data", () {
    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async => const Left(NetworkFailure(message: Failure.networkError, data: [])));
    taskBloc.add(TaskGetMoreHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: [], monthlyTaskModels: []),
      const TaskGeneralError(models: [], monthlyTaskModels: [], message: Failure.networkError)
    ]));
  });

  test("Should returns TaskGeneralError when get more history returns ServerFailure with data", () {
    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async => Left(ServerFailure(message: Failure.generalError, data: Utils().taskEntities)));
    taskBloc.add(TaskGetMoreHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: [], monthlyTaskModels: []),
      TaskGeneralError(models: models, monthlyTaskModels: const [], message: Failure.generalError)
    ]));
  });

  test("Should returns TaskGeneralError when get more history returns CacheFailure with data", () {
    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async => Left(CacheFailure(message: Failure.cacheError, data: Utils().taskEntities)));
    taskBloc.add(TaskGetMoreHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: [], monthlyTaskModels: []),
      TaskGeneralError(models: models, monthlyTaskModels: const [], message: Failure.cacheError)
    ]));
  });

  test("Should returns TaskGeneralError when get more history returns NetworkFailure with data", () {
    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async => Left(NetworkFailure(message: Failure.networkError, data: Utils().taskEntities)));
    taskBloc.add(TaskGetMoreHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: [], monthlyTaskModels: []),
      TaskGeneralError(models: models, monthlyTaskModels: const [], message: Failure.networkError)
    ]));
  });

  /*--------------------------------------------------- Get Refresh History ---------------------------------------------------*/ 
  test("Should returns TaskIdle when get refresh history returns TaskEntity", () {
    when(mockGetRefreshHistoryUsecase(any)).thenAnswer((_) async => Right(Utils().taskEntities));

    taskBloc.add(TaskGetRefreshHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: [], monthlyTaskModels: []),
      TaskLoaded(models: models, monthlyTaskModels: const []),
      TaskIdle(models: models, monthlyTaskModels: const [])
    ]));
  });

  test("Should returns TaskGeneralError when get refresh history returns ServerFailure with no data", () {
    when(mockGetRefreshHistoryUsecase(any)).thenAnswer((_) async => const Left(ServerFailure(message: Failure.generalError, data: [])));
    taskBloc.add(TaskGetRefreshHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: [], monthlyTaskModels: []),
      const TaskGeneralError(models: [], monthlyTaskModels: [], message: Failure.generalError)
    ]));
  });

  test("Should returns TaskGeneralError when get refresh history returns CacheFailure with no data", () {
    when(mockGetRefreshHistoryUsecase(any)).thenAnswer((_) async => const Left(CacheFailure(message: Failure.cacheError, data: [])));
    taskBloc.add(TaskGetRefreshHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: [], monthlyTaskModels: []),
      const TaskGeneralError(models: [], monthlyTaskModels: [], message: Failure.cacheError)
    ]));
  });

  test("Should returns TaskGeneralError when get refresh history returns NetworkFailure with no data", () {
    when(mockGetRefreshHistoryUsecase(any)).thenAnswer((_) async => const Left(NetworkFailure(message: Failure.networkError, data: [])));
    taskBloc.add(TaskGetRefreshHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: [], monthlyTaskModels: []),
      const TaskGeneralError(models: [], monthlyTaskModels: [], message: Failure.networkError)
    ]));
  });

  test("Should returns TaskGeneralError when get refresh history returns ServerFailure with data", () {
    when(mockGetRefreshHistoryUsecase(any)).thenAnswer((_) async => Left(ServerFailure(message: Failure.generalError, data: Utils().taskEntities)));
    taskBloc.add(TaskGetRefreshHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: [], monthlyTaskModels: []),
      TaskGeneralError(models: models, monthlyTaskModels: const [], message: Failure.generalError)
    ]));
  });

  test("Should returns TaskGeneralError when get refresh history returns CacheFailure with data", () {
    when(mockGetRefreshHistoryUsecase(any)).thenAnswer((_) async => Left(CacheFailure(message: Failure.cacheError, data: Utils().taskEntities)));
    taskBloc.add(TaskGetRefreshHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: [], monthlyTaskModels: []),
      TaskGeneralError(models: models, monthlyTaskModels: const [], message: Failure.cacheError)
    ]));
  });

  test("Should returns TaskGeneralError when get refresh history returns NetworkFailure with data", () {
    when(mockGetRefreshHistoryUsecase(any)).thenAnswer((_) async => Left(NetworkFailure(message: Failure.networkError, data: Utils().taskEntities)));
    taskBloc.add(TaskGetRefreshHistory());
    
    expect(taskBloc.stream, emitsInOrder([
      const TaskLoading(models: [], monthlyTaskModels: []),
      TaskGeneralError(models: models, monthlyTaskModels: const [], message: Failure.networkError)
    ]));
  });

  /*--------------------------------------------------- Get Initial Task By Date | Event Page ---------------------------------------------------*/
  group("Get initial task by date", () {
    late DateTime time;
    late List<MonthlyTaskEntity> mockedMonthlyTaskEntities;
    late List<MonthlyTaskModel> expectedMonthlyTaskBlocModel;
    late List<TaskEntity> mockedTaskEntities;
    late List<TaskModel> expectedTaskBlocModel;
    late CombineTaskEntity mockedCombineTaskEntity;

    setUp(() {
      time = DateTime(2022, 7, 16);
      mockedMonthlyTaskEntities = [
        MonthlyTaskEntity(id: "001", date: time, total: 2),
        MonthlyTaskEntity(id: "002", date: time.add(const Duration(days: 1)), total: 1),
        MonthlyTaskEntity(id: "003", date: time.add(const Duration(days: 2)), total: 5),
      ];
      expectedMonthlyTaskBlocModel = mockedMonthlyTaskEntities.map((entity) {
        return MonthlyTaskModel.fromMonthlyTaskEntity(entity);
      }).toList();
      mockedTaskEntities = [
        TaskEntity(id: "001", title: "Hello title", description: "Hello description", start: time.add(const Duration(hours: 6)), end: time.add(const Duration(hours: 8)), isAllDay: false, alerts: const []),
        TaskEntity(id: "002", title: "Hello title 2", description: "Hello description 2", start: time.add(const Duration(hours: 9)), end: time.add(const Duration(hours: 10)), isAllDay: false, alerts: const []),
      ];
      expectedTaskBlocModel = mockedTaskEntities.map((entity) {
        return TaskModel.fromTaskEntity(entity);
      }).toList();
      mockedCombineTaskEntity = CombineTaskEntity(monthlyTaskEntities: mockedMonthlyTaskEntities, taskEntities: mockedTaskEntities);
    });

    test("Should returns empty task and monthly task properly for first time", () {
      when(mockGetInitialTaskByDateUsecase(any)).thenAnswer((_) async {
        return const Right(CombineTaskEntity(monthlyTaskEntities: [], taskEntities: []));
      });

      taskBloc.add(TaskGetInitialByDate(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        const TaskLoaded(models: [], monthlyTaskModels: []),
        const TaskIdle(models: [], monthlyTaskModels: [])
      ]));
    });

    test("Should returns task and monthly task properly", () {
      when(mockGetInitialTaskByDateUsecase(any)).thenAnswer((_) async {
        return Right(mockedCombineTaskEntity);
      });

      taskBloc.add(TaskGetInitialByDate(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        TaskLoaded(models: expectedTaskBlocModel, monthlyTaskModels: expectedMonthlyTaskBlocModel),
        TaskIdle(models: expectedTaskBlocModel, monthlyTaskModels: expectedMonthlyTaskBlocModel)
      ]));
    });

    test("Should returns ServerFailure with empty task and monthly task when get task by date returns ServerFailure and local data source of task and monthly task are empty", () {
      when(mockGetInitialTaskByDateUsecase(any)).thenAnswer((_) async {
        return const Left(ServerFailure(message: Failure.generalError, data: CombineTaskEntity(monthlyTaskEntities: [], taskEntities: [])));
      });

      taskBloc.add(TaskGetInitialByDate(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        const TaskGeneralError(models: [], monthlyTaskModels: [], message: Failure.generalError)
      ]));
    });

    test("Should returns ServerFailure with task and monthly task when get task by date returns ServerFailure and local data source of task and monthly task are not empty", () {
      when(mockGetInitialTaskByDateUsecase(any)).thenAnswer((_) async {
        return Left(ServerFailure(message: Failure.generalError, data: CombineTaskEntity(monthlyTaskEntities: mockedMonthlyTaskEntities, taskEntities: mockedTaskEntities)));
      });

      taskBloc.add(TaskGetInitialByDate(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        TaskGeneralError(models: expectedTaskBlocModel, monthlyTaskModels: expectedMonthlyTaskBlocModel, message: Failure.generalError)
      ]));
    });
    
    test("Should returns ServerFailure with empty task but has monthly task when get task by date returns ServerFailure and local data source of task is empty but monthly task is not empty", () {
      when(mockGetInitialTaskByDateUsecase(any)).thenAnswer((_) async {
        return Left(ServerFailure(message: Failure.generalError, data: CombineTaskEntity(monthlyTaskEntities: mockedMonthlyTaskEntities, taskEntities: const [])));
      });

      taskBloc.add(TaskGetInitialByDate(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        TaskGeneralError(models: const [], monthlyTaskModels: expectedMonthlyTaskBlocModel, message: Failure.generalError)
      ]));
    });

    test("Should returns CacheFailure with empty task and monthly task when get task by date returns CacheFailure and local data source of task and monthly task are empty", () {
      when(mockGetInitialTaskByDateUsecase(any)).thenAnswer((_) async {
        return const Left(CacheFailure(message: Failure.cacheError, data: CombineTaskEntity(monthlyTaskEntities: [], taskEntities: [])));
      });

      taskBloc.add(TaskGetInitialByDate(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        const TaskGeneralError(models: [], monthlyTaskModels: [], message: Failure.cacheError)
      ]));
    });

    test("Should returns CacheFailure with task and monthly task when get task by date returns CacheFailure and local data source of task and monthly task are not empty", () {
      when(mockGetInitialTaskByDateUsecase(any)).thenAnswer((_) async {
        return Left(CacheFailure(message: Failure.cacheError, data: CombineTaskEntity(monthlyTaskEntities: mockedMonthlyTaskEntities, taskEntities: mockedTaskEntities)));
      });

      taskBloc.add(TaskGetInitialByDate(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        TaskGeneralError(models: expectedTaskBlocModel, monthlyTaskModels: expectedMonthlyTaskBlocModel, message: Failure.cacheError)
      ]));
    });

    test("Should returns CacheFailure with empty task but has monthly task when get task by date returns CacheFailure and local data source of task is empty but monthly task is not empty", () {
      when(mockGetInitialTaskByDateUsecase(any)).thenAnswer((_) async {
        return Left(CacheFailure(message: Failure.cacheError, data: CombineTaskEntity(monthlyTaskEntities: mockedMonthlyTaskEntities, taskEntities: const [])));
      });

      taskBloc.add(TaskGetInitialByDate(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        TaskGeneralError(models: const [], monthlyTaskModels: expectedMonthlyTaskBlocModel, message: Failure.cacheError)
      ]));
    });


    test("Should returns ServerFailure with empty task and monthly task when get monthly task by date returns ServerFailure and local data source of task and monthly task are empty", () {
      when(mockGetInitialTaskByDateUsecase(any)).thenAnswer((_) async {
        return const Left(ServerFailure(message: Failure.generalError, data: CombineTaskEntity(monthlyTaskEntities: [], taskEntities: [])));
      });

      taskBloc.add(TaskGetInitialByDate(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        const TaskGeneralError(models: [], monthlyTaskModels: [], message: Failure.generalError)
      ]));
    });

    test("Should returns ServerFailure with task and monthly task when get monthly task by date returns ServerFailure and local data source of task and monthly task are not empty", () {
      when(mockGetInitialTaskByDateUsecase(any)).thenAnswer((_) async {
        return Left(ServerFailure(message: Failure.generalError, data: CombineTaskEntity(monthlyTaskEntities: mockedMonthlyTaskEntities, taskEntities: mockedTaskEntities)));
      });

      taskBloc.add(TaskGetInitialByDate(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        TaskGeneralError(models: expectedTaskBlocModel, monthlyTaskModels: expectedMonthlyTaskBlocModel, message: Failure.generalError)
      ]));
    });
    
    test("Should returns ServerFailure with task but empty monthly task when get monthly task by date returns ServerFailure and local data source of task is not empty but monthly task is empty", () {
      when(mockGetInitialTaskByDateUsecase(any)).thenAnswer((_) async {
        return Left(ServerFailure(message: Failure.generalError, data: CombineTaskEntity(monthlyTaskEntities: const [], taskEntities: mockedTaskEntities)));
      });

      taskBloc.add(TaskGetInitialByDate(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        TaskGeneralError(models: expectedTaskBlocModel, monthlyTaskModels: const [], message: Failure.generalError)
      ]));
    });

    test("Should returns CacheFailure with empty task but has monthly task when get monthly task by date returns CacheFailure and local data source of task and monthly task are empty", () {
      when(mockGetInitialTaskByDateUsecase(any)).thenAnswer((_) async {
        return const Left(CacheFailure(message: Failure.cacheError, data: CombineTaskEntity(monthlyTaskEntities: [], taskEntities: [])));
      });

      taskBloc.add(TaskGetInitialByDate(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        const TaskGeneralError(models: [], monthlyTaskModels: [], message: Failure.cacheError)
      ]));
    });

    test("Should returns CacheFailure with task and monthly task when get monthly task by date returns CacheFailure and local data source of task and monthly task are not empty", () {
      when(mockGetInitialTaskByDateUsecase(any)).thenAnswer((_) async {
        return Left(CacheFailure(message: Failure.cacheError, data: CombineTaskEntity(monthlyTaskEntities: mockedMonthlyTaskEntities, taskEntities: mockedTaskEntities)));
      });

      taskBloc.add(TaskGetInitialByDate(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        TaskGeneralError(models: expectedTaskBlocModel, monthlyTaskModels: expectedMonthlyTaskBlocModel, message: Failure.cacheError)
      ]));
    });

    test("Should returns CacheFailure with task but empty monthly task when get monthly task by date returns CacheFailure and local data source of task is not empty but monthly task is empty", () {
      when(mockGetInitialTaskByDateUsecase(any)).thenAnswer((_) async {
        return Left(CacheFailure(message: Failure.cacheError, data: CombineTaskEntity(monthlyTaskEntities: const [], taskEntities: mockedTaskEntities)));
      });

      taskBloc.add(TaskGetInitialByDate(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        TaskGeneralError(models: expectedTaskBlocModel, monthlyTaskModels: const [], message: Failure.cacheError)
      ]));
    });
    
    test("Should returns UnexpectedFailure with empty task and monthly task when get task by date and get monthly task by date return Failure and local data source of task and monthly task are empty", () {
      when(mockGetInitialTaskByDateUsecase(any)).thenAnswer((_) async {
        return const Left(UnexpectedFailure(message: Failure.generalError, data: CombineTaskEntity(monthlyTaskEntities: [], taskEntities: [])));
      });

      taskBloc.add(TaskGetInitialByDate(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        const TaskGeneralError(models: [], monthlyTaskModels: [], message: Failure.generalError)
      ]));
    });

    test("Should returns UnexpectedFailure with empty task and monthly task when get task by date and get monthly task by date return Failure and local data source of task and monthly task are not empty", () {
      when(mockGetInitialTaskByDateUsecase(any)).thenAnswer((_) async {
        return Left(UnexpectedFailure(message: Failure.generalError, data: CombineTaskEntity(monthlyTaskEntities: mockedMonthlyTaskEntities, taskEntities: mockedTaskEntities)));
      });

      taskBloc.add(TaskGetInitialByDate(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        TaskGeneralError(models: expectedTaskBlocModel, monthlyTaskModels: expectedMonthlyTaskBlocModel, message: Failure.generalError)
      ]));
    });

  });

  /*--------------------------------------------------- Get Monthly Task | Event Page ---------------------------------------------------*/
  group("Get monthly task", () {
    late DateTime time;
    late List<MonthlyTaskEntity> mockedMonthlyTaskEntity;
    late List<MonthlyTaskModel> expectedMonthlyTaskBlocModel;
    
    setUp(() {
      time = DateTime(2022, 7);
      final utils = Utils();
      mockedMonthlyTaskEntity = utils.getMonthlyTaskEntity(time: time);
      expectedMonthlyTaskBlocModel = mockedMonthlyTaskEntity.map((entity) {
        return MonthlyTaskModel.fromMonthlyTaskEntity(entity);
      }).toList();
    });

    test("Should get monthly task properly", () {
      when(mockGetMonthlyTaskUsecase(any)).thenAnswer((_) async {
        return Right(mockedMonthlyTaskEntity);
      });

      taskBloc.add(TaskGetMonthlyTask(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        TaskLoaded(models: const [], monthlyTaskModels: expectedMonthlyTaskBlocModel),
        TaskIdle(models: const [], monthlyTaskModels: expectedMonthlyTaskBlocModel)
      ]));
    });

    test("Should returns ServerFailure when get monthly task returns ServerFailure in the time local data source is empty", () async {
      when(mockGetMonthlyTaskUsecase(any)).thenAnswer((_) async {
        return const Left(ServerFailure(message: Failure.generalError, data: []));
      });

      taskBloc.add(TaskGetMonthlyTask(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        const TaskGeneralError(models: [], monthlyTaskModels: [], message: Failure.generalError)
      ]));
    });

    test("Should returns ServerFailure when get monthly task returns ServerFailure in the time local data source is not empty", () async {
      when(mockGetMonthlyTaskUsecase(any)).thenAnswer((_) async {
        return Left(ServerFailure(message: Failure.generalError, data: mockedMonthlyTaskEntity));
      });

      taskBloc.add(TaskGetMonthlyTask(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        TaskGeneralError(models: const [], monthlyTaskModels: expectedMonthlyTaskBlocModel, message: Failure.generalError)
      ]));
    });

    test("Should returns CacheFailure when get monthly task returns CacheFailure in the time local data source is empty", () async {
      when(mockGetMonthlyTaskUsecase(any)).thenAnswer((_) async {
        return const Left(CacheFailure(message: Failure.cacheError, data: []));
      });

      taskBloc.add(TaskGetMonthlyTask(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        const TaskGeneralError(models: [], monthlyTaskModels: [], message: Failure.cacheError)
      ]));
    });

    test("Should returns CacheFailure when get monthly task returns CacheFailure in the time local data source is not empty", () async {
      when(mockGetMonthlyTaskUsecase(any)).thenAnswer((_) async {
        return Left(CacheFailure(message: Failure.cacheError, data: mockedMonthlyTaskEntity));
      });

      taskBloc.add(TaskGetMonthlyTask(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        TaskGeneralError(models: const [], monthlyTaskModels: expectedMonthlyTaskBlocModel, message: Failure.cacheError)
      ]));
    });
  });

  /*--------------------------------------------------- Get Task By Date | Event Page ---------------------------------------------------*/
  group("Get task by date", () {
    late DateTime time;
    late List<TaskEntity> mockedTaskEntities;
    late List<TaskModel> expectedTaskBlocModel;

    setUp(() {
      time = DateTime(2022, 7, 16);
      mockedTaskEntities = [
        TaskEntity(id: "001", title: "Hello title", description: "Hello description", start: time.add(const Duration(hours: 6)), end: time.add(const Duration(hours: 8)), isAllDay: false, alerts: const []),
        TaskEntity(id: "002", title: "Hello title 2", description: "Hello description 2", start: time.add(const Duration(hours: 9)), end: time.add(const Duration(hours: 10)), isAllDay: false, alerts: const []),
      ];
      expectedTaskBlocModel = mockedTaskEntities.map((entity) {
        return TaskModel.fromTaskEntity(entity);
      }).toList();
    });

    test("Should get task by date properly", () {
      when(mockGetTaskByDateUsecase(time)).thenAnswer((_) async {
        return Right(mockedTaskEntities);
      });

      taskBloc.add(TaskGetByDate(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        TaskLoaded(models: expectedTaskBlocModel, monthlyTaskModels: const []),
        TaskIdle(models: expectedTaskBlocModel, monthlyTaskModels: const [])
      ]));
    });

    test("Should returns ServerFailure when get monthly task returns ServerFailure in the time local data source is empty", () async {
      when(mockGetTaskByDateUsecase(any)).thenAnswer((_) async {
        return const Left(ServerFailure(message: Failure.generalError, data: []));
      });

      taskBloc.add(TaskGetByDate(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        const TaskGeneralError(models: [], monthlyTaskModels: [], message: Failure.generalError)
      ]));
    });

    test("Should returns ServerFailure when get monthly task returns ServerFailure in the time local data source is not empty", () async {
      when(mockGetTaskByDateUsecase(any)).thenAnswer((_) async {
        return Left(ServerFailure(message: Failure.generalError, data: mockedTaskEntities));
      });

      taskBloc.add(TaskGetByDate(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        TaskGeneralError(models: expectedTaskBlocModel, monthlyTaskModels: const [], message: Failure.generalError)
      ]));
    });

    test("Should returns CacheFailure when get monthly task returns CacheFailure in the time local data source is empty", () async {
      when(mockGetTaskByDateUsecase(any)).thenAnswer((_) async {
        return const Left(CacheFailure(message: Failure.cacheError, data: []));
      });

      taskBloc.add(TaskGetByDate(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        const TaskGeneralError(models: [], monthlyTaskModels: [], message: Failure.cacheError)
      ]));
    });

    test("Should returns CacheFailure when get monthly task returns CacheFailure in the time local data source is not empty", () async {
      when(mockGetTaskByDateUsecase(any)).thenAnswer((_) async {
        return Left(CacheFailure(message: Failure.cacheError, data: mockedTaskEntities));
      });

      taskBloc.add(TaskGetByDate(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        TaskGeneralError(models: expectedTaskBlocModel, monthlyTaskModels: const [], message: Failure.cacheError)
      ]));
    });
  });

  /*--------------------------------------------------- Get More Task By Date | Event Page ---------------------------------------------------*/
  group("Get task by date", () {
    late DateTime time;
    late List<TaskEntity> mockedTaskEntities;
    late List<TaskEntity> mockedMoreTaskEntities;
    late List<TaskModel> expectedTaskBlocModel;
    late List<TaskModel> expectedMoreTaskBlocModel;

    setUp(() {
      time = DateTime(2022, 7, 16);
      mockedTaskEntities = [
        TaskEntity(id: "001", title: "Hello title", description: "Hello description", start: time.add(const Duration(hours: 6)), end: time.add(const Duration(hours: 8)), isAllDay: false, alerts: const []),
        TaskEntity(id: "002", title: "Hello title 2", description: "Hello description 2", start: time.add(const Duration(hours: 9)), end: time.add(const Duration(hours: 10)), isAllDay: false, alerts: const []),
      ];
      mockedMoreTaskEntities = [
        TaskEntity(id: "003", title: "Hello title 3", description: "Hello description 3", start: time.add(const Duration(hours: 11)), end: time.add(const Duration(hours: 12)), isAllDay: false, alerts: const []),
        TaskEntity(id: "004", title: "Hello title 4", description: "Hello description 4", start: time.add(const Duration(hours: 12)), end: time.add(const Duration(hours: 13)), isAllDay: false, alerts: const []),
      ];

      expectedTaskBlocModel = mockedTaskEntities.map((entity) {
        return TaskModel.fromTaskEntity(entity);
      }).toList();
      expectedMoreTaskBlocModel = mockedMoreTaskEntities.map((entity) {
        return TaskModel.fromTaskEntity(entity);
      }).toList();
    });

    test("Should get more task properly", () {
      when(mockGetMoreTaskByDateUsecase(any)).thenAnswer((_) async {
        return Right([...mockedTaskEntities, ...mockedMoreTaskEntities]);
      });

      taskBloc.add(TaskGetMoreByDate(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        TaskLoaded(models: [...expectedTaskBlocModel, ...expectedMoreTaskBlocModel], monthlyTaskModels: const []),
        TaskIdle(models: [...expectedTaskBlocModel, ...expectedMoreTaskBlocModel], monthlyTaskModels: const [])
      ]));
    });

    test("Should returns ServerFailure when get task returns ServerFailure in the time local data source is empty", () async {
      when(mockGetMoreTaskByDateUsecase(any)).thenAnswer((_) async {
        return const Left(ServerFailure(message: Failure.generalError, data: []));
      });

      taskBloc.add(TaskGetMoreByDate(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        const TaskGeneralError(models: [], monthlyTaskModels: [], message: Failure.generalError)
      ]));
    });

    test("Should returns ServerFailure when get task returns ServerFailure in the time local data source is not empty", () async {
      when(mockGetMoreTaskByDateUsecase(any)).thenAnswer((_) async {
        return Left(ServerFailure(message: Failure.generalError, data: mockedTaskEntities));
      });

      taskBloc.add(TaskGetMoreByDate(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        TaskGeneralError(models: expectedTaskBlocModel, monthlyTaskModels: const [], message: Failure.generalError)
      ]));
    });

    test("Should returns CacheFailure when get task returns CacheFailure in the time local data source is empty", () async {
      when(mockGetMoreTaskByDateUsecase(any)).thenAnswer((_) async {
        return const Left(CacheFailure(message: Failure.cacheError, data: []));
      });

      taskBloc.add(TaskGetMoreByDate(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        const TaskGeneralError(models: [], monthlyTaskModels: [], message: Failure.cacheError)
      ]));
    });

    test("Should returns CacheFailure when get task returns CacheFailure in the time local data source is not empty", () async {
      when(mockGetMoreTaskByDateUsecase(any)).thenAnswer((_) async {
        return Left(CacheFailure(message: Failure.cacheError, data: mockedTaskEntities));
      });

      taskBloc.add(TaskGetMoreByDate(time: time));

      expect(taskBloc.stream, emitsInOrder([
        const TaskLoading(models: [], monthlyTaskModels: []),
        TaskGeneralError(models: expectedTaskBlocModel, monthlyTaskModels: const [], message: Failure.cacheError)
      ]));
    });
  });
}