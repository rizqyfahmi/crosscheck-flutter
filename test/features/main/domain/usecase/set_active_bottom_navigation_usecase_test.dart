import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/main/data/model/bottom_navigation_model.dart';
import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';
import 'package:crosscheck/features/main/domain/repositories/main_repository.dart';
import 'package:crosscheck/features/main/domain/usecase/set_active_bottom_navigation_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'set_active_bottom_navigation_usecase_test.mocks.dart';

@GenerateMocks([
  MainRepository
])
void main() {
  late MockMainRepository mockMainRepository;
  late SetActiveBottomNavigationUsecase setActiveBottomNavigationUsecase;

  setUp(() {
    mockMainRepository = MockMainRepository();
    setActiveBottomNavigationUsecase = SetActiveBottomNavigationUsecase(repository: mockMainRepository);
  });

  test("Should return BottomNavigationEntity when set active bottom navigation is success", () async {
    const param = BottomNavigationModel(currentPageIndex: 1);
    BottomNavigationEntity entity = param;
    when(mockMainRepository.setActiveBottomNavigation(param)).thenAnswer((_) async => Future.value());
    when(mockMainRepository.getActiveBottomNavigation()).thenAnswer((_) async => const Right(BottomNavigationModel(currentPageIndex: 1)));

    final result = await setActiveBottomNavigationUsecase(param);

    expect(result, Right(entity));
    verify(mockMainRepository.setActiveBottomNavigation(param));
    verify(mockMainRepository.getActiveBottomNavigation());
  });

  test("Should CachedFailure void when set active bottom navigation is failed", () async {
    const param = BottomNavigationModel(currentPageIndex: 1);
    when(mockMainRepository.setActiveBottomNavigation(param)).thenAnswer((_) async => Future.value());
    when(mockMainRepository.getActiveBottomNavigation()).thenAnswer((_) async => Left(CachedFailure(message: Failure.cacheError)));

    final result = await setActiveBottomNavigationUsecase(param);

    expect(result, Left(CachedFailure(message: Failure.cacheError)));
    verify(mockMainRepository.setActiveBottomNavigation(param));
    verify(mockMainRepository.getActiveBottomNavigation());
  });
}