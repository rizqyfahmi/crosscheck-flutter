import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/assets/fonts/fonts.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/widgets/styles/text_styles.dart';
import 'package:crosscheck/features/authentication/domain/usecases/login_usecase.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_state.dart';
import 'package:crosscheck/features/authentication/presentation/login/view/login_view.dart';
import 'package:crosscheck/features/authentication/presentation/login/bloc/login_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/login/bloc/login_model.dart';
import 'package:crosscheck/features/authentication/presentation/login/bloc/login_state.dart';
import 'package:crosscheck/features/dashboard/domain/entities/activity_entity.dart';
import 'package:crosscheck/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:crosscheck/features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';
import 'package:crosscheck/features/main/domain/usecase/get_active_bottom_navigation_usecase.dart';
import 'package:crosscheck/features/main/domain/usecase/set_active_bottom_navigation_usecase.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_view_test.mocks.dart';

@GenerateMocks([
  LoginUsecase,
  SetActiveBottomNavigationUsecase,
  GetActiveBottomNavigationUsecase,
  GetDashboardUsecase
])
void main() {
  late MockLoginUsecase mockLoginUsecase;
  late AuthenticationBloc authenticationBloc;
  late MockSetActiveBottomNavigationUsecase mockSetActiveBottomNavigationUsecase;
  late MockGetActiveBottomNavigationUsecase mockGetActiveBottomNavigationUsecase;
  late MockGetDashboardUsecase mockGetDashboardUsecase;
  late LoginBloc loginBloc;
  late MainBloc mainBloc;
  late DashboardBloc dashboardBloc;
  late Widget testWidget;

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
    mockSetActiveBottomNavigationUsecase = MockSetActiveBottomNavigationUsecase();
    mockGetActiveBottomNavigationUsecase = MockGetActiveBottomNavigationUsecase();
    mockGetDashboardUsecase = MockGetDashboardUsecase();
    authenticationBloc = AuthenticationBloc();
    loginBloc = LoginBloc(loginUsecase: mockLoginUsecase);
    mainBloc = MainBloc(
      getActiveBottomNavigationUsecase: mockGetActiveBottomNavigationUsecase, 
      setActiveBottomNavigationUsecase: mockSetActiveBottomNavigationUsecase
    );
    dashboardBloc = DashboardBloc(getDashboardUsecase: mockGetDashboardUsecase);

    testWidget = buildWidget(
      authenticationBloc: authenticationBloc, 
      loginBloc: loginBloc,
      mainBloc: mainBloc,
      dashboardBloc: dashboardBloc
    );
  });

  testWidgets("Should have username and password as the same as the value of their fields", (WidgetTester tester) async {
    await tester.pumpWidget(testWidget);
    await tester.pump();

    await tester.enterText(find.byKey(const Key("usernameField")), "fulan@email.com");
    await tester.pump();
    expect(loginBloc.state, const LoginEnterField(model: LoginModel(username: "fulan@email.com", password: "")));

    await tester.enterText(find.byKey(const Key("passwordField")), "Password123");
    await tester.pump();
    expect(loginBloc.state, const LoginEnterField(model: LoginModel(username: "fulan@email.com", password: "Password123")));
  });

  testWidgets("Should display loading dialog on submit login form", (WidgetTester tester) async {
    when(mockLoginUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Right(null);
    });

    when(mockGetActiveBottomNavigationUsecase(any)).thenAnswer((_) async {
      return const Right(BottomNavigationEntity(currentPage: BottomNavigation.home));
    });

    when(mockGetDashboardUsecase(any)).thenAnswer((_) async => Right(entity));

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key("usernameField")), "fulan@email.com");
      await tester.enterText(find.byKey(const Key("passwordField")), "Password123");
      await tester.pump();
      await tester.ensureVisible(find.byKey(const Key("submitButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("submitButton")));
      await tester.pump();
    
      expect(loginBloc.state, const LoginLoading(model: LoginModel(username: "fulan@email.com", password: "Password123")));
      expect(find.text("Loading..."), findsOneWidget);
      
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();

    });
  });

  testWidgets("Should set token into authentication BLoC when submit login form is success", (WidgetTester tester) async {
    when(mockLoginUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Right(null);
    });

    when(mockGetActiveBottomNavigationUsecase(any)).thenAnswer((_) async {
      return const Right(BottomNavigationEntity(currentPage: BottomNavigation.home));
    });

    when(mockGetDashboardUsecase(any)).thenAnswer((_) async => Right(entity));

    await tester.pumpWidget(testWidget);
    await tester.pump();

    expect(authenticationBloc.state, Unauthenticated());
    await tester.enterText(find.byKey(const Key("usernameField")), "fulan@email.com");
    await tester.enterText(find.byKey(const Key("passwordField")), "Password123");
    await tester.pump();
    await tester.runAsync(() async {
      await tester.ensureVisible(find.byKey(const Key("submitButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("submitButton")));
      await tester.pump();
    
      expect(loginBloc.state, const LoginLoading(model: LoginModel(username: "fulan@email.com", password: "Password123")));
      expect(find.text("Loading..."), findsOneWidget);
      
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
    
      
      expect(find.text("Loading..."), findsNothing);
      expect(loginBloc.state, const LoginSuccess());
      expect(authenticationBloc.state, Authenticated());
    });
    
  });

  testWidgets("Should return LoginGeneralError when submit login form is failed because of NetworkFailure()", (WidgetTester tester) async {
    when(mockLoginUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return Left(ServerFailure(message: NetworkFailure.message));
    });
    
    when(mockGetActiveBottomNavigationUsecase(any)).thenAnswer((_) async {
      return const Right(BottomNavigationEntity(currentPage: BottomNavigation.home));
    });

    await tester.pumpWidget(testWidget);
    await tester.pump();

    expect(authenticationBloc.state, Unauthenticated());

    await tester.enterText(find.byKey(const Key("usernameField")), "fulan@email.com");
    await tester.enterText(find.byKey(const Key("passwordField")), "Password123");
    await tester.pump();
    await tester.runAsync(() async {
      await tester.ensureVisible(find.byKey(const Key("submitButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("submitButton")));
      await tester.pump();
      
      expect(loginBloc.state, const LoginLoading(model: LoginModel(username: "fulan@email.com", password: "Password123")));
      expect(find.text("Loading..."), findsOneWidget);

      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      
      expect(find.text("Loading..."), findsNothing);
      expect(loginBloc.state, const LoginGeneralError(message: NetworkFailure.message, model: LoginModel(username: "fulan@email.com", password: "Password123")));
      expect(find.text(NetworkFailure.message), findsOneWidget);

      await tester.ensureVisible(find.byKey(const Key("dismissButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("dismissButton")));
      await tester.pump();

      expect(loginBloc.state, const LoginNoGeneralError(model: LoginModel(username: "fulan@email.com", password: "Password123")));
      expect(find.text(NetworkFailure.message), findsNothing);
    });

  });

  testWidgets("Should return LoginGeneralError when submit login form is failed because of username or password still empty", (WidgetTester tester) async {
    when(mockLoginUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return Left(ServerFailure(message: Failure.loginRequiredFieldError));
    });

    when(mockGetActiveBottomNavigationUsecase(any)).thenAnswer((_) async {
      return const Right(BottomNavigationEntity(currentPage: BottomNavigation.home));
    });

    await tester.pumpWidget(testWidget);
    await tester.pump();

    expect(authenticationBloc.state, Unauthenticated());

    await tester.runAsync(() async {
      await tester.ensureVisible(find.byKey(const Key("submitButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("submitButton")));
      await tester.pump();
      
      expect(loginBloc.state, const LoginLoading(model: LoginModel(username: "", password: "")));
      expect(find.text("Loading..."), findsOneWidget);
      
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      
      expect(find.text("Loading..."), findsNothing);
      expect(loginBloc.state, const LoginGeneralError(message: Failure.loginRequiredFieldError, model: LoginModel(username: "", password: "")));
      expect(find.text(Failure.loginRequiredFieldError), findsOneWidget);

      await tester.ensureVisible(find.byKey(const Key("dismissButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("dismissButton")));
      await tester.pump();

      expect(loginBloc.state, const LoginNoGeneralError(model: LoginModel(username: "", password: "")));
      expect(find.text(Failure.loginRequiredFieldError), findsNothing);
    });

  });

  testWidgets("Should return LoginNoGeneralError when button dismissed is clicked after submit login form is failed", (WidgetTester tester) async {
    when(mockLoginUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return Left(ServerFailure(message: Failure.generalError));
    });

    await tester.pumpWidget(testWidget);
    await tester.pump();

    expect(authenticationBloc.state, Unauthenticated());
    await tester.enterText(find.byKey(const Key("usernameField")), "fulan@email.com");
    await tester.enterText(find.byKey(const Key("passwordField")), "Password123");
    await tester.pump();
    await tester.runAsync(() async {
      await tester.ensureVisible(find.byKey(const Key("submitButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("submitButton")));
      await tester.pump();
    
      expect(loginBloc.state, const LoginLoading(model: LoginModel(username: "fulan@email.com", password: "Password123")));
      expect(find.text("Loading..."), findsOneWidget);
      
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      
      expect(find.text("Loading..."), findsNothing);
      expect(loginBloc.state, const LoginGeneralError(message: Failure.generalError, model: LoginModel(username: "fulan@email.com", password: "Password123")));
      expect(find.text(Failure.generalError), findsOneWidget);

      await tester.ensureVisible(find.byKey(const Key("dismissButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("dismissButton")));
      await tester.pump();

      expect(loginBloc.state, const LoginNoGeneralError(model: LoginModel(username: "fulan@email.com", password: "Password123")));
      expect(find.text(Failure.loginRequiredFieldError), findsNothing);
    });

  });
  
}

Widget buildWidget({
  required AuthenticationBloc authenticationBloc,
  required LoginBloc loginBloc,
  required MainBloc mainBloc,
  required DashboardBloc dashboardBloc
}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<AuthenticationBloc>(
        create: (_) => authenticationBloc
      ),
      BlocProvider<LoginBloc>(
        create: (_) => loginBloc
      ),
      BlocProvider<MainBloc>(
        create: (_) => mainBloc
      ),
      BlocProvider<DashboardBloc>(
        create: (_) => dashboardBloc
      )
    ], 
    child: MaterialApp(
      theme: ThemeData(
        backgroundColor: CustomColors.secondary,
        fontFamily: FontFamily.poppins,
        colorScheme: const ColorScheme(
          brightness: Brightness.light, 
          primary: CustomColors.primary, 
          onPrimary: Colors.white, 
          secondary: CustomColors.secondary, 
          onSecondary: Colors.white, 
          error: CustomColors.primary, 
          onError: Colors.white, 
          background: Colors.white, 
          onBackground: CustomColors.secondary, 
          surface: Colors.white, 
          onSurface: Colors.white
        ),
        textTheme: const TextTheme(
          headline1: TextStyles.poppinsBold24,
          subtitle1: TextStyles.poppinsBold16,
          bodyText1: TextStyles.poppinsRegular14,
          bodyText2: TextStyles.poppinsRegular12,
          button: TextStyles.poppinsRegular16
        )
      ),
      home: const LoginView(),
    )
  );
}