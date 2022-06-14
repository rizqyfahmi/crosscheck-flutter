import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/dashboard/data/models/params/dashboard_params.dart';
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

  const String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";
  final currentDate = DateTime.parse("2022-06-14");
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
  final DashboardEntity entity = DashboardEntity(progress: completed / (upcoming + completed), upcoming: upcoming, completed: completed, activities: activities);
  setUp(() {
    dashboardBlocModel = DashboardModel(
      username: "N/A",
      upcoming: 20,
      completed: 5,
      progress: (completed / (upcoming + completed)),
      taskText: "You have 20 tasks right now",
      activities: activities.map((activity) {
        return ActivityModel(
          progress: ((activity.total / weeklyTotal) * 100).toStringAsFixed(0), 
          isActive: currentDate.weekday == activity.date.day, 
          date: activity.date, 
          total: activity.total
        );
      }).toList()
    );
    mockGetDashboardUsecase = MockGetDashboardUsecase();
    dashboardBloc = DashboardBloc(getDashboardUsecase: mockGetDashboardUsecase);
  });

  test("Should return DashboardInit at first time", () {
    expect(dashboardBloc.state, const DashboardInit());
  });

  test("Should return DashboardSuccess when get dashboard is success", () async {

    when(mockGetDashboardUsecase(DashboardParams(token: token))).thenAnswer((_) async => Right(entity));

    dashboardBloc.add(DashboardGetData(token: token, date: currentDate));
    
    final expected = [
      const DashboardLoading(model: DashboardModel()),
      DashboardSuccess(model: dashboardBlocModel)
    ];

    expectLater(dashboardBloc.stream, emitsInOrder(expected));

  });

  test("Should return DashboardInit when reset dashboard is success", () async {

    when(mockGetDashboardUsecase(DashboardParams(token: token))).thenAnswer((_) async => Right(entity));

    dashboardBloc.add(DashboardGetData(token: token, date: currentDate));
    dashboardBloc.add(DashboardResetData());
    
    final expected = [
      const DashboardLoading(model: DashboardModel()),
      DashboardSuccess(model: dashboardBlocModel),
      const DashboardInit()
    ];

    expectLater(dashboardBloc.stream, emitsInOrder(expected));

  });

  test("Should return DashboardGeneralError when get dashboard is failed", () async {

    when(mockGetDashboardUsecase(DashboardParams(token: token))).thenAnswer((_) async => Left(ServerFailure(message: Failure.generalError)));

    dashboardBloc.add(DashboardGetData(token: token, date: currentDate));
    
    final expected = [
      const DashboardLoading(model: DashboardModel()),
      const DashboardGeneralError(message: Failure.generalError, model: DashboardModel())
    ];

    expectLater(dashboardBloc.stream, emitsInOrder(expected));

  });

  test("Should return DashboardNoGeneralError when reset dashboard general", () async {

    when(mockGetDashboardUsecase(DashboardParams(token: token))).thenAnswer((_) async => Left(ServerFailure(message: Failure.generalError)));

    dashboardBloc.add(DashboardGetData(token: token, date: currentDate));
    dashboardBloc.add(DashboardResetGeneralError());
    
    final expected = [
      const DashboardLoading(model: DashboardModel()),
      const DashboardGeneralError(message: Failure.generalError, model: DashboardModel()),
      const DashboardNoGeneralError(model: DashboardModel())
    ];

    expectLater(dashboardBloc.stream, emitsInOrder(expected));

  });
}