import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/network/network_info.dart';
import 'package:crosscheck/features/dashboard/data/datasource/dashboard_remote_data_source.dart';
import 'package:crosscheck/features/dashboard/data/models/data/activity_model.dart';
import 'package:crosscheck/features/dashboard/data/models/data/dashboard_model.dart';
import 'package:crosscheck/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:crosscheck/features/dashboard/domain/entities/activity_entity.dart';
import 'package:crosscheck/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:crosscheck/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'dashboard_repository_impl_test.mocks.dart';

@GenerateMocks([
  DashboardRemoteDataSource,
  NetworkInfo
])
void main() {
  late MockDashboardRemoteDataSource mockDashboardRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late DashboardRepository dashboardRepository;

  const String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";
  final currentDate = DateTime.parse("2022-06-14");
  
  
  

  final List<ActivityEntity> mockActivities = [
    ActivityModel(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.monday)), total: 5),   
    ActivityModel(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.tuesday)), total: 7),
    ActivityModel(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.wednesday)), total: 3),
    ActivityModel(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.thursday)), total: 2),
    ActivityModel(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.friday)), total: 7),
    ActivityModel(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.saturday)), total: 1),
    ActivityModel(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.sunday)), total: 5),
  ];
  const int upcoming = 20;
  const int completed = 5;
  final DashboardModel mockModel = DashboardModel(progress: completed / (upcoming + completed), upcoming: upcoming, completed: completed, activities: mockActivities);

  setUp(() {
    mockDashboardRemoteDataSource = MockDashboardRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    dashboardRepository = DashboardRepositoryImpl(
      remote: mockDashboardRemoteDataSource,
      networkInfo: mockNetworkInfo
    );
  });

  test("Should return NetworkFailure when get dashboard is failed because of connection lost", () async {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

    final result = await dashboardRepository.getDashboard(token: token);

    expect(result, Left(NetworkFailure()));

    verifyNever(mockDashboardRemoteDataSource.getDashboard(token));
    verify(mockNetworkInfo.isConnected);
  });

  test("Should return ServerFailure when get dashboard is failed because of error response from API", () async {
    when(mockDashboardRemoteDataSource.getDashboard(token)).thenThrow(ServerException(message: Failure.generalError));
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

    final result = await dashboardRepository.getDashboard(token: token);

    expect(result, Left(ServerFailure(message: Failure.generalError)));

    verify(mockDashboardRemoteDataSource.getDashboard(token));
    verify(mockNetworkInfo.isConnected);
  });

  test("Should return DashboardActivity when get dashboard is success", () async {
    when(mockDashboardRemoteDataSource.getDashboard(token)).thenAnswer((_) async => mockModel);
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

    final result = await dashboardRepository.getDashboard(token: token);

    final List<ActivityEntity> expectedActivities = [
      ActivityEntity(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.monday)), total: 5),   
      ActivityEntity(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.tuesday)), total: 7),
      ActivityEntity(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.wednesday)), total: 3),
      ActivityEntity(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.thursday)), total: 2),
      ActivityEntity(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.friday)), total: 7),
      ActivityEntity(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.saturday)), total: 1),
      ActivityEntity(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.sunday)), total: 5),
    ];

    final DashboardEntity entity = DashboardEntity(progress: completed / (upcoming + completed), upcoming: upcoming, completed: completed, activities: expectedActivities);

    expect(result, Right(entity));

    verify(mockDashboardRemoteDataSource.getDashboard(token));
    verify(mockNetworkInfo.isConnected);
  });

}