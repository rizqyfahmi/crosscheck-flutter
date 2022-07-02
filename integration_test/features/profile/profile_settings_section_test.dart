import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/features/authentication/domain/usecases/login_usecase.dart';
import 'package:crosscheck/features/authentication/domain/usecases/registration_usecase.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/login/bloc/login_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/registration/bloc/registration_bloc.dart';
import 'package:crosscheck/features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:crosscheck/features/main/data/model/params/bottom_navigation_params.dart';
import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';
import 'package:crosscheck/features/main/domain/usecase/get_active_bottom_navigation_usecase.dart';
import 'package:crosscheck/features/main/domain/usecase/set_active_bottom_navigation_usecase.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_bloc.dart';
import 'package:crosscheck/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:crosscheck/features/profile/presentation/bloc/profile_bloc.dart';
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

import '../../../test/utils/utils.dart';
import 'profile_settings_section_test.mocks.dart';

@GenerateMocks([
  RegistrationUsecase,
  LoginUsecase,
  SetIsSkipUsecase,
  GetIsSkipUsecase,
  SetActiveBottomNavigationUsecase,
  GetActiveBottomNavigationUsecase,
  GetDashboardUsecase,
  SetThemeUsecase,
  GetThemeUsecase,
  GetProfileUsecase
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
  late MockGetProfileUsecase mockGetProfileUsecase;
  late AuthenticationBloc authenticationBloc;
  late WalkthroughBloc walkthroughBloc;
  late RegistrationBloc registrationBloc;
  late LoginBloc loginBloc;
  late MainBloc mainBloc;
  late DashboardBloc dashboardBloc;
  late SettingsBloc settingsBloc;
  late ProfileBloc profileBloc;
  late Widget main;

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
    mockGetProfileUsecase = MockGetProfileUsecase();

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
    profileBloc = ProfileBloc(getProfileUsecase: mockGetProfileUsecase);

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
      ),
      BlocProvider<ProfileBloc>(
        create: (_) => profileBloc
      ),
    ]);
  });

  testWidgets("Should properly display profile section in setting", (WidgetTester tester) async {
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));
    when(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true))).thenAnswer((_) async => const Right(null));
    when(mockLoginUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Right(null);
    });
    when(mockGetActiveBottomNavigationUsecase(NoParam())).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockSetActiveBottomNavigationUsecase(const BottomNavigationParams(currentPage: BottomNavigation.setting))).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.setting)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      final mockedEntity = Utils().dashboardEntity.copyWith(
        fullname: "fulan",
        photoUrl: "https://via.placeholder.com/60x60"
      );
      return Right(mockedEntity);
    });
    when(mockGetThemeUsecase(any)).thenAnswer((_) async => const Right(SettingsEntity(themeMode: Brightness.dark)));
    when(mockGetProfileUsecase(NoParam())).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 3));
      return Right(Utils.profileEntity);
    });
   
    await tester.runAsync(() async {
      await tester.pumpWidget(main);
      await tester.pumpAndSettle();

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
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      await tester.pump();
      await tester.tap(find.byKey(const Key("navSetting")));
      await tester.pump(); // ProfileLoading
      await tester.pump(); // SettingsLoading 
      await tester.pump(); // Show dialog
      await tester.pump(); // blur dialog
      expect(find.text("Loading..."), findsOneWidget);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));
      await tester.pump();
      expect(find.text("Loading..."), findsNothing);

      await tester.ensureVisible(find.byKey(const Key("imageProfile")));
      await tester.pumpAndSettle();
      Image imageProfile = tester.widget(find.byKey(const Key("imageProfile")));
      expect((imageProfile.image as NetworkImage).url, "https://via.placeholder.com/60x60");

      await tester.ensureVisible(find.byKey(const Key("textProfileFullName")));
      await tester.pumpAndSettle();
      Text textProfileFullName = tester.widget(find.byKey(const Key("textProfileFullName")));
      expect(textProfileFullName.data, "fulan");
      
      await tester.ensureVisible(find.byKey(const Key("textProfileEmail")));
      await tester.pumpAndSettle();
      Text textProfileEmail = tester.widget(find.byKey(const Key("textProfileEmail")));
      expect(textProfileEmail.data, "fulan@email.com");

      await tester.ensureVisible(find.byKey(const Key("textFullName")));
      await tester.pumpAndSettle();
      Text textFullName = tester.widget(find.byKey(const Key("textFullName")));
      expect(textFullName.data, "fulan");

      await tester.ensureVisible(find.byKey(const Key("textEmailAddress")));
      await tester.pumpAndSettle();
      Text textEmailAddress = tester.widget(find.byKey(const Key("textEmailAddress")));
      expect(textEmailAddress.data, "fulan@email.com");

      await tester.ensureVisible(find.byKey(const Key("textDOB")));
      await tester.pumpAndSettle();
      Text textDOB = tester.widget(find.byKey(const Key("textDOB")));
      expect(textDOB.data, "11-01-1991");

      await tester.ensureVisible(find.byKey(const Key("textAddress")));
      await tester.pumpAndSettle();
      Text textAddress = tester.widget(find.byKey(const Key("textAddress")));
      expect(textAddress.data, "Indonesia");

    });

  });

  testWidgets("Should properly display general error wehn get profile section in setting returns serverFailure", (WidgetTester tester) async {
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));
    when(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true))).thenAnswer((_) async => const Right(null));
    when(mockLoginUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Right(null);
    });
    when(mockGetActiveBottomNavigationUsecase(NoParam())).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockSetActiveBottomNavigationUsecase(const BottomNavigationParams(currentPage: BottomNavigation.setting))).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.setting)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      final mockedEntity = Utils().dashboardEntity.copyWith(
        fullname: "fulan",
        photoUrl: "https://via.placeholder.com/60x60"
      );
      return Right(mockedEntity);
    });
    when(mockGetThemeUsecase(any)).thenAnswer((_) async => const Right(SettingsEntity(themeMode: Brightness.dark)));
    when(mockGetProfileUsecase(NoParam())).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 3));
      return const Left(ServerFailure(message: Failure.generalError));
    });
   
    await tester.runAsync(() async {
      await tester.pumpWidget(main);
      await tester.pumpAndSettle();

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
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      await tester.pump();
      await tester.tap(find.byKey(const Key("navSetting")));
      await tester.pump(); // ProfileLoading
      await tester.pump(); // SettingsLoading 
      await tester.pump(); // Show dialog
      await tester.pump(); // blur dialog
      expect(find.text("Loading..."), findsOneWidget);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));
      await tester.pump();
      expect(find.text("Loading..."), findsNothing);
      expect(find.byKey(const Key("responseDialog")), findsOneWidget);
      await tester.pump();
      await tester.tap(find.byKey(const Key("dismissButton")));
      await tester.pump();

      await tester.ensureVisible(find.byKey(const Key("imageProfile")));
      await tester.pumpAndSettle();
      Image imageProfile = tester.widget(find.byKey(const Key("imageProfile")));
      expect((imageProfile.image as NetworkImage).url, "https://via.placeholder.com/60x60/F24B59/F24B59?text=.");

      await tester.ensureVisible(find.byKey(const Key("textProfileFullName")));
      await tester.pumpAndSettle();
      Text textProfileFullName = tester.widget(find.byKey(const Key("textProfileFullName")));
      expect(textProfileFullName.data, "-");
      
      await tester.ensureVisible(find.byKey(const Key("textProfileEmail")));
      await tester.pumpAndSettle();
      Text textProfileEmail = tester.widget(find.byKey(const Key("textProfileEmail")));
      expect(textProfileEmail.data, "-");

      await tester.ensureVisible(find.byKey(const Key("textFullName")));
      await tester.pumpAndSettle();
      Text textFullName = tester.widget(find.byKey(const Key("textFullName")));
      expect(textFullName.data, "-");

      await tester.ensureVisible(find.byKey(const Key("textEmailAddress")));
      await tester.pumpAndSettle();
      Text textEmailAddress = tester.widget(find.byKey(const Key("textEmailAddress")));
      expect(textEmailAddress.data, "-");

      await tester.ensureVisible(find.byKey(const Key("textDOB")));
      await tester.pumpAndSettle();
      Text textDOB = tester.widget(find.byKey(const Key("textDOB")));
      expect(textDOB.data, "-");

      await tester.ensureVisible(find.byKey(const Key("textAddress")));
      await tester.pumpAndSettle();
      Text textAddress = tester.widget(find.byKey(const Key("textAddress")));
      expect(textAddress.data, "-");

    });

  });

  testWidgets("Should properly display general error wehn get profile section in setting returns cacheFailure", (WidgetTester tester) async {
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));
    when(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true))).thenAnswer((_) async => const Right(null));
    when(mockLoginUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Right(null);
    });
    when(mockGetActiveBottomNavigationUsecase(NoParam())).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockSetActiveBottomNavigationUsecase(const BottomNavigationParams(currentPage: BottomNavigation.setting))).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.setting)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      final mockedEntity = Utils().dashboardEntity.copyWith(
        fullname: "fulan",
        photoUrl: "https://via.placeholder.com/60x60"
      );
      return Right(mockedEntity);
    });
    when(mockGetThemeUsecase(any)).thenAnswer((_) async => const Right(SettingsEntity(themeMode: Brightness.dark)));
    when(mockGetProfileUsecase(NoParam())).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 3));
      return const Left(CacheFailure(message: Failure.cacheError));
    });
   
    await tester.runAsync(() async {
      await tester.pumpWidget(main);
      await tester.pumpAndSettle();

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
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      await tester.pump();
      await tester.tap(find.byKey(const Key("navSetting")));
      await tester.pump(); // ProfileLoading
      await tester.pump(); // SettingsLoading 
      await tester.pump(); // Show dialog
      await tester.pump(); // blur dialog
      expect(find.text("Loading..."), findsOneWidget);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));
      await tester.pump();
      expect(find.text("Loading..."), findsNothing);
      expect(find.byKey(const Key("responseDialog")), findsOneWidget);
      await tester.pump();
      await tester.tap(find.byKey(const Key("dismissButton")));
      await tester.pump();

      await tester.ensureVisible(find.byKey(const Key("imageProfile")));
      await tester.pumpAndSettle();
      Image imageProfile = tester.widget(find.byKey(const Key("imageProfile")));
      expect((imageProfile.image as NetworkImage).url, "https://via.placeholder.com/60x60/F24B59/F24B59?text=.");

      await tester.ensureVisible(find.byKey(const Key("textProfileFullName")));
      await tester.pumpAndSettle();
      Text textProfileFullName = tester.widget(find.byKey(const Key("textProfileFullName")));
      expect(textProfileFullName.data, "-");
      
      await tester.ensureVisible(find.byKey(const Key("textProfileEmail")));
      await tester.pumpAndSettle();
      Text textProfileEmail = tester.widget(find.byKey(const Key("textProfileEmail")));
      expect(textProfileEmail.data, "-");

      await tester.ensureVisible(find.byKey(const Key("textFullName")));
      await tester.pumpAndSettle();
      Text textFullName = tester.widget(find.byKey(const Key("textFullName")));
      expect(textFullName.data, "-");

      await tester.ensureVisible(find.byKey(const Key("textEmailAddress")));
      await tester.pumpAndSettle();
      Text textEmailAddress = tester.widget(find.byKey(const Key("textEmailAddress")));
      expect(textEmailAddress.data, "-");

      await tester.ensureVisible(find.byKey(const Key("textDOB")));
      await tester.pumpAndSettle();
      Text textDOB = tester.widget(find.byKey(const Key("textDOB")));
      expect(textDOB.data, "-");

      await tester.ensureVisible(find.byKey(const Key("textAddress")));
      await tester.pumpAndSettle();
      Text textAddress = tester.widget(find.byKey(const Key("textAddress")));
      expect(textAddress.data, "-");

    });

  });

}