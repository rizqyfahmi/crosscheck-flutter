
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/dashboard/data/models/params/dashboard_params.dart';
import 'package:crosscheck/features/dashboard/domain/entities/activity_entity.dart';
import 'package:crosscheck/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:crosscheck/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:crosscheck/features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_dashboard_usecase_test.mocks.dart';

@GenerateMocks([
  DashboardRepository
])
void main() {
  late MockDashboardRepository mockDashboardRepository;
  late GetDashboardUsecase getDashboardUsecase;

  // Mock Result
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
  final DashboardEntity entity = DashboardEntity(progress: completed / (upcoming + completed), upcoming: upcoming, completed: completed, activities: activities);
  
  setUp(() {
    mockDashboardRepository = MockDashboardRepository();
    getDashboardUsecase = GetDashboardUsecase(repository: mockDashboardRepository);
  });

  test("Should return DashboardEntity when get dashboard is success", () async {
    when(mockDashboardRepository.getDashboard(DashboardParams(token: token))).thenAnswer((_) async => Right(entity));

    final result = await getDashboardUsecase(DashboardParams(token: token));

    expect(result, Right(entity));
    verify(mockDashboardRepository.getDashboard(DashboardParams(token: token)));
  });

  test("Should return ServerFailure when get dashboard is failed", () async {
    when(mockDashboardRepository.getDashboard(DashboardParams(token: token))).thenAnswer((_) async => Left(ServerFailure(message: Failure.generalError)));

    final result = await getDashboardUsecase(DashboardParams(token: token));

    expect(result, Left(ServerFailure(message: Failure.generalError)));
    verify(mockDashboardRepository.getDashboard(DashboardParams(token: token)));
  });

}