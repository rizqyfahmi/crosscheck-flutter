
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
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_bloc.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_state.dart';
import 'package:crosscheck/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:crosscheck/features/profile/presentation/bloc/profile_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'login_view_test.mocks.dart';

@GenerateMocks([
  AuthenticationBloc,
  LoginBloc,
  MainBloc,
  DashboardBloc,
  ProfileBloc,
  LoginUsecase,
])
void main() {
  late MockAuthenticationBloc mockAuthenticationBloc;
  late MockLoginBloc mockLoginBloc;
  late MockMainBloc mockMainBloc;
  late MockDashboardBloc mockDashboardBloc;
  late MockLoginUsecase mockLoginUsecase;
  late MockProfileBloc mockProfileBloc;
  late AuthenticationBloc authenticationBloc;
  late LoginBloc loginBloc;
  late Widget testWidget;

  group("Display login page, loading dialog, and error dialog that are triggered by iterable stream", () {
    setUp(() {
      mockAuthenticationBloc = MockAuthenticationBloc();
      mockLoginBloc = MockLoginBloc();
      mockMainBloc = MockMainBloc();
      mockDashboardBloc = MockDashboardBloc();
      mockLoginUsecase = MockLoginUsecase();
      mockProfileBloc = MockProfileBloc();
      testWidget = buildWidget(
        authenticationBloc: mockAuthenticationBloc,
        loginBloc: mockLoginBloc,
        mainBloc: mockMainBloc,
        dashboardBloc: mockDashboardBloc,
        profileBloc: mockProfileBloc
      );
    });

    testWidgets("Should display login page properly", (WidgetTester tester) async {
      when(mockLoginBloc.state).thenReturn(const LoginInitial());
      when(mockLoginBloc.stream).thenAnswer((_) => Stream.fromIterable([
        const LoginInitial()
      ]));

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      
      expect(find.byKey(const Key("logo")), findsOneWidget);
      expect(find.byKey(const Key("usernameField")), findsOneWidget);
      expect(find.byKey(const Key("passwordField")), findsOneWidget);
      expect(find.byKey(const Key("submitButton")), findsOneWidget);
      expect(find.byKey(const Key("forgotPasswordTextButton")), findsOneWidget);
      expect(find.byKey(const Key("signUpTextButton")), findsOneWidget);
    });

    testWidgets("Should display loading dialog when state is LoginLoading", (WidgetTester tester) async {
      when(mockLoginBloc.state).thenReturn(const LoginInitial());
      when(mockLoginBloc.stream).thenAnswer((_) => Stream.fromIterable([
        const LoginLoading(model: LoginModel(username: "fulan@email.com", password: "Password123"))
      ]));
      
      await tester.pumpWidget(testWidget);
      await tester.pump();

      expect(find.text("Loading..."), findsOneWidget);
    });

    testWidgets("Should display error dialog when state is LoginGeneralError", (WidgetTester tester) async {
      when(mockLoginBloc.state).thenReturn(const LoginInitial());
      when(mockLoginBloc.stream).thenAnswer((_) => Stream.fromIterable([
        const LoginGeneralError(message: Failure.generalError, model: LoginModel(username: "fulan@email.com", password: "Password123"))
      ]));

      await tester.pumpWidget(testWidget);
      await tester.pump();

      expect(find.text(Failure.generalError), findsOneWidget);
    });
  });

  group("LoginSuccess that is triggered by iterable stream", () {
    setUp(() {
      authenticationBloc = AuthenticationBloc();
      mockLoginBloc = MockLoginBloc();
      mockMainBloc = MockMainBloc();
      mockDashboardBloc = MockDashboardBloc();
      mockLoginUsecase = MockLoginUsecase();
      mockProfileBloc = MockProfileBloc();
      testWidget = buildWidget(
        authenticationBloc: authenticationBloc, 
        loginBloc: mockLoginBloc,
        mainBloc: mockMainBloc,
        dashboardBloc: mockDashboardBloc,
        profileBloc: mockProfileBloc
      );
    });

    testWidgets("Should set token into authenticaton block when state is LoginSuccess", (WidgetTester tester) async {
      when(mockLoginBloc.state).thenReturn(const LoginInitial());
      when(mockLoginBloc.stream).thenAnswer((_) => Stream.fromIterable([
        const LoginSuccess()
      ]));
      when(mockMainBloc.state).thenReturn(const MainInit());
      when(mockMainBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
      when(mockDashboardBloc.state).thenReturn(DashboardInit());
      when(mockDashboardBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
      when(mockProfileBloc.state).thenReturn(const ProfileInit());
      when(mockProfileBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
      
      expect(authenticationBloc.state, Unauthenticated());
      
      await tester.pumpWidget(testWidget);
      await mockNetworkImagesFor(() => tester.pump());
      
      expect(authenticationBloc.state, Authenticated());
    });
  });

  group("Triggered by interaction", () {
    setUp(() {
      mockLoginUsecase = MockLoginUsecase();
      authenticationBloc = AuthenticationBloc();
      loginBloc = LoginBloc(loginUsecase: mockLoginUsecase);
      mockDashboardBloc = MockDashboardBloc();
      mockMainBloc = MockMainBloc();
      mockProfileBloc = MockProfileBloc();
      testWidget = buildWidget(
        authenticationBloc: authenticationBloc, 
        loginBloc: loginBloc,
        mainBloc: mockMainBloc,
        dashboardBloc: mockDashboardBloc,
        profileBloc: mockProfileBloc
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
      when(mockLoginUsecase(any)).thenAnswer((_) async => const Right(null));

      await tester.pumpWidget(testWidget);
      await tester.pump();

      await tester.enterText(find.byKey(const Key("usernameField")), "fulan@email.com");
      await tester.enterText(find.byKey(const Key("passwordField")), "Password123");
      await tester.tap(find.byKey(const Key("submitButton")));
      await tester.pump();
      
      expect(loginBloc.state, const LoginLoading(model: LoginModel(username: "fulan@email.com", password: "Password123")));
    });

    testWidgets("Should set token into authentication BLoC when submit login form is success", (WidgetTester tester) async {
      when(mockLoginUsecase(any)).thenAnswer((_) async => const Right(null));
      when(mockMainBloc.state).thenReturn(const MainInit());
      when(mockMainBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
      when(mockDashboardBloc.state).thenReturn(DashboardInit());
      when(mockDashboardBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
      when(mockProfileBloc.state).thenReturn(const ProfileInit());
      when(mockProfileBloc.stream).thenAnswer((_) => Stream.fromIterable([]));

      await tester.pumpWidget(testWidget);
      await tester.pump();

      expect(authenticationBloc.state, Unauthenticated());

      await tester.enterText(find.byKey(const Key("usernameField")), "fulan@email.com");
      await tester.enterText(find.byKey(const Key("passwordField")), "Password123");
      await tester.pump();
      await tester.tap(find.byKey(const Key("submitButton")));
      await tester.pump();
      
      expect(loginBloc.state, const LoginLoading(model: LoginModel(username: "fulan@email.com", password: "Password123")));
      
      await tester.runAsync(() async {
        await Future.delayed(const Duration(seconds: 1));
        await mockNetworkImagesFor(() => tester.pump());
        
        expect(loginBloc.state, const LoginSuccess());
        expect(authenticationBloc.state, Authenticated());
      });
      
    });

    testWidgets("Should return LoginGeneralError when submit login form is failed because of NetworkFailure()", (WidgetTester tester) async {
      when(mockLoginUsecase(any)).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 2));
        return const Left(ServerFailure(message: Failure.networkError));
      });

      await tester.pumpWidget(testWidget);
      await tester.pump();

      expect(authenticationBloc.state, Unauthenticated());

      await tester.enterText(find.byKey(const Key("usernameField")), "fulan@email.com");
      await tester.enterText(find.byKey(const Key("passwordField")), "Password123");
      await tester.pump();
      await tester.runAsync(() async {
        await tester.tap(find.byKey(const Key("submitButton")));
        await tester.pump();
        
        expect(loginBloc.state, const LoginLoading(model: LoginModel(username: "fulan@email.com", password: "Password123")));
        expect(find.text("Loading..."), findsOneWidget);

        await Future.delayed(const Duration(seconds: 4));
        await tester.pump();
        
        expect(find.text("Loading..."), findsNothing);
        expect(loginBloc.state, const LoginGeneralError(message: Failure.networkError, model: LoginModel(username: "fulan@email.com", password: "Password123")));
        expect(find.text(Failure.networkError), findsOneWidget);

        await tester.ensureVisible(find.byKey(const Key("dismissButton")));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key("dismissButton")));
        await tester.pump();

        expect(loginBloc.state, const LoginNoGeneralError(model: LoginModel(username: "fulan@email.com", password: "Password123")));
        expect(find.text(Failure.networkError), findsNothing);
      });

    });

    testWidgets("Should return LoginGeneralError when submit login form is failed because of username or password still empty", (WidgetTester tester) async {
      when(mockLoginUsecase(any)).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 2));
        return const Left(ServerFailure(message: Failure.loginRequiredFieldError));
      });

      await tester.pumpWidget(testWidget);
      await tester.pump();

      expect(authenticationBloc.state, Unauthenticated());

      await tester.runAsync(() async {
        await tester.tap(find.byKey(const Key("submitButton")));
        await tester.pump();
        
        expect(loginBloc.state, const LoginLoading(model: LoginModel(username: "", password: "")));
        expect(find.text("Loading..."), findsOneWidget);
        
        await Future.delayed(const Duration(seconds: 4));
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
        return const Left(ServerFailure(message: Failure.generalError));
      });

      await tester.pumpWidget(testWidget);
      await tester.pump();

      expect(authenticationBloc.state, Unauthenticated());
      await tester.enterText(find.byKey(const Key("usernameField")), "fulan@email.com");
      await tester.enterText(find.byKey(const Key("passwordField")), "Password123");
      await tester.pump();
      await tester.runAsync(() async {
        await tester.tap(find.byKey(const Key("submitButton")));
        await tester.pump();
      
        expect(loginBloc.state, const LoginLoading(model: LoginModel(username: "fulan@email.com", password: "Password123")));
        expect(find.text("Loading..."), findsOneWidget);
        
        await Future.delayed(const Duration(seconds: 4));
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
  });
}

Widget buildWidget({
  required AuthenticationBloc authenticationBloc,
  required LoginBloc loginBloc,
  required MainBloc mainBloc,
  required DashboardBloc dashboardBloc,
  required ProfileBloc profileBloc
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
      ),
      BlocProvider<ProfileBloc>(
        create: (_) => profileBloc
      )
    ], 
    child:  MaterialApp(
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