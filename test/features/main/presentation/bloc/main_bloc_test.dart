import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';
import 'package:crosscheck/features/main/domain/usecase/get_active_bottom_navigation_usecase.dart';
import 'package:crosscheck/features/main/domain/usecase/set_active_bottom_navigation_usecase.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_bloc.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_event.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_model.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'main_bloc_test.mocks.dart';

@GenerateMocks([
  GetActiveBottomNavigationUsecase,
  SetActiveBottomNavigationUsecase
])
void main() {
  late MockGetActiveBottomNavigationUsecase mockGetActiveBottomNavigationUsecase;
  late MockSetActiveBottomNavigationUsecase mockSetActiveBottomNavigationUsecase;
  late MainBloc mainBloc;

  setUp(() {
    mockGetActiveBottomNavigationUsecase = MockGetActiveBottomNavigationUsecase();
    mockSetActiveBottomNavigationUsecase = MockSetActiveBottomNavigationUsecase();
    mainBloc = MainBloc(
      getActiveBottomNavigationUsecase: mockGetActiveBottomNavigationUsecase,
      setActiveBottomNavigationUsecase: mockSetActiveBottomNavigationUsecase
    );
  });

  test("Should return MainInit at first time", () {
    expect(mainBloc.state, const MainInit());
  });

  test("Should return MainChanged when get active bottom navigation is success", () async {
    when(mockGetActiveBottomNavigationUsecase(NoParam())).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPageIndex: 1)));

    mainBloc.add(MainGetActiveBottomNavigation());

    final expected = [
      const MainChanged(model: MainModel(currentPageIndex: 1))
    ];

    expectLater(mainBloc.stream, emitsInOrder(expected));

    await untilCalled(mockGetActiveBottomNavigationUsecase(NoParam()));
    verify(mockGetActiveBottomNavigationUsecase(NoParam()));
  });

  test("Should current state when set active bottom navigation is failed", () async {
    when(mockGetActiveBottomNavigationUsecase(NoParam())).thenAnswer((_) async => Left(CachedFailure(message: Failure.cacheError)));

    mainBloc.add(MainGetActiveBottomNavigation());

    final expected = [
      const MainInit()
    ];

    expectLater(mainBloc.stream, emitsInOrder(expected));
    
    await untilCalled(mockGetActiveBottomNavigationUsecase(NoParam()));
    verify(mockGetActiveBottomNavigationUsecase(NoParam()));
  });
}