import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/dashboard/domain/entities/activity_entity.dart';
import 'package:crosscheck/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:crosscheck/features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/activity_model.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_model.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'dashboard_bloc_test.mocks.dart';

@GenerateMocks([
  GetDashboardUsecase
])
void main() {
  late MockGetDashboardUsecase mockGetDashboardUsecase;
  late DashboardBloc dashboardBloc;
  late DashboardModel dashboardBlocModel;

  final currentDate = DateTime.now();
  final List<ActivityEntity> activities = [
    ActivityEntity(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.monday)), total: 5),   
    ActivityEntity(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.tuesday)), total: 7),
    ActivityEntity(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.wednesday)), total: 3),
    ActivityEntity(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.thursday)), total: 2),
    ActivityEntity(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.friday)), total: 7),
    ActivityEntity(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.saturday)), total: 1),
    ActivityEntity(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.sunday)), total: 5),
  ];
  const int upcoming = 20;
  const int completed = 5;
  final double weeklyTotal = activities.map((e) => double.parse(e.total.toString())).reduce((value, result) => value + result);
  final DashboardEntity entity = DashboardEntity(progress: (completed / (upcoming + completed)) * 100, upcoming: upcoming, completed: completed, activities: activities);
  setUp(() {
    dashboardBlocModel = DashboardModel(
      username: "N/A",
      upcoming: 20,
      completed: 5,
      progress: "20%",
      taskText: "You have 20 tasks right now",
      activities: activities.map((activity) {
        final calculatedProgress = (activity.total / weeklyTotal) * 100;
        return ActivityModel(
          progress: (calculatedProgress).toStringAsFixed(0), 
          isActive: currentDate.weekday == activity.date.weekday, 
          date: activity.date, 
          total: activity.total,
          heightBar: (calculatedProgress / 100 * 160)
        );
      }).toList()
    );
    mockGetDashboardUsecase = MockGetDashboardUsecase();
    dashboardBloc = DashboardBloc(getDashboardUsecase: mockGetDashboardUsecase);
  });

  test("Should return DashboardInit at first time", () {
    expect(dashboardBloc.state, DashboardInit());
  });

  test("Should return DashboardSuccess when get dashboard is success", () async {

    when(mockGetDashboardUsecase(any)).thenAnswer((_) async => Right(entity));

    dashboardBloc.add(DashboardGetData());
    
    final expected = [
      DashboardLoading(model: DashboardModel()),
      DashboardSuccess(model: dashboardBlocModel)
    ];

    expectLater(dashboardBloc.stream, emitsInOrder(expected));

  });

  test("Should return DashboardInit when reset dashboard is success", () async {

    when(mockGetDashboardUsecase(any)).thenAnswer((_) async => Right(entity));

    dashboardBloc.add(DashboardGetData());
    dashboardBloc.add(DashboardResetData());
    
    final expected = [
      DashboardLoading(model: DashboardModel()),
      DashboardSuccess(model: dashboardBlocModel),
      DashboardInit()
    ];

    expectLater(dashboardBloc.stream, emitsInOrder(expected));

  });

  test("Should return DashboardGeneralError when get dashboard is failed", () async {

    when(mockGetDashboardUsecase(any)).thenAnswer((_) async => Left(ServerFailure(message: Failure.generalError)));

    dashboardBloc.add(DashboardGetData());
    
    final expected = [
      DashboardLoading(model: DashboardModel()),
      DashboardGeneralError(message: Failure.generalError, model: DashboardModel())
    ];

    expectLater(dashboardBloc.stream, emitsInOrder(expected));

  });

  test("Should return DashboardNoGeneralError when reset dashboard general", () async {

    when(mockGetDashboardUsecase(any)).thenAnswer((_) async => Left(ServerFailure(message: Failure.generalError)));

    dashboardBloc.add(DashboardGetData());
    dashboardBloc.add(DashboardResetGeneralError());
    
    final expected = [
      DashboardLoading(model: DashboardModel()),
      DashboardGeneralError(message: Failure.generalError, model: DashboardModel()),
      DashboardNoGeneralError(model: DashboardModel())
    ];

    expectLater(dashboardBloc.stream, emitsInOrder(expected));

  });
}