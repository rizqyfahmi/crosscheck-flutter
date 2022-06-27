
import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/features/authentication/domain/usecases/login_usecase.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/login/bloc/login_bloc.dart';
import 'package:crosscheck/features/dashboard/domain/entities/activity_entity.dart';
import 'package:crosscheck/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:crosscheck/features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:crosscheck/features/main/data/model/data/bottom_navigation_model.dart';
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

import 'dashboard_view_test.mocks.dart';

@GenerateMocks([
  LoginUsecase,
  SetIsSkipUsecase,
  GetIsSkipUsecase,
  SetActiveBottomNavigationUsecase,
  GetActiveBottomNavigationUsecase,
  GetDashboardUsecase,
  SetThemeUsecase,
  GetThemeUsecase
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
  late AuthenticationBloc authenticationBloc;
  late WalkthroughBloc walkthroughBloc;
  late LoginBloc loginBloc;
  late MainBloc mainBloc;
  late DashboardBloc dashboardBloc;
  late SettingsBloc settingsBloc;
  late Widget main;

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
  final DashboardEntity entity = DashboardEntity(progress: 20, upcoming: upcoming, completed: completed, activities: activities);

  setUp(() {
    mockLoginUsecase = MockLoginUsecase();
    mockSetIsSkipUsecase = MockSetIsSkipUsecase();
    mockGetIsSkipUsecase = MockGetIsSkipUsecase();
    mockGetActiveBottomNavigationUsecase = MockGetActiveBottomNavigationUsecase();
    mockSetActiveBottomNavigationUsecase = MockSetActiveBottomNavigationUsecase();
    mockGetDashboardUsecase = MockGetDashboardUsecase();
    mockSetThemeUsecase = MockSetThemeUsecase();
    mockGetThemeUsecase = MockGetThemeUsecase();

    authenticationBloc = AuthenticationBloc();
    walkthroughBloc = WalkthroughBloc(setIsSkipUsecase: mockSetIsSkipUsecase, getIsSkipUsecase: mockGetIsSkipUsecase);
    loginBloc = LoginBloc(loginUsecase: mockLoginUsecase);
    mainBloc = MainBloc(
      getActiveBottomNavigationUsecase: mockGetActiveBottomNavigationUsecase,
      setActiveBottomNavigationUsecase: mockSetActiveBottomNavigationUsecase
    );
    dashboardBloc = DashboardBloc(getDashboardUsecase: mockGetDashboardUsecase);
    settingsBloc = SettingsBloc(setThemeUsecase: mockSetThemeUsecase, getThemeUsecase: mockGetThemeUsecase);

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
      )
    ]);
  });

  testWidgets("Should properly load data on dashboard page", (WidgetTester tester) async {
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => Left(CachedFailure(message: Failure.cacheError)));
    when(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true))).thenAnswer((_) async => const Right(null));
    when(mockLoginUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Right(null);
    });
    when(mockGetActiveBottomNavigationUsecase(NoParam())).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockSetActiveBottomNavigationUsecase(const BottomNavigationParams(currentPage: BottomNavigation.event))).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.event)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return Right(entity);
    });
    when(mockGetThemeUsecase(any)).thenAnswer((_) async => const Right(SettingsEntity(themeMode: Brightness.dark)));

    await tester.runAsync(() async {
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
      
      await tester.pump();
      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();

      expect(find.text("Loading..."), findsNothing);
      expect(find.text("You have 20 tasks right now"), findsOneWidget);
      expect(find.text("20%"), findsOneWidget);
      expect(find.text("5"), findsOneWidget);

      Iterable<Container> bars = tester.widgetList<Container>(find.byKey(const Key("bar")));
      for (var i = 0; i < bars.length; i++) {
        BoxDecoration decoration = bars.elementAt(i).decoration as BoxDecoration;
       
        if (i == (currentDate.weekday - 1)) {
          expect(decoration.color, CustomColors.primary);
          continue;
        }

        expect(decoration.color, CustomColors.placeholderText.withOpacity(0.16));
      }

    });
    
  });

  testWidgets("Should display error modal on dashboard page", (WidgetTester tester) async {
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => Left(CachedFailure(message: Failure.cacheError)));
    when(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true))).thenAnswer((_) async => const Right(null));
    when(mockLoginUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Right(null);
    });
    when(mockGetActiveBottomNavigationUsecase(NoParam())).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockSetActiveBottomNavigationUsecase(const BottomNavigationParams(currentPage: BottomNavigation.event))).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.event)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return Left(ServerFailure(message: Failure.generalError));
    });
    when(mockGetThemeUsecase(any)).thenAnswer((_) async => const Right(SettingsEntity(themeMode: Brightness.dark)));

    await tester.runAsync(() async {
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
      
      await tester.pump();
      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();

      expect(find.text("Loading..."), findsNothing);
      await tester.ensureVisible(find.byKey(const Key("dismissButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("dismissButton")));
      await tester.pump();

    });
    
  });
}