import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:crosscheck/features/authentication/domain/usecases/login_usecase.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_state.dart';
import 'package:crosscheck/features/authentication/presentation/login/view/login_view.dart';
import 'package:crosscheck/features/authentication/presentation/login/view_models/login_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/login/view_models/login_model.dart';
import 'package:crosscheck/features/authentication/presentation/login/view_models/login_state.dart';
import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';
import 'package:crosscheck/features/main/domain/usecase/get_active_bottom_navigation_usecase.dart';
import 'package:crosscheck/features/main/domain/usecase/set_active_bottom_navigation_usecase.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_view_test.mocks.dart';

@GenerateMocks([
  LoginUsecase,
  SetActiveBottomNavigationUsecase,
  GetActiveBottomNavigationUsecase  
])
void main() {
  late MockLoginUsecase mockLoginUsecase;
  late AuthenticationBloc authenticationBloc;
  late MockSetActiveBottomNavigationUsecase mockSetActiveBottomNavigationUsecase;
  late MockGetActiveBottomNavigationUsecase mockGetActiveBottomNavigationUsecase;
  late LoginBloc loginBloc;
  late MainBloc mainBloc;
  late Widget testWidget;

  const String token = "eyJhbGci OiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    mockLoginUsecase = MockLoginUsecase();
    mockSetActiveBottomNavigationUsecase = MockSetActiveBottomNavigationUsecase();
    mockGetActiveBottomNavigationUsecase = MockGetActiveBottomNavigationUsecase();
    authenticationBloc = AuthenticationBloc();
    loginBloc = LoginBloc(loginUsecase: mockLoginUsecase);
    mainBloc = MainBloc(
      getActiveBottomNavigationUsecase: mockGetActiveBottomNavigationUsecase, 
      setActiveBottomNavigationUsecase: mockSetActiveBottomNavigationUsecase
    );

    testWidget = buildWidget(
      authenticationBloc: authenticationBloc, 
      loginBloc: loginBloc,
      mainBloc: mainBloc
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
      return const Right(AuthenticationEntity(token: token));
    });

    when(mockGetActiveBottomNavigationUsecase(any)).thenAnswer((_) async {
      return const Right(BottomNavigationEntity(currentPage: BottomNavigation.home));
    });

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
      return const Right(AuthenticationEntity(token: token));
    });

    when(mockGetActiveBottomNavigationUsecase(any)).thenAnswer((_) async {
      return const Right(BottomNavigationEntity(currentPage: BottomNavigation.home));
    });

    await tester.pumpWidget(testWidget);
    await tester.pump();

    expect(authenticationBloc.state, const Unauthenticated());
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
      expect(loginBloc.state, const LoginSuccess(token: token));
      expect(authenticationBloc.state, const Authenticated(token: token));
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

    expect(authenticationBloc.state, const Unauthenticated());

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

    expect(authenticationBloc.state, const Unauthenticated());

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

    expect(authenticationBloc.state, const Unauthenticated());
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
  required MainBloc mainBloc
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
      )
    ], 
    child: const MaterialApp(
      home: LoginView(),
    )
  );
}