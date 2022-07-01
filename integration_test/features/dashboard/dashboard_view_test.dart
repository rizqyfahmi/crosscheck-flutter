
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
import 'package:crosscheck/features/profile/domain/entities/profile_entity.dart';
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
import 'dashboard_view_test.mocks.dart';

@GenerateMocks([
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
  late LoginBloc loginBloc;
  late MainBloc mainBloc;
  late DashboardBloc dashboardBloc;
  late SettingsBloc settingsBloc;
  late ProfileBloc profileBloc;
  late Widget main;

  final currentDate = DateTime.now();

  setUp(() {
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

  testWidgets("Should properly load data on dashboard page", (WidgetTester tester) async {
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));
    when(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true))).thenAnswer((_) async => const Right(null));
    when(mockLoginUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Right(null);
    });
    when(mockGetActiveBottomNavigationUsecase(NoParam())).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockSetActiveBottomNavigationUsecase(const BottomNavigationParams(currentPage: BottomNavigation.event))).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.event)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      final mockedEntity = Utils().dashboardEntity.copyWith(
        fullname: "fulan",
        photoUrl: "https://via.placeholder.com/60x60"
      );

      return Right(mockedEntity);
    });
    when(mockGetThemeUsecase(any)).thenAnswer((_) async => const Right(SettingsEntity(themeMode: Brightness.dark)));
    when(mockGetProfileUsecase(NoParam())).thenAnswer((_) async => Right(ProfileEntity(id: "123", fullname: "fulan", email: "fulan@email.com", dob: DateTime.parse("1991-01-11"), address: "Indonesia", photoUrl: "https://via.placeholder.com/60x60")));

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
       
        if (i == (currentDate.weekday - 1)) {
          expect(decoration.color, CustomColors.primary);
          continue;
        }

        expect(decoration.color, CustomColors.placeholderText.withOpacity(0.16));
      }

    });
    
  });

  testWidgets("Should display error modal on dashboard page", (WidgetTester tester) async {
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));
    when(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true))).thenAnswer((_) async => const Right(null));
    when(mockLoginUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Right(null);
    });
    when(mockGetActiveBottomNavigationUsecase(NoParam())).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockSetActiveBottomNavigationUsecase(const BottomNavigationParams(currentPage: BottomNavigation.event))).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.event)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Left(ServerFailure(message: Failure.generalError));
    });
    when(mockGetThemeUsecase(any)).thenAnswer((_) async => const Right(SettingsEntity(themeMode: Brightness.dark)));
    when(mockGetProfileUsecase(NoParam())).thenAnswer((_) async => Right(ProfileEntity(id: "123", fullname: "fulan", email: "fulan@email.com", dob: DateTime.parse("1991-01-11"), address: "Indonesia", photoUrl: "https://via.placeholder.com/60x60")));

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
      await Future.delayed(const Duration(seconds: 1));
      expect(find.text("Loading..."), findsOneWidget);
      await tester.pumpAndSettle();

      expect(find.text("Loading..."), findsNothing);
      await tester.ensureVisible(find.byKey(const Key("dismissButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("dismissButton")));
      await tester.pump();

    });
    
  });
}