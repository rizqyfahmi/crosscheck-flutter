import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';
import 'package:crosscheck/features/main/domain/repositories/main_repository.dart';
import 'package:crosscheck/features/main/domain/usecase/get_active_bottom_navigation_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_active_bottom_navigation_usecase_test.mocks.dart';


@GenerateMocks([
  MainRepository
])
void main() {
  late MockMainRepository mockMainRepository;
  late GetActiveBottomNavigationUsecase getActiveBottomNavigationUsesace;

  setUp(() {
    mockMainRepository = MockMainRepository();
    getActiveBottomNavigationUsesace = GetActiveBottomNavigationUsecase(repository: mockMainRepository);
  });

  test("Should return BottomNavigationEntity when get active bottom navigation is success", () async {
    when(mockMainRepository.getActiveBottomNavigation()).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.event)));

    final result = await getActiveBottomNavigationUsesace(NoParam());

    expect(result, const Right(BottomNavigationEntity(currentPage: BottomNavigation.event)));
    verify(mockMainRepository.getActiveBottomNavigation());
  });

  test("Should return CachedFailure when get active bottom navigation is failed", () async {
    when(mockMainRepository.getActiveBottomNavigation()).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));

    final result = await getActiveBottomNavigationUsesace(NoParam());

    expect(result, const Left(CacheFailure(message: Failure.cacheError)));
    verify(mockMainRepository.getActiveBottomNavigation());
  });
}