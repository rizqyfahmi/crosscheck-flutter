
import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/features/authentication/domain/usecases/login_usecase.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/login/bloc/login_bloc.dart';
import 'package:crosscheck/features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:crosscheck/features/main/data/model/params/bottom_navigation_params.dart';
import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';
import 'package:crosscheck/features/main/domain/usecase/get_active_bottom_navigation_usecase.dart';
import 'package:crosscheck/features/main/domain/usecase/set_active_bottom_navigation_usecase.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_bloc.dart';
import 'package:crosscheck/features/settings/domain/entities/settings_entity.dart';
import 'package:crosscheck/features/settings/domain/usecase/get_theme_usecase.dart';
import 'package:crosscheck/features/settings/domain/usecase/set_theme_usecase.dart';
import 'package:crosscheck/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:crosscheck/features/settings/presentation/bloc/settings_event.dart';
import 'package:crosscheck/features/task/domain/usecases/get_history_usecase.dart';
import 'package:crosscheck/features/task/domain/usecases/get_more_history_usecase.dart';
import 'package:crosscheck/features/task/domain/usecases/get_refresh_history_usecase.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_bloc.dart';
import 'package:crosscheck/features/walkthrough/data/models/request/walkthrough_params.dart';
import 'package:crosscheck/features/walkthrough/domain/usecases/get_is_skip_usecase.dart';
import 'package:crosscheck/features/walkthrough/domain/usecases/set_is_skip_usecase.dart';
import 'package:crosscheck/features/walkthrough/presentation/bloc/walkthrough_bloc.dart';
import 'package:crosscheck/features/walkthrough/presentation/bloc/walkthrough_event.dart';
import 'package:crosscheck/main.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../test/utils/utils.dart';
import 'history_view_test.mocks.dart';

@GenerateMocks([
  LoginUsecase,
  SetIsSkipUsecase,
  GetIsSkipUsecase,
  SetActiveBottomNavigationUsecase,
  GetActiveBottomNavigationUsecase,
  GetDashboardUsecase,
  SetThemeUsecase,
  GetThemeUsecase,
  GetHistoryUsecase,
  GetMoreHistoryUsecase,
  GetRefreshHistoryUsecase
])
void main() {
  late MockLoginUsecase mockLoginUsecase;
  late MockSetIsSkipUsecase mockSetIsSkipUsecase;
  late MockGetIsSkipUsecase mockGetIsSkipUsecase;
  late MockSetActiveBottomNavigationUsecase mockSetActiveBottomNavigationUsecase;
  late MockGetActiveBottomNavigationUsecase mockGetActiveBottomNavigationUsecase;
  late MockGetDashboardUsecase mockGetDashboardUsecase;
  late MockSetThemeUsecase mockSetThemeUsecase;
  late MockGetThemeUsecase mockGetThemeUsecase;
  late MockGetHistoryUsecase mockGetHistoryUsecase;
  late MockGetMoreHistoryUsecase mockGetMoreHistoryUsecase;
  late MockGetRefreshHistoryUsecase mockGetRefreshHistoryUsecase;
  
  late AuthenticationBloc authenticationBloc;
  late WalkthroughBloc walkthroughBloc;
  late LoginBloc loginBloc;
  late MainBloc mainBloc;
  late DashboardBloc dashboardBloc;
  late SettingsBloc settingsBloc;
  late TaskBloc taskBloc;
  late Widget main;

  setUp(() {
    mockLoginUsecase = MockLoginUsecase();
    mockSetIsSkipUsecase = MockSetIsSkipUsecase();
    mockGetIsSkipUsecase = MockGetIsSkipUsecase();
    mockGetActiveBottomNavigationUsecase = MockGetActiveBottomNavigationUsecase();
    mockSetActiveBottomNavigationUsecase = MockSetActiveBottomNavigationUsecase();
    mockGetDashboardUsecase = MockGetDashboardUsecase();
    mockSetThemeUsecase = MockSetThemeUsecase();
    mockGetThemeUsecase = MockGetThemeUsecase();
    mockGetHistoryUsecase = MockGetHistoryUsecase();
    mockGetMoreHistoryUsecase = MockGetMoreHistoryUsecase();
    mockGetRefreshHistoryUsecase = MockGetRefreshHistoryUsecase();

    authenticationBloc = AuthenticationBloc();
    walkthroughBloc = WalkthroughBloc(setIsSkipUsecase: mockSetIsSkipUsecase, getIsSkipUsecase: mockGetIsSkipUsecase);
    loginBloc = LoginBloc(loginUsecase: mockLoginUsecase);
    mainBloc = MainBloc(
      getActiveBottomNavigationUsecase: mockGetActiveBottomNavigationUsecase,
      setActiveBottomNavigationUsecase: mockSetActiveBottomNavigationUsecase
    );
    dashboardBloc = DashboardBloc(getDashboardUsecase: mockGetDashboardUsecase);
    settingsBloc = SettingsBloc(setThemeUsecase: mockSetThemeUsecase, getThemeUsecase: mockGetThemeUsecase);
    taskBloc = TaskBloc(
      getHistoryUsecase: mockGetHistoryUsecase,
      getMoreHistoryUsecase: mockGetMoreHistoryUsecase,
      getRefreshHistoryUsecase: mockGetRefreshHistoryUsecase
    );
    main = MyApp(providers: [
      BlocProvider<AuthenticationBloc>(
        create: (_) => authenticationBloc
      ),
      BlocProvider<LoginBloc>(
        create: (_) => loginBloc
      ),
      BlocProvider<WalkthroughBloc>(
        create: (_) => walkthroughBloc..add(WalkthroughGetSkip())
      ),
      BlocProvider<MainBloc>(
        create: (_) => mainBloc
      ),
      BlocProvider<DashboardBloc>(
        create: (_) => dashboardBloc
      ),
      BlocProvider<SettingsBloc>(
        create: (_) => settingsBloc..add(SettingsLoad())
      ),
      BlocProvider<TaskBloc>(
        create: (_) => taskBloc
      ),
    ]);
  });

  testWidgets("Should get history properly", (WidgetTester tester) async {
    int currentTotalTasks = 0;
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));
    when(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true))).thenAnswer((_) async => const Right(null));
    when(mockLoginUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Right(null);
    });
    when(mockGetActiveBottomNavigationUsecase(NoParam())).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockSetActiveBottomNavigationUsecase(const BottomNavigationParams(currentPage: BottomNavigation.history))).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.history)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      final mockedEntity = Utils().dashboardEntity.copyWith(
        fullname: "fulan",
        photoUrl: "https://via.placeholder.com/60x60"
      );

      return Right(mockedEntity);
    });
    when(mockGetThemeUsecase(any)).thenAnswer((_) async => const Right(SettingsEntity(themeMode: Brightness.dark)));
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      currentTotalTasks += 10;
      return Right(Utils().getTaskEntities(end: currentTotalTasks));
    });

    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      currentTotalTasks += 10;
      return Right(Utils().getTaskEntities(start: 0, end: currentTotalTasks));
    });

    when(mockGetRefreshHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      currentTotalTasks = 10;
      return Right(Utils().getTaskEntities(start: 0, end: currentTotalTasks));
    });

    await tester.runAsync(() async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(main);
      await tester.pumpAndSettle();

      verify(mockGetIsSkipUsecase(NoParam()));
      await tester.tap(find.byKey(const Key("getStartedButton")));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key("usernameField")), "fulan@email.com");
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key("passwordField")), "Password123");
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key("submitButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("submitButton")));
      await tester.pump();

      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      
      expect(find.text("Loading..."), findsNothing);
      await tester.pump();
      
      expect(find.text("Home"), findsWidgets);
      expect(find.text("Event"), findsWidgets);
      expect(find.text("History"), findsWidgets);
      expect(find.text("Settings"), findsWidgets);
      Image imageProfile = tester.widget(find.byKey(const Key("imageProfile")));
      expect((imageProfile.image as NetworkImage).url, "https://via.placeholder.com/60x60/F24B59/F24B59?text=.");

      await tester.pump();
      await Future.delayed(const Duration(seconds: 1));
      expect(find.text("Loading..."), findsOneWidget);
      await tester.pumpAndSettle();
      
      expect(find.text("Loading..."), findsNothing);
      imageProfile = tester.widget(find.byKey(const Key("imageProfile")));
      expect((imageProfile.image as NetworkImage).url, "https://via.placeholder.com/60x60");
      expect(find.text("You have 20 tasks right now"), findsOneWidget);
      expect(find.text("20%"), findsOneWidget);
      expect(find.text("5"), findsOneWidget);

      Iterable<Container> bars = tester.widgetList<Container>(find.byKey(const Key("bar")));
      for (var i = 0; i < bars.length; i++) {
        BoxDecoration decoration = bars.elementAt(i).decoration as BoxDecoration;
       
        if (i == (DateTime.now().weekday - 1)) {
          expect(decoration.color, CustomColors.primary);
          continue;
        }

        expect(decoration.color, CustomColors.placeholderText.withOpacity(0.16));
      }

      await tester.tap(find.byKey(const Key("navHistory")));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(currentTotalTasks, 10);
      
      for (var i = 0; i < 10; i++) {
        await tester.scrollUntilVisible(
          find.byKey(ValueKey('TaskTile$i')),
          100.0,
          scrollable: find.byType(Scrollable),
        );
      }

      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(currentTotalTasks, 20);

      for (var i = 9; i >= 0; i--) {
        await tester.scrollUntilVisible(
          find.byKey(ValueKey('TaskTile$i')),
          -100.0,
          scrollable: find.byType(Scrollable),
        );
      }

      handle.dispose();
    });
    
  });

  testWidgets("Should not display anything when get history returns failure", (WidgetTester tester) async {
    int currentTotalTasks = 0;
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));
    when(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true))).thenAnswer((_) async => const Right(null));
    when(mockLoginUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Right(null);
    });
    when(mockGetActiveBottomNavigationUsecase(NoParam())).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockSetActiveBottomNavigationUsecase(const BottomNavigationParams(currentPage: BottomNavigation.history))).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.history)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      final mockedEntity = Utils().dashboardEntity.copyWith(
        fullname: "fulan",
        photoUrl: "https://via.placeholder.com/60x60"
      );

      return Right(mockedEntity);
    });
    when(mockGetThemeUsecase(any)).thenAnswer((_) async => const Right(SettingsEntity(themeMode: Brightness.dark)));
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Left(ServerFailure(message: Failure.generalError, data: []));
    });

    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      currentTotalTasks += 10;
      return Right(Utils().getTaskEntities(start: 0, end: currentTotalTasks));
    });

    when(mockGetRefreshHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      currentTotalTasks = 10;
      return Right(Utils().getTaskEntities(start: 0, end: currentTotalTasks));
    });

    await tester.runAsync(() async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(main);
      await tester.pumpAndSettle();

      verify(mockGetIsSkipUsecase(NoParam()));
      await tester.tap(find.byKey(const Key("getStartedButton")));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key("usernameField")), "fulan@email.com");
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key("passwordField")), "Password123");
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key("submitButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("submitButton")));
      await tester.pump();

      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      
      expect(find.text("Loading..."), findsNothing);
      await tester.pump();
      
      expect(find.text("Home"), findsWidgets);
      expect(find.text("Event"), findsWidgets);
      expect(find.text("History"), findsWidgets);
      expect(find.text("Settings"), findsWidgets);
      Image imageProfile = tester.widget(find.byKey(const Key("imageProfile")));
      expect((imageProfile.image as NetworkImage).url, "https://via.placeholder.com/60x60/F24B59/F24B59?text=.");

      await tester.pump();
      await Future.delayed(const Duration(seconds: 1));
      expect(find.text("Loading..."), findsOneWidget);
      await tester.pumpAndSettle();
      
      expect(find.text("Loading..."), findsNothing);
      imageProfile = tester.widget(find.byKey(const Key("imageProfile")));
      expect((imageProfile.image as NetworkImage).url, "https://via.placeholder.com/60x60");
      expect(find.text("You have 20 tasks right now"), findsOneWidget);
      expect(find.text("20%"), findsOneWidget);
      expect(find.text("5"), findsOneWidget);

      Iterable<Container> bars = tester.widgetList<Container>(find.byKey(const Key("bar")));
      for (var i = 0; i < bars.length; i++) {
        BoxDecoration decoration = bars.elementAt(i).decoration as BoxDecoration;
       
        if (i == (DateTime.now().weekday - 1)) {
          expect(decoration.color, CustomColors.primary);
          continue;
        }

        expect(decoration.color, CustomColors.placeholderText.withOpacity(0.16));
      }

      await tester.tap(find.byKey(const Key("navHistory")));
      await tester.pump();
      await Future.delayed(const Duration(seconds: 1));
      await tester.pump();
      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.text("Loading..."), findsNothing);
      await tester.pump();
      expect(find.byKey(const Key("responseDialog")), findsOneWidget);
      await tester.pump();
      expect(find.byKey(const Key("dismissButton")), findsOneWidget);
      await tester.tap(find.byKey(const Key("dismissButton")));
      await tester.pump();
      await Future.delayed(const Duration(seconds: 1));
      await tester.pump();
      expect(find.byKey(const Key("responseDialog")), findsNothing);

      handle.dispose();
    });

  });

  testWidgets("Should get more history properly", (WidgetTester tester) async {
    int currentTotalTasks = 0;
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));
    when(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true))).thenAnswer((_) async => const Right(null));
    when(mockLoginUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Right(null);
    });
    when(mockGetActiveBottomNavigationUsecase(NoParam())).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockSetActiveBottomNavigationUsecase(const BottomNavigationParams(currentPage: BottomNavigation.history))).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.history)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      final mockedEntity = Utils().dashboardEntity.copyWith(
        fullname: "fulan",
        photoUrl: "https://via.placeholder.com/60x60"
      );

      return Right(mockedEntity);
    });
    when(mockGetThemeUsecase(any)).thenAnswer((_) async => const Right(SettingsEntity(themeMode: Brightness.dark)));
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      currentTotalTasks += 10;
      return Right(Utils().getTaskEntities(end: currentTotalTasks));
    });

    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      currentTotalTasks += 10;
      return Right(Utils().getTaskEntities(start: 0, end: currentTotalTasks));
    });

    when(mockGetRefreshHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      currentTotalTasks = 10;
      return Right(Utils().getTaskEntities(start: 0, end: currentTotalTasks));
    });

    await tester.runAsync(() async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(main);
      await tester.pumpAndSettle();

      verify(mockGetIsSkipUsecase(NoParam()));
      await tester.tap(find.byKey(const Key("getStartedButton")));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key("usernameField")), "fulan@email.com");
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key("passwordField")), "Password123");
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key("submitButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("submitButton")));
      await tester.pump();

      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      
      expect(find.text("Loading..."), findsNothing);
      await tester.pump();
      
      expect(find.text("Home"), findsWidgets);
      expect(find.text("Event"), findsWidgets);
      expect(find.text("History"), findsWidgets);
      expect(find.text("Settings"), findsWidgets);
      Image imageProfile = tester.widget(find.byKey(const Key("imageProfile")));
      expect((imageProfile.image as NetworkImage).url, "https://via.placeholder.com/60x60/F24B59/F24B59?text=.");

      await tester.pump();
      await Future.delayed(const Duration(seconds: 1));
      expect(find.text("Loading..."), findsOneWidget);
      await tester.pumpAndSettle();
      
      expect(find.text("Loading..."), findsNothing);
      imageProfile = tester.widget(find.byKey(const Key("imageProfile")));
      expect((imageProfile.image as NetworkImage).url, "https://via.placeholder.com/60x60");
      expect(find.text("You have 20 tasks right now"), findsOneWidget);
      expect(find.text("20%"), findsOneWidget);
      expect(find.text("5"), findsOneWidget);

      Iterable<Container> bars = tester.widgetList<Container>(find.byKey(const Key("bar")));
      for (var i = 0; i < bars.length; i++) {
        BoxDecoration decoration = bars.elementAt(i).decoration as BoxDecoration;
       
        if (i == (DateTime.now().weekday - 1)) {
          expect(decoration.color, CustomColors.primary);
          continue;
        }

        expect(decoration.color, CustomColors.placeholderText.withOpacity(0.16));
      }

      await tester.tap(find.byKey(const Key("navHistory")));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(currentTotalTasks, 10);
      
      for (var i = 0; i < 10; i++) {
        await tester.scrollUntilVisible(
          find.byKey(ValueKey('TaskTile$i')),
          100.0,
          scrollable: find.byType(Scrollable),
        );
      }

      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(currentTotalTasks, 20);

      for (var i = 9; i >= 0; i--) {
        await tester.scrollUntilVisible(
          find.byKey(ValueKey('TaskTile$i')),
          -100.0,
          scrollable: find.byType(Scrollable),
        );
      }

      for (var i = 0; i < 20; i++) {
        await tester.scrollUntilVisible(
          find.byKey(ValueKey('TaskTile$i')),
          100.0,
          scrollable: find.byType(Scrollable),
        );
      }

      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      for (var i = 19; i >= 0; i--) {
        await tester.scrollUntilVisible(
          find.byKey(ValueKey('TaskTile$i')),
          -100.0,
          scrollable: find.byType(Scrollable),
        );
      }

      handle.dispose();
    });
    
  });

  testWidgets("Should display only data from get history when get more history returns failure", (WidgetTester tester) async {
    int currentTotalTasks = 0;
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));
    when(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true))).thenAnswer((_) async => const Right(null));
    when(mockLoginUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Right(null);
    });
    when(mockGetActiveBottomNavigationUsecase(NoParam())).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockSetActiveBottomNavigationUsecase(const BottomNavigationParams(currentPage: BottomNavigation.history))).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.history)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      final mockedEntity = Utils().dashboardEntity.copyWith(
        fullname: "fulan",
        photoUrl: "https://via.placeholder.com/60x60"
      );

      return Right(mockedEntity);
    });
    when(mockGetThemeUsecase(any)).thenAnswer((_) async => const Right(SettingsEntity(themeMode: Brightness.dark)));
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      currentTotalTasks += 10;
      return Right(Utils().getTaskEntities(end: currentTotalTasks));
    });

    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return Left(ServerFailure(message: Failure.generalError, data: Utils().getTaskEntities(end: currentTotalTasks)));
    });

    when(mockGetRefreshHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      currentTotalTasks = 10;
      return Right(Utils().getTaskEntities(start: 0, end: currentTotalTasks));
    });

    await tester.runAsync(() async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(main);
      await tester.pumpAndSettle();

      verify(mockGetIsSkipUsecase(NoParam()));
      await tester.tap(find.byKey(const Key("getStartedButton")));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key("usernameField")), "fulan@email.com");
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key("passwordField")), "Password123");
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key("submitButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("submitButton")));
      await tester.pump();

      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      
      expect(find.text("Loading..."), findsNothing);
      await tester.pump();
      
      expect(find.text("Home"), findsWidgets);
      expect(find.text("Event"), findsWidgets);
      expect(find.text("History"), findsWidgets);
      expect(find.text("Settings"), findsWidgets);
      Image imageProfile = tester.widget(find.byKey(const Key("imageProfile")));
      expect((imageProfile.image as NetworkImage).url, "https://via.placeholder.com/60x60/F24B59/F24B59?text=.");

      await tester.pump();
      await Future.delayed(const Duration(seconds: 1));
      expect(find.text("Loading..."), findsOneWidget);
      await tester.pumpAndSettle();
      
      expect(find.text("Loading..."), findsNothing);
      imageProfile = tester.widget(find.byKey(const Key("imageProfile")));
      expect((imageProfile.image as NetworkImage).url, "https://via.placeholder.com/60x60");
      expect(find.text("You have 20 tasks right now"), findsOneWidget);
      expect(find.text("20%"), findsOneWidget);
      expect(find.text("5"), findsOneWidget);

      Iterable<Container> bars = tester.widgetList<Container>(find.byKey(const Key("bar")));
      for (var i = 0; i < bars.length; i++) {
        BoxDecoration decoration = bars.elementAt(i).decoration as BoxDecoration;
       
        if (i == (DateTime.now().weekday - 1)) {
          expect(decoration.color, CustomColors.primary);
          continue;
        }

        expect(decoration.color, CustomColors.placeholderText.withOpacity(0.16));
      }

      await tester.tap(find.byKey(const Key("navHistory")));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(currentTotalTasks, 10);
      
      for (var i = 0; i < 10; i++) {
        await tester.scrollUntilVisible(
          find.byKey(ValueKey('TaskTile$i')),
          100.0,
          scrollable: find.byType(Scrollable),
        );
      }

      await tester.pump();
      await Future.delayed(const Duration(seconds: 1));
      await tester.pump();
      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.text("Loading..."), findsNothing);
      await tester.pump();
      expect(currentTotalTasks, 10);
      expect(find.byKey(const Key("responseDialog")), findsOneWidget);
      await tester.pump();
      expect(find.byKey(const Key("dismissButton")), findsOneWidget);
      await tester.tap(find.byKey(const Key("dismissButton")));
      await tester.pump();
      await Future.delayed(const Duration(seconds: 1));
      await tester.pump();
      expect(find.byKey(const Key("responseDialog")), findsNothing);

      handle.dispose();
    });
  });

  testWidgets("Should get refresh history properly", (WidgetTester tester) async {
    int currentTotalTasks = 0;
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));
    when(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true))).thenAnswer((_) async => const Right(null));
    when(mockLoginUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Right(null);
    });
    when(mockGetActiveBottomNavigationUsecase(NoParam())).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockSetActiveBottomNavigationUsecase(const BottomNavigationParams(currentPage: BottomNavigation.history))).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.history)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      final mockedEntity = Utils().dashboardEntity.copyWith(
        fullname: "fulan",
        photoUrl: "https://via.placeholder.com/60x60"
      );

      return Right(mockedEntity);
    });
    when(mockGetThemeUsecase(any)).thenAnswer((_) async => const Right(SettingsEntity(themeMode: Brightness.dark)));
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      currentTotalTasks += 10;
      return Right(Utils().getTaskEntities(end: currentTotalTasks));
    });

    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      currentTotalTasks += 10;
      return Right(Utils().getTaskEntities(start: 0, end: currentTotalTasks));
    });

    when(mockGetRefreshHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      currentTotalTasks = 10;
      return Right(Utils().getTaskEntities(start: 10, end: 20));
    });

    await tester.runAsync(() async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(main);
      await tester.pumpAndSettle();

      verify(mockGetIsSkipUsecase(NoParam()));
      await tester.tap(find.byKey(const Key("getStartedButton")));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key("usernameField")), "fulan@email.com");
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key("passwordField")), "Password123");
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key("submitButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("submitButton")));
      await tester.pump();

      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      
      expect(find.text("Loading..."), findsNothing);
      await tester.pump();
      
      expect(find.text("Home"), findsWidgets);
      expect(find.text("Event"), findsWidgets);
      expect(find.text("History"), findsWidgets);
      expect(find.text("Settings"), findsWidgets);
      Image imageProfile = tester.widget(find.byKey(const Key("imageProfile")));
      expect((imageProfile.image as NetworkImage).url, "https://via.placeholder.com/60x60/F24B59/F24B59?text=.");

      await tester.pump();
      await Future.delayed(const Duration(seconds: 1));
      expect(find.text("Loading..."), findsOneWidget);
      await tester.pumpAndSettle();
      
      expect(find.text("Loading..."), findsNothing);
      imageProfile = tester.widget(find.byKey(const Key("imageProfile")));
      expect((imageProfile.image as NetworkImage).url, "https://via.placeholder.com/60x60");
      expect(find.text("You have 20 tasks right now"), findsOneWidget);
      expect(find.text("20%"), findsOneWidget);
      expect(find.text("5"), findsOneWidget);

      Iterable<Container> bars = tester.widgetList<Container>(find.byKey(const Key("bar")));
      for (var i = 0; i < bars.length; i++) {
        BoxDecoration decoration = bars.elementAt(i).decoration as BoxDecoration;
       
        if (i == (DateTime.now().weekday - 1)) {
          expect(decoration.color, CustomColors.primary);
          continue;
        }

        expect(decoration.color, CustomColors.placeholderText.withOpacity(0.16));
      }

      await tester.tap(find.byKey(const Key("navHistory")));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(currentTotalTasks, 10);
      
      for (var i = 0; i < 10; i++) {
        await tester.scrollUntilVisible(
          find.byKey(ValueKey('TaskTile$i')),
          100.0,
          scrollable: find.byType(Scrollable),
        );
      }

      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(currentTotalTasks, 20);

      for (var i = 9; i >= 0; i--) {
        await tester.scrollUntilVisible(
          find.byKey(ValueKey('TaskTile$i')),
          -100.0,
          scrollable: find.byType(Scrollable),
        );
      }

      expect(find.byKey(const Key("TaskTile0")), findsOneWidget);
      await tester.fling(find.byKey(const Key("TaskTile0")), const Offset(0.0, 50.0), 1000.0);
      await tester.pump();

      await tester.fling(find.byKey(const Key("TaskTile0")), const Offset(0.0, 200.0), 1000.0);
      await tester.pump();

      expect(tester.getSemantics(find.byType(RefreshProgressIndicator)), matchesSemantics(label: 'Refresh'));

      await tester.pump(const Duration(seconds: 1)); // finish the scroll animation
      await tester.pump(const Duration(seconds: 1)); // finish the indicator settle animation
      await tester.pump(const Duration(seconds: 1)); // finish the indicator hide animation
      
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(currentTotalTasks, 10);

      for (var i = 10; i < 20; i++) {
        await tester.scrollUntilVisible(
          find.byKey(ValueKey('TaskTile$i')),
          100.0,
          scrollable: find.byType(Scrollable),
        );
      }

      handle.dispose();
    });
    
  });

  testWidgets("Should display only data from get history when refresh history returns failure", (WidgetTester tester) async {
    int currentTotalTasks = 0;
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));
    when(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true))).thenAnswer((_) async => const Right(null));
    when(mockLoginUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Right(null);
    });
    when(mockGetActiveBottomNavigationUsecase(NoParam())).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockSetActiveBottomNavigationUsecase(const BottomNavigationParams(currentPage: BottomNavigation.history))).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.history)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      final mockedEntity = Utils().dashboardEntity.copyWith(
        fullname: "fulan",
        photoUrl: "https://via.placeholder.com/60x60"
      );

      return Right(mockedEntity);
    });
    when(mockGetThemeUsecase(any)).thenAnswer((_) async => const Right(SettingsEntity(themeMode: Brightness.dark)));
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      currentTotalTasks += 10;
      return Right(Utils().getTaskEntities(end: currentTotalTasks));
    });

    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      currentTotalTasks += 10;
      return Right(Utils().getTaskEntities(start: 0, end: currentTotalTasks));
    });

    when(mockGetRefreshHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      currentTotalTasks = 10;
      return Left(ServerFailure(message: Failure.generalError, data: Utils().getTaskEntities(end: currentTotalTasks)));
    });

    await tester.runAsync(() async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(main);
      await tester.pumpAndSettle();

      verify(mockGetIsSkipUsecase(NoParam()));
      await tester.tap(find.byKey(const Key("getStartedButton")));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key("usernameField")), "fulan@email.com");
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key("passwordField")), "Password123");
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key("submitButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("submitButton")));
      await tester.pump();

      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      
      expect(find.text("Loading..."), findsNothing);
      await tester.pump();
      
      expect(find.text("Home"), findsWidgets);
      expect(find.text("Event"), findsWidgets);
      expect(find.text("History"), findsWidgets);
      expect(find.text("Settings"), findsWidgets);
      Image imageProfile = tester.widget(find.byKey(const Key("imageProfile")));
      expect((imageProfile.image as NetworkImage).url, "https://via.placeholder.com/60x60/F24B59/F24B59?text=.");

      await tester.pump();
      await Future.delayed(const Duration(seconds: 1));
      expect(find.text("Loading..."), findsOneWidget);
      await tester.pumpAndSettle();
      
      expect(find.text("Loading..."), findsNothing);
      imageProfile = tester.widget(find.byKey(const Key("imageProfile")));
      expect((imageProfile.image as NetworkImage).url, "https://via.placeholder.com/60x60");
      expect(find.text("You have 20 tasks right now"), findsOneWidget);
      expect(find.text("20%"), findsOneWidget);
      expect(find.text("5"), findsOneWidget);

      Iterable<Container> bars = tester.widgetList<Container>(find.byKey(const Key("bar")));
      for (var i = 0; i < bars.length; i++) {
        BoxDecoration decoration = bars.elementAt(i).decoration as BoxDecoration;
       
        if (i == (DateTime.now().weekday - 1)) {
          expect(decoration.color, CustomColors.primary);
          continue;
        }

        expect(decoration.color, CustomColors.placeholderText.withOpacity(0.16));
      }

      await tester.tap(find.byKey(const Key("navHistory")));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(currentTotalTasks, 10);
      
      for (var i = 0; i < 10; i++) {
        await tester.scrollUntilVisible(
          find.byKey(ValueKey('TaskTile$i')),
          100.0,
          scrollable: find.byType(Scrollable),
        );
      }

      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(currentTotalTasks, 20);

      for (var i = 9; i >= 0; i--) {
        await tester.scrollUntilVisible(
          find.byKey(ValueKey('TaskTile$i')),
          -100.0,
          scrollable: find.byType(Scrollable),
        );
      }

      expect(find.byKey(const Key("TaskTile0")), findsOneWidget);
      await tester.fling(find.byKey(const Key("TaskTile0")), const Offset(0.0, 50.0), 1000.0);
      await tester.pump();

      await tester.fling(find.byKey(const Key("TaskTile0")), const Offset(0.0, 200.0), 1000.0);
      await tester.pump();

      expect(tester.getSemantics(find.byType(RefreshProgressIndicator)), matchesSemantics(label: 'Refresh'));

      await tester.pump(const Duration(seconds: 1)); // finish the scroll animation
      await tester.pump(const Duration(seconds: 1)); // finish the indicator settle animation
      await tester.pump();
      await Future.delayed(const Duration(seconds: 1));
      await tester.pump();
      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.text("Loading..."), findsNothing);
      await tester.pump();
      expect(currentTotalTasks, 10);
      expect(find.byKey(const Key("responseDialog")), findsOneWidget);
      await tester.pump();
      expect(find.byKey(const Key("dismissButton")), findsOneWidget);
      await tester.tap(find.byKey(const Key("dismissButton")));
      await tester.pump();
      await Future.delayed(const Duration(seconds: 1));
      await tester.pump();
      expect(find.byKey(const Key("responseDialog")), findsNothing);

      handle.dispose();
    });

  });


  testWidgets("Should get refresh history properly after get more history", (WidgetTester tester) async {
    int currentTotalTasks = 0;
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));
    when(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true))).thenAnswer((_) async => const Right(null));
    when(mockLoginUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Right(null);
    });
    when(mockGetActiveBottomNavigationUsecase(NoParam())).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockSetActiveBottomNavigationUsecase(const BottomNavigationParams(currentPage: BottomNavigation.history))).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.history)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      final mockedEntity = Utils().dashboardEntity.copyWith(
        fullname: "fulan",
        photoUrl: "https://via.placeholder.com/60x60"
      );

      return Right(mockedEntity);
    });
    when(mockGetThemeUsecase(any)).thenAnswer((_) async => const Right(SettingsEntity(themeMode: Brightness.dark)));
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      currentTotalTasks += 10;
      return Right(Utils().getTaskEntities(end: currentTotalTasks));
    });

    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      currentTotalTasks += 10;
      return Right(Utils().getTaskEntities(start: 0, end: currentTotalTasks));
    });

    when(mockGetRefreshHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      currentTotalTasks = 10;
      return Right(Utils().getTaskEntities(start: 0, end: currentTotalTasks));
    });

    await tester.runAsync(() async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(main);
      await tester.pumpAndSettle();

      verify(mockGetIsSkipUsecase(NoParam()));
      await tester.tap(find.byKey(const Key("getStartedButton")));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key("usernameField")), "fulan@email.com");
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key("passwordField")), "Password123");
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key("submitButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("submitButton")));
      await tester.pump();

      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      
      expect(find.text("Loading..."), findsNothing);
      await tester.pump();
      
      expect(find.text("Home"), findsWidgets);
      expect(find.text("Event"), findsWidgets);
      expect(find.text("History"), findsWidgets);
      expect(find.text("Settings"), findsWidgets);
      Image imageProfile = tester.widget(find.byKey(const Key("imageProfile")));
      expect((imageProfile.image as NetworkImage).url, "https://via.placeholder.com/60x60/F24B59/F24B59?text=.");

      await tester.pump();
      await Future.delayed(const Duration(seconds: 1));
      expect(find.text("Loading..."), findsOneWidget);
      await tester.pumpAndSettle();
      
      expect(find.text("Loading..."), findsNothing);
      imageProfile = tester.widget(find.byKey(const Key("imageProfile")));
      expect((imageProfile.image as NetworkImage).url, "https://via.placeholder.com/60x60");
      expect(find.text("You have 20 tasks right now"), findsOneWidget);
      expect(find.text("20%"), findsOneWidget);
      expect(find.text("5"), findsOneWidget);

      Iterable<Container> bars = tester.widgetList<Container>(find.byKey(const Key("bar")));
      for (var i = 0; i < bars.length; i++) {
        BoxDecoration decoration = bars.elementAt(i).decoration as BoxDecoration;
       
        if (i == (DateTime.now().weekday - 1)) {
          expect(decoration.color, CustomColors.primary);
          continue;
        }

        expect(decoration.color, CustomColors.placeholderText.withOpacity(0.16));
      }

      await tester.tap(find.byKey(const Key("navHistory")));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(currentTotalTasks, 10);
      
      for (var i = 0; i < 10; i++) {
        await tester.scrollUntilVisible(
          find.byKey(ValueKey('TaskTile$i')),
          100.0,
          scrollable: find.byType(Scrollable),
        );
      }

      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(currentTotalTasks, 20);

      for (var i = 9; i >= 0; i--) {
        await tester.scrollUntilVisible(
          find.byKey(ValueKey('TaskTile$i')),
          -100.0,
          scrollable: find.byType(Scrollable),
        );
      }

      for (var i = 0; i < 20; i++) {
        await tester.scrollUntilVisible(
          find.byKey(ValueKey('TaskTile$i')),
          100.0,
          scrollable: find.byType(Scrollable),
        );
      }

      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      for (var i = 19; i >= 0; i--) {
        await tester.scrollUntilVisible(
          find.byKey(ValueKey('TaskTile$i')),
          -100.0,
          scrollable: find.byType(Scrollable),
        );
      }

      expect(find.byKey(const Key("TaskTile0")), findsOneWidget);
      await tester.fling(find.byKey(const Key("TaskTile0")), const Offset(0.0, 50.0), 1000.0);
      await tester.pump();

      await tester.fling(find.byKey(const Key("TaskTile0")), const Offset(0.0, 200.0), 1000.0);
      await tester.pump();

      expect(tester.getSemantics(find.byType(RefreshProgressIndicator)), matchesSemantics(label: 'Refresh'));

      await tester.pump(const Duration(seconds: 1)); // finish the scroll animation
      await tester.pump(const Duration(seconds: 1)); // finish the indicator settle animation
      await tester.pump(const Duration(seconds: 1)); // finish the indicator hide animation
      
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(currentTotalTasks, 10);

      handle.dispose();
    });
    
  });
  
  testWidgets("Should get more history properly after get refresh history", (WidgetTester tester) async {
    int currentTotalTasks = 0;
    int currentStart = 0;
    int currentEnd = 0;
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));
    when(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true))).thenAnswer((_) async => const Right(null));
    when(mockLoginUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Right(null);
    });
    when(mockGetActiveBottomNavigationUsecase(NoParam())).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockSetActiveBottomNavigationUsecase(const BottomNavigationParams(currentPage: BottomNavigation.history))).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.history)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      final mockedEntity = Utils().dashboardEntity.copyWith(
        fullname: "fulan",
        photoUrl: "https://via.placeholder.com/60x60"
      );

      return Right(mockedEntity);
    });
    when(mockGetThemeUsecase(any)).thenAnswer((_) async => const Right(SettingsEntity(themeMode: Brightness.dark)));
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      currentTotalTasks += 10;
      currentStart = 0;
      currentEnd = currentStart + currentTotalTasks;
      return Right(Utils().getTaskEntities(start: currentStart, end: currentEnd));
    });

    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      currentTotalTasks += 10;
      currentEnd = currentStart + currentTotalTasks;
      return Right(Utils().getTaskEntities(start: currentStart, end: currentEnd));
    });

    when(mockGetRefreshHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      currentTotalTasks = 10;
      currentStart = 10;
      currentEnd = currentStart + currentTotalTasks;
      return Right(Utils().getTaskEntities(start: currentStart, end: currentEnd));
    });

    await tester.runAsync(() async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(main);
      await tester.pumpAndSettle();

      verify(mockGetIsSkipUsecase(NoParam()));
      await tester.tap(find.byKey(const Key("getStartedButton")));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key("usernameField")), "fulan@email.com");
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key("passwordField")), "Password123");
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key("submitButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("submitButton")));
      await tester.pump();

      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      
      expect(find.text("Loading..."), findsNothing);
      await tester.pump();
      
      expect(find.text("Home"), findsWidgets);
      expect(find.text("Event"), findsWidgets);
      expect(find.text("History"), findsWidgets);
      expect(find.text("Settings"), findsWidgets);
      Image imageProfile = tester.widget(find.byKey(const Key("imageProfile")));
      expect((imageProfile.image as NetworkImage).url, "https://via.placeholder.com/60x60/F24B59/F24B59?text=.");

      await tester.pump();
      await Future.delayed(const Duration(seconds: 1));
      expect(find.text("Loading..."), findsOneWidget);
      await tester.pumpAndSettle();
      
      expect(find.text("Loading..."), findsNothing);
      imageProfile = tester.widget(find.byKey(const Key("imageProfile")));
      expect((imageProfile.image as NetworkImage).url, "https://via.placeholder.com/60x60");
      expect(find.text("You have 20 tasks right now"), findsOneWidget);
      expect(find.text("20%"), findsOneWidget);
      expect(find.text("5"), findsOneWidget);

      Iterable<Container> bars = tester.widgetList<Container>(find.byKey(const Key("bar")));
      for (var i = 0; i < bars.length; i++) {
        BoxDecoration decoration = bars.elementAt(i).decoration as BoxDecoration;
       
        if (i == (DateTime.now().weekday - 1)) {
          expect(decoration.color, CustomColors.primary);
          continue;
        }

        expect(decoration.color, CustomColors.placeholderText.withOpacity(0.16));
      }

      await tester.tap(find.byKey(const Key("navHistory")));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(currentTotalTasks, 10);
      
      for (var i = 0; i < 10; i++) {
        await tester.scrollUntilVisible(
          find.byKey(ValueKey('TaskTile$i')),
          100.0,
          scrollable: find.byType(Scrollable),
        );
      }

      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(currentTotalTasks, 20);

      for (var i = 9; i >= 0; i--) {
        await tester.scrollUntilVisible(
          find.byKey(ValueKey('TaskTile$i')),
          -100.0,
          scrollable: find.byType(Scrollable),
        );
      }

      expect(find.byKey(const Key("TaskTile0")), findsOneWidget);

      await tester.fling(find.byKey(const Key("TaskTile0")), const Offset(0.0, 50.0), 1000.0);
      await tester.pump();
      await tester.fling(find.byKey(const Key("TaskTile0")), const Offset(0.0, 200.0), 1000.0);
      await tester.pump();

      expect(tester.getSemantics(find.byType(RefreshProgressIndicator)), matchesSemantics(label: 'Refresh'));

      await tester.pump(const Duration(seconds: 1)); // finish the scroll animation
      await tester.pump(const Duration(seconds: 1)); // finish the indicator settle animation
      await tester.pump(const Duration(seconds: 1)); // finish the indicator hide animation
      
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(currentTotalTasks, 10);

      for (var i = 10; i < 20; i++) {
        await tester.scrollUntilVisible(
          find.byKey(ValueKey('TaskTile$i')),
          100.0,
          scrollable: find.byType(Scrollable),
        );
      }

      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      for (var i = 19; i >= 10; i--) {
        await tester.scrollUntilVisible(
          find.byKey(ValueKey('TaskTile$i')),
          -100.0,
          scrollable: find.byType(Scrollable),
        );
      }

      for (var i = 10; i < 30; i++) {
        await tester.scrollUntilVisible(
          find.byKey(ValueKey('TaskTile$i')),
          100.0,
          scrollable: find.byType(Scrollable),
        );
      }

      handle.dispose();
    });
    
  });
}
