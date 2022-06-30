import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/features/authentication/domain/usecases/login_usecase.dart';
import 'package:crosscheck/features/authentication/domain/usecases/registration_usecase.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/login/bloc/login_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/registration/bloc/registration_bloc.dart';
import 'package:crosscheck/features/dashboard/domain/entities/activity_entity.dart';
import 'package:crosscheck/features/dashboard/domain/entities/dashboard_entity.dart';
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

import 'settings_test.mocks.dart';

@GenerateMocks([
  RegistrationUsecase,
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
  late MockRegistrationUsecase mockRegistrationUsecase;
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
  late RegistrationBloc registrationBloc;
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
    mockRegistrationUsecase = MockRegistrationUsecase();
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
    registrationBloc = RegistrationBloc(registrationUsecase: mockRegistrationUsecase);
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
      BlocProvider<RegistrationBloc>(
        create: (_) => registrationBloc
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

  testWidgets("Should properly get default theme on walkthrough view", (WidgetTester tester) async {
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));
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

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, CustomColors.secondary);

      await tester.ensureVisible(find.byKey(const Key("textWelcome")));
      await tester.pumpAndSettle();
      final textWelcome = tester.widget<Text>(find.byKey(const Key("textWelcome")));
      expect(textWelcome.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("textWelcomeDescription")));
      await tester.pumpAndSettle();
      final textWelcomeDescription = tester.widget<Text>(find.byKey(const Key("textWelcomeDescription")));
      expect(textWelcomeDescription.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("textGetStarted")));
      await tester.pumpAndSettle();
      final textGetStarted = tester.widget<Text>(find.byKey(const Key("textGetStarted")));
      expect(textGetStarted.style?.color, CustomColors.primary);
      await tester.ensureVisible(find.byKey(const Key("getStartedButton")));
      await tester.pumpAndSettle();
      final getStartedButton = tester.widget<ElevatedButton>(find.byKey(const Key("getStartedButton")));
      expect(getStartedButton.style?.backgroundColor?.resolve(<MaterialState>{}), CustomColors.secondary);

      verify(mockGetIsSkipUsecase(NoParam()));
      await tester.tap(find.byKey(const Key("getStartedButton")));
      await tester.pumpAndSettle();

    });

  });

  testWidgets("Should properly get default theme on login view", (WidgetTester tester) async {
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));
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

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, CustomColors.secondary);

      await tester.ensureVisible(find.byKey(const Key("textWelcomeBack")));
      await tester.pumpAndSettle();
      final textWelcomeBack = tester.widget<Text>(find.byKey(const Key("textWelcomeBack")));
      expect(textWelcomeBack.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("textSignIn")));
      await tester.pumpAndSettle();
      final textSignIn = tester.widget<Text>(find.byKey(const Key("textSignIn")));
      expect(textSignIn.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("submitButton")));
      await tester.pumpAndSettle();
      final submitButton = tester.widget<ElevatedButton>(find.byKey(const Key("submitButton")));
      expect(submitButton.style?.backgroundColor?.resolve(<MaterialState>{}), CustomColors.primary);
      await tester.ensureVisible(find.byKey(const Key("textForgotPassword")));
      await tester.pumpAndSettle();
      final textForgotPassword = tester.widget<Text>(find.byKey(const Key("textForgotPassword")));
      expect(textForgotPassword.style?.color, CustomColors.primary);
      await tester.ensureVisible(find.byKey(const Key("textDontHaveAnAccount")));
      await tester.pumpAndSettle();
      final textDontHaveAnAccount = tester.widget<Text>(find.byKey(const Key("textDontHaveAnAccount")));
      expect(textDontHaveAnAccount.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("textSignUp")));
      await tester.pumpAndSettle();
      final textSignUp = tester.widget<Text>(find.byKey(const Key("textSignUp")));
      expect(textSignUp.style?.color, CustomColors.primary);

    });

  });

  testWidgets("Should properly get default theme on registration view", (WidgetTester tester) async {
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));
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

      await tester.ensureVisible(find.byKey(const Key("signUpTextButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("signUpTextButton")));
      await tester.pumpAndSettle();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, CustomColors.secondary);

      await tester.ensureVisible(find.byKey(const Key("textCreateYourAccount")));
      await tester.pumpAndSettle();
      final textCreateYourAccount = tester.widget<Text>(find.byKey(const Key("textCreateYourAccount")));
      expect(textCreateYourAccount.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("textCreateAnAccount")));
      await tester.pumpAndSettle();
      final textCreateAnAccount = tester.widget<Text>(find.byKey(const Key("textCreateAnAccount")));
      expect(textCreateAnAccount.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("submitButton")));
      await tester.pumpAndSettle();
      final submitButton = tester.widget<ElevatedButton>(find.byKey(const Key("submitButton")));
      expect(submitButton.style?.backgroundColor?.resolve(<MaterialState>{}), CustomColors.primary);
      await tester.ensureVisible(find.byKey(const Key("textAlreadyHaveAnAccount")));
      await tester.pumpAndSettle();
      final textAlreadyHaveAnAccount = tester.widget<Text>(find.byKey(const Key("textAlreadyHaveAnAccount")));
      expect(textAlreadyHaveAnAccount.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("textSignIn")));
      await tester.pumpAndSettle();
      final textSignIn = tester.widget<Text>(find.byKey(const Key("textSignIn")));
      expect(textSignIn.style?.color, CustomColors.primary);

      await tester.tap(find.byKey(const Key("signInTextButton")));
      await tester.pumpAndSettle();

    });

  });

  testWidgets("Should properly get default theme on settings view", (WidgetTester tester) async {
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));
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

      await tester.tap(find.byKey(const Key("navSetting")));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsWidgets);

      final scaffolds = tester.widgetList<Scaffold>(find.byType(Scaffold));
      expect(scaffolds.last.backgroundColor, CustomColors.secondary);
      
      await tester.ensureVisible(find.byKey(const Key("textUsername")));
      await tester.pumpAndSettle();
      final textUsername = tester.widget<Text>(find.byKey(const Key("textUsername")));
      expect(textUsername.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("textEmail")));
      await tester.pumpAndSettle();
      final textEmail = tester.widget<Text>(find.byKey(const Key("textEmail")));
      expect(textEmail.style?.color, Colors.white.withOpacity(0.5));
      await tester.ensureVisible(find.byKey(const Key("labelPersonalInformation")));
      await tester.pumpAndSettle();
      final labelPersonalInformation = tester.widget<Text>(find.byKey(const Key("labelPersonalInformation")));
      expect(labelPersonalInformation.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("labelFullName")));
      await tester.pumpAndSettle();
      final labelFullName = tester.widget<Text>(find.byKey(const Key("labelFullName")));
      expect(labelFullName.style?.color, Colors.white.withOpacity(0.5));
      await tester.ensureVisible(find.byKey(const Key("textFullName")));
      await tester.pumpAndSettle();
      final textFullName = tester.widget<Text>(find.byKey(const Key("textFullName")));
      expect(textFullName.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("labelEmailAddress")));
      await tester.pumpAndSettle();
      final labelEmailAddress = tester.widget<Text>(find.byKey(const Key("labelEmailAddress")));
      expect(labelEmailAddress.style?.color, Colors.white.withOpacity(0.5));
      await tester.ensureVisible(find.byKey(const Key("textEmailAddress")));
      await tester.pumpAndSettle();
      final textEmailAddress = tester.widget<Text>(find.byKey(const Key("textEmailAddress")));
      expect(textEmailAddress.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("labelDOB")));
      await tester.pumpAndSettle();
      final labelDOB = tester.widget<Text>(find.byKey(const Key("labelDOB")));
      expect(labelDOB.style?.color, Colors.white.withOpacity(0.5));
      await tester.ensureVisible(find.byKey(const Key("textDOB")));
      await tester.pumpAndSettle();
      final textDOB = tester.widget<Text>(find.byKey(const Key("textDOB")));
      expect(textDOB.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("labelAddress")));
      await tester.pumpAndSettle();
      final labelAddress = tester.widget<Text>(find.byKey(const Key("labelAddress")));
      expect(labelAddress.style?.color, Colors.white.withOpacity(0.5));
      await tester.ensureVisible(find.byKey(const Key("textAddress")));
      await tester.pumpAndSettle();
      final textAddress = tester.widget<Text>(find.byKey(const Key("textAddress")));
      expect(textAddress.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("labelOthers")));
      await tester.pumpAndSettle();
      final labelOthers = tester.widget<Text>(find.byKey(const Key("labelOthers")));
      expect(labelOthers.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("textChangePassword")));
      await tester.pumpAndSettle();
      final textChangePassword = tester.widget<Text>(find.byKey(const Key("textChangePassword")));
      expect(textChangePassword.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("textDarkMode")));
      await tester.pumpAndSettle();
      final textDarkMode = tester.widget<Text>(find.byKey(const Key("textDarkMode")));
      expect(textDarkMode.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("textAbout")));
      await tester.pumpAndSettle();
      final textAbout = tester.widget<Text>(find.byKey(const Key("textAbout")));
      expect(textAbout.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("textLogout")));
      await tester.pumpAndSettle();
      final textLogout = tester.widget<Text>(find.byKey(const Key("textLogout")));
      expect(textLogout.style?.color, Colors.white);

    });

  });

  testWidgets("Should properly get default theme on dashboard view", (WidgetTester tester) async {
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));
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

     
      expect(find.byType(Scaffold), findsWidgets);
      final scaffolds = tester.widgetList<Scaffold>(find.byType(Scaffold));
      expect(scaffolds.last.backgroundColor, CustomColors.secondary);
      
      await tester.ensureVisible(find.byKey(const Key("labelWelcomeBack")));
      await tester.pumpAndSettle();
      final labelWelcomeBack = tester.widget<Text>(find.byKey(const Key("labelWelcomeBack")));
      expect(labelWelcomeBack.style?.color, CustomColors.placeholderText);
      await tester.ensureVisible(find.byKey(const Key("usernameText")));
      await tester.pumpAndSettle();
      final usernameText = tester.widget<Text>(find.byKey(const Key("usernameText")));
      expect(usernameText.style?.color, CustomColors.primary);
      await tester.ensureVisible(find.byKey(const Key("taskText")));
      await tester.pumpAndSettle();
      final taskText = tester.widget<Text>(find.byKey(const Key("taskText")));
      expect(taskText.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("labelTaskSummary")));
      await tester.pumpAndSettle();
      final labelTaskSummary = tester.widget<Text>(find.byKey(const Key("labelTaskSummary")));
      expect(labelTaskSummary.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("progressText")));
      await tester.pumpAndSettle();
      final progressText = tester.widget<Text>(find.byKey(const Key("progressText")));
      expect(progressText.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("labelProgress")));
      await tester.pumpAndSettle();
      final labelProgress = tester.widget<Text>(find.byKey(const Key("labelProgress")));
      expect(labelProgress.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("labelUpcomming")));
      await tester.pumpAndSettle();
      final labelUpcomming = tester.widget<Text>(find.byKey(const Key("labelUpcomming")));
      expect(labelUpcomming.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("labelCompleted")));
      await tester.pumpAndSettle();
      final labelCompleted = tester.widget<Text>(find.byKey(const Key("labelCompleted")));
      expect(labelCompleted.style?.color, Colors.white);
      

    });

  });

  testWidgets("Should set default theme properly", (WidgetTester tester) async {
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));
    when(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true))).thenAnswer((_) async => const Right(null));
    when(mockLoginUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Right(null);
    });
    when(mockGetActiveBottomNavigationUsecase(NoParam())).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockSetActiveBottomNavigationUsecase(const BottomNavigationParams(currentPage: BottomNavigation.setting))).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.setting)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async => Right(entity));
    when(mockGetThemeUsecase(any)).thenAnswer((_) async => const Right(SettingsEntity(themeMode: Brightness.dark)));
    when(mockSetThemeUsecase(any)).thenAnswer((_) async => const Right(null));

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

      await tester.tap(find.byKey(const Key("navSetting")));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsWidgets);

      Iterable<Scaffold> scaffolds = tester.widgetList<Scaffold>(find.byType(Scaffold));
      expect(scaffolds.last.backgroundColor, CustomColors.secondary);

      await tester.ensureVisible(find.byKey(const Key("textUsername")));
      await tester.pumpAndSettle();
      Text textUsername = tester.widget<Text>(find.byKey(const Key("textUsername")));
      expect(textUsername.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("textEmail")));
      await tester.pumpAndSettle();
      Text textEmail = tester.widget<Text>(find.byKey(const Key("textEmail")));
      expect(textEmail.style?.color, Colors.white.withOpacity(0.5));
      await tester.ensureVisible(find.byKey(const Key("labelPersonalInformation")));
      await tester.pumpAndSettle();
      Text labelPersonalInformation = tester.widget<Text>(find.byKey(const Key("labelPersonalInformation")));
      expect(labelPersonalInformation.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("labelFullName")));
      await tester.pumpAndSettle();
      Text labelFullName = tester.widget<Text>(find.byKey(const Key("labelFullName")));
      expect(labelFullName.style?.color, Colors.white.withOpacity(0.5));
      await tester.ensureVisible(find.byKey(const Key("textFullName")));
      await tester.pumpAndSettle();
      Text textFullName = tester.widget<Text>(find.byKey(const Key("textFullName")));
      expect(textFullName.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("labelEmailAddress")));
      await tester.pumpAndSettle();
      Text labelEmailAddress = tester.widget<Text>(find.byKey(const Key("labelEmailAddress")));
      expect(labelEmailAddress.style?.color, Colors.white.withOpacity(0.5));
      await tester.ensureVisible(find.byKey(const Key("textEmailAddress")));
      await tester.pumpAndSettle();
      Text textEmailAddress = tester.widget<Text>(find.byKey(const Key("textEmailAddress")));
      expect(textEmailAddress.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("labelDOB")));
      await tester.pumpAndSettle();
      Text labelDOB = tester.widget<Text>(find.byKey(const Key("labelDOB")));
      expect(labelDOB.style?.color, Colors.white.withOpacity(0.5));
      await tester.ensureVisible(find.byKey(const Key("textDOB")));
      await tester.pumpAndSettle();
      Text textDOB = tester.widget<Text>(find.byKey(const Key("textDOB")));
      expect(textDOB.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("labelAddress")));
      await tester.pumpAndSettle();
      Text labelAddress = tester.widget<Text>(find.byKey(const Key("labelAddress")));
      expect(labelAddress.style?.color, Colors.white.withOpacity(0.5));
      await tester.ensureVisible(find.byKey(const Key("textAddress")));
      await tester.pumpAndSettle();
      Text textAddress = tester.widget<Text>(find.byKey(const Key("textAddress")));
      expect(textAddress.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("labelOthers")));
      await tester.pumpAndSettle();
      Text labelOthers = tester.widget<Text>(find.byKey(const Key("labelOthers")));
      expect(labelOthers.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("textChangePassword")));
      await tester.pumpAndSettle();
      Text textChangePassword = tester.widget<Text>(find.byKey(const Key("textChangePassword")));
      expect(textChangePassword.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("textDarkMode")));
      await tester.pumpAndSettle();
      Text textDarkMode = tester.widget<Text>(find.byKey(const Key("textDarkMode")));
      expect(textDarkMode.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("textAbout")));
      await tester.pumpAndSettle();
      Text textAbout = tester.widget<Text>(find.byKey(const Key("textAbout")));
      expect(textAbout.style?.color, Colors.white);
      await tester.ensureVisible(find.byKey(const Key("textLogout")));
      await tester.pumpAndSettle();
      Text textLogout = tester.widget<Text>(find.byKey(const Key("textLogout")));
      expect(textLogout.style?.color, Colors.white);

      await tester.tap(find.byKey(const Key("switchDarkMode")));
      await tester.pumpAndSettle();

      scaffolds = tester.widgetList<Scaffold>(find.byType(Scaffold));
      expect(scaffolds.last.backgroundColor, Colors.white);

      await tester.ensureVisible(find.byKey(const Key("textUsername")));
      await tester.pumpAndSettle();
      textUsername = tester.widget<Text>(find.byKey(const Key("textUsername")));
      expect(textUsername.style?.color, CustomColors.secondary);
      await tester.ensureVisible(find.byKey(const Key("textEmail")));
      await tester.pumpAndSettle();
      textEmail = tester.widget<Text>(find.byKey(const Key("textEmail")));
      expect(textEmail.style?.color, CustomColors.secondary.withOpacity(0.5));
      await tester.ensureVisible(find.byKey(const Key("labelPersonalInformation")));
      await tester.pumpAndSettle();
      labelPersonalInformation = tester.widget<Text>(find.byKey(const Key("labelPersonalInformation")));
      expect(labelPersonalInformation.style?.color, CustomColors.secondary);
      await tester.ensureVisible(find.byKey(const Key("labelFullName")));
      await tester.pumpAndSettle();
      labelFullName = tester.widget<Text>(find.byKey(const Key("labelFullName")));
      expect(labelFullName.style?.color, CustomColors.secondary.withOpacity(0.5));
      await tester.ensureVisible(find.byKey(const Key("textFullName")));
      await tester.pumpAndSettle();
      textFullName = tester.widget<Text>(find.byKey(const Key("textFullName")));
      expect(textFullName.style?.color, CustomColors.secondary);
      await tester.ensureVisible(find.byKey(const Key("labelEmailAddress")));
      await tester.pumpAndSettle();
      labelEmailAddress = tester.widget<Text>(find.byKey(const Key("labelEmailAddress")));
      expect(labelEmailAddress.style?.color, CustomColors.secondary.withOpacity(0.5));
      await tester.ensureVisible(find.byKey(const Key("textEmailAddress")));
      await tester.pumpAndSettle();
      textEmailAddress = tester.widget<Text>(find.byKey(const Key("textEmailAddress")));
      expect(textEmailAddress.style?.color, CustomColors.secondary);
      await tester.ensureVisible(find.byKey(const Key("labelDOB")));
      await tester.pumpAndSettle();
      labelDOB = tester.widget<Text>(find.byKey(const Key("labelDOB")));
      expect(labelDOB.style?.color, CustomColors.secondary.withOpacity(0.5));
      await tester.ensureVisible(find.byKey(const Key("textDOB")));
      await tester.pumpAndSettle();
      textDOB = tester.widget<Text>(find.byKey(const Key("textDOB")));
      expect(textDOB.style?.color, CustomColors.secondary);
      await tester.ensureVisible(find.byKey(const Key("labelAddress")));
      await tester.pumpAndSettle();
      labelAddress = tester.widget<Text>(find.byKey(const Key("labelAddress")));
      expect(labelAddress.style?.color, CustomColors.secondary.withOpacity(0.5));
      await tester.ensureVisible(find.byKey(const Key("textAddress")));
      await tester.pumpAndSettle();
      textAddress = tester.widget<Text>(find.byKey(const Key("textAddress")));
      expect(textAddress.style?.color, CustomColors.secondary);
      await tester.ensureVisible(find.byKey(const Key("labelOthers")));
      await tester.pumpAndSettle();
      labelOthers = tester.widget<Text>(find.byKey(const Key("labelOthers")));
      expect(labelOthers.style?.color, CustomColors.secondary);
      await tester.ensureVisible(find.byKey(const Key("textChangePassword")));
      await tester.pumpAndSettle();
      textChangePassword = tester.widget<Text>(find.byKey(const Key("textChangePassword")));
      expect(textChangePassword.style?.color, CustomColors.secondary);
      await tester.ensureVisible(find.byKey(const Key("textDarkMode")));
      await tester.pumpAndSettle();
      textDarkMode = tester.widget<Text>(find.byKey(const Key("textDarkMode")));
      expect(textDarkMode.style?.color, CustomColors.secondary);
      await tester.ensureVisible(find.byKey(const Key("textAbout")));
      await tester.pumpAndSettle();
      textAbout = tester.widget<Text>(find.byKey(const Key("textAbout")));
      expect(textAbout.style?.color, CustomColors.secondary);
      await tester.ensureVisible(find.byKey(const Key("textLogout")));
      await tester.pumpAndSettle();
      textLogout = tester.widget<Text>(find.byKey(const Key("textLogout")));
      expect(textLogout.style?.color, CustomColors.secondary);

    });
  });

}