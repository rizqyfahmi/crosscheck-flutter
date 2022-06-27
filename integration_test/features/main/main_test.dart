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

import 'main_test.mocks.dart';

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

  testWidgets("Should display main preview properly", (WidgetTester tester) async {
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => Left(CachedFailure(message: Failure.cacheError)));
    when(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true))).thenAnswer((_) async => const Right(null));
    when(mockLoginUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Right(null);
    });
    when(mockGetActiveBottomNavigationUsecase(NoParam())).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockSetActiveBottomNavigationUsecase(const BottomNavigationParams(currentPage: BottomNavigation.event))).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.event)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async => Right(entity));
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
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.text("Home"), findsWidgets);
      expect(find.text("Event"), findsWidgets);
      expect(find.text("History"), findsWidgets);
      expect(find.text("Settings"), findsWidgets);
      expect(find.byKey(const Key("plusButton")), findsOneWidget);

      Text homeText = tester.widget<Text>(find.byKey(const Key("navHomeText")));
      expect(homeText.style?.color, CustomColors.primary);
      Text eventText = tester.widget<Text>(find.byKey(const Key("navEventText")));
      expect(eventText.style?.color, isNot(CustomColors.primary));
      Text historyText = tester.widget<Text>(find.byKey(const Key("navHistoryText")));
      expect(historyText.style?.color, isNot(CustomColors.primary));
      Text settingText = tester.widget<Text>(find.byKey(const Key("navSettingText")));
      expect(settingText.style?.color, isNot(CustomColors.primary));

    });
    
  });

  testWidgets("Should go to event menu properly", (WidgetTester tester) async {
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => Left(CachedFailure(message: Failure.cacheError)));
    when(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true))).thenAnswer((_) async => const Right(null));
    when(mockLoginUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Right(null);
    });
    when(mockGetActiveBottomNavigationUsecase(NoParam())).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockSetActiveBottomNavigationUsecase(const BottomNavigationParams(currentPage: BottomNavigation.event))).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.event)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async => Right(entity));
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
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.text("Home"), findsWidgets);
      expect(find.text("Event"), findsWidgets);
      expect(find.text("History"), findsWidgets);
      expect(find.text("Settings"), findsWidgets);
      expect(find.byKey(const Key("plusButton")), findsOneWidget);

      Text homeText = tester.widget<Text>(find.byKey(const Key("navHomeText")));
      expect(homeText.style?.color, CustomColors.primary);
      Text eventText = tester.widget<Text>(find.byKey(const Key("navEventText")));
      expect(eventText.style?.color, isNot(CustomColors.primary));
      Text historyText = tester.widget<Text>(find.byKey(const Key("navHistoryText")));
      expect(historyText.style?.color, isNot(CustomColors.primary));
      Text settingText = tester.widget<Text>(find.byKey(const Key("navSettingText")));
      expect(settingText.style?.color, isNot(CustomColors.primary));

      await tester.tap(find.byKey(const Key("navEvent")));
      await tester.pumpAndSettle();

      homeText = tester.widget<Text>(find.byKey(const Key("navHomeText")));
      expect(homeText.style?.color, isNot(CustomColors.primary));
      eventText = tester.widget<Text>(find.byKey(const Key("navEventText")));
      expect(eventText.style?.color, CustomColors.primary);
      historyText = tester.widget<Text>(find.byKey(const Key("navHistoryText")));
      expect(historyText.style?.color, isNot(CustomColors.primary));
      settingText = tester.widget<Text>(find.byKey(const Key("navSettingText")));
      expect(settingText.style?.color, isNot(CustomColors.primary));

    });
    
  });

  testWidgets("Should go to history menu properly", (WidgetTester tester) async {
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => Left(CachedFailure(message: Failure.cacheError)));
    when(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true))).thenAnswer((_) async => const Right(null));
    when(mockLoginUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Right(null);
    });
    when(mockGetActiveBottomNavigationUsecase(NoParam())).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockSetActiveBottomNavigationUsecase(const BottomNavigationParams(currentPage: BottomNavigation.history))).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.history)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async => Right(entity));
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
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.text("Home"), findsWidgets);
      expect(find.text("Event"), findsWidgets);
      expect(find.text("History"), findsWidgets);
      expect(find.text("Settings"), findsWidgets);
      expect(find.byKey(const Key("plusButton")), findsOneWidget);

      Text homeText = tester.widget<Text>(find.byKey(const Key("navHomeText")));
      expect(homeText.style?.color, CustomColors.primary);
      Text eventText = tester.widget<Text>(find.byKey(const Key("navEventText")));
      expect(eventText.style?.color, isNot(CustomColors.primary));
      Text historyText = tester.widget<Text>(find.byKey(const Key("navHistoryText")));
      expect(historyText.style?.color, isNot(CustomColors.primary));
      Text settingText = tester.widget<Text>(find.byKey(const Key("navSettingText")));
      expect(settingText.style?.color, isNot(CustomColors.primary));

      await tester.tap(find.byKey(const Key("navHistory")));
      await tester.pumpAndSettle();

      homeText = tester.widget<Text>(find.byKey(const Key("navHomeText")));
      expect(homeText.style?.color, isNot(CustomColors.primary));
      eventText = tester.widget<Text>(find.byKey(const Key("navEventText")));
      expect(eventText.style?.color, isNot(CustomColors.primary));
      historyText = tester.widget<Text>(find.byKey(const Key("navHistoryText")));
      expect(historyText.style?.color, CustomColors.primary);
      settingText = tester.widget<Text>(find.byKey(const Key("navSettingText")));
      expect(settingText.style?.color, isNot(CustomColors.primary));

    });
    
  });

  testWidgets("Should go to settings menu properly", (WidgetTester tester) async {
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => Left(CachedFailure(message: Failure.cacheError)));
    when(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true))).thenAnswer((_) async => const Right(null));
    when(mockLoginUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Right(null);
    });
    when(mockGetActiveBottomNavigationUsecase(NoParam())).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockSetActiveBottomNavigationUsecase(const BottomNavigationParams(currentPage: BottomNavigation.setting))).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.setting)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async => Right(entity));
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
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.text("Home"), findsWidgets);
      expect(find.text("Event"), findsWidgets);
      expect(find.text("History"), findsWidgets);
      expect(find.text("Settings"), findsWidgets);
      expect(find.byKey(const Key("plusButton")), findsOneWidget);

      Text homeText = tester.widget<Text>(find.byKey(const Key("navHomeText")));
      expect(homeText.style?.color, CustomColors.primary);
      Text eventText = tester.widget<Text>(find.byKey(const Key("navEventText")));
      expect(eventText.style?.color, isNot(CustomColors.primary));
      Text historyText = tester.widget<Text>(find.byKey(const Key("navHistoryText")));
      expect(historyText.style?.color, isNot(CustomColors.primary));
      Text settingText = tester.widget<Text>(find.byKey(const Key("navSettingText")));
      expect(settingText.style?.color, isNot(CustomColors.primary));

      await tester.tap(find.byKey(const Key("navSetting")));
      await tester.pumpAndSettle();

      homeText = tester.widget<Text>(find.byKey(const Key("navHomeText")));
      expect(homeText.style?.color, isNot(CustomColors.primary));
      eventText = tester.widget<Text>(find.byKey(const Key("navEventText")));
      expect(eventText.style?.color, isNot(CustomColors.primary));
      historyText = tester.widget<Text>(find.byKey(const Key("navHistoryText")));
      expect(historyText.style?.color, isNot(CustomColors.primary));
      settingText = tester.widget<Text>(find.byKey(const Key("navSettingText")));
      expect(settingText.style?.color, CustomColors.primary);

    });
    
  });

}