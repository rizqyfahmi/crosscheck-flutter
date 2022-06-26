
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
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
  DashboardRepository,
  AuthenticationRepository
])
void main() {
  late MockDashboardRepository mockDashboardRepository;
  late MockAuthenticationRepository mockAuthenticationRepository;
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
    mockAuthenticationRepository = MockAuthenticationRepository();
    getDashboardUsecase = GetDashboardUsecase(
      repository: mockDashboardRepository,
      authenticationRepository: mockAuthenticationRepository
    );
  });

  test("Should get DashboardEntity properly", () async {
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: token)));
    when(mockDashboardRepository.getDashboard(DashboardParams(token: token))).thenAnswer((_) async => Right(entity));

    final result = await getDashboardUsecase(NoParam());

    expect(result, Right(entity));
    verify(mockAuthenticationRepository.getToken());
    verify(mockDashboardRepository.getDashboard(DashboardParams(token: token)));
  });

  test("Should returns CacheFailure when get token is failed", () async {
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => Left(CachedFailure(message: Failure.cacheError)));
    when(mockDashboardRepository.getDashboard(DashboardParams(token: token))).thenAnswer((_) async => Left(ServerFailure(message: Failure.generalError)));

    final result = await getDashboardUsecase(NoParam());

    expect(result, Left(CachedFailure(message: Failure.cacheError)));
    verify(mockAuthenticationRepository.getToken());
    verifyNever(mockDashboardRepository.getDashboard(DashboardParams(token: token)));
  });

  test("Should returns CacheFailure when get dashboard is failed", () async {
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: token)));
    when(mockDashboardRepository.getDashboard(DashboardParams(token: token))).thenAnswer((_) async => Left(ServerFailure(message: Failure.generalError)));

    final result = await getDashboardUsecase(NoParam());

    expect(result, Left(ServerFailure(message: Failure.generalError)));
    verify(mockAuthenticationRepository.getToken());
    verify(mockDashboardRepository.getDashboard(DashboardParams(token: token)));
  });

}