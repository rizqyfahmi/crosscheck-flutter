import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/features/authentication/presentation/login/view/login_view.dart';
import 'package:crosscheck/features/authentication/presentation/login/bloc/login_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/login/bloc/login_state.dart';
import 'package:crosscheck/features/walkthrough/data/models/request/walkthrough_params.dart';
import 'package:crosscheck/features/walkthrough/domain/entities/walkthrough_entitiy.dart';
import 'package:crosscheck/features/walkthrough/domain/usecases/get_is_skip_usecase.dart';
import 'package:crosscheck/features/walkthrough/domain/usecases/set_is_skip_usecase.dart';
import 'package:crosscheck/features/walkthrough/presentation/view/walkthrough_view.dart';
import 'package:crosscheck/features/walkthrough/presentation/bloc/walkthrough_bloc.dart';
import 'package:crosscheck/features/walkthrough/presentation/bloc/walkthrough_event.dart';
import 'package:crosscheck/main.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'walkthrough_view_test.mocks.dart';

@GenerateMocks([
  LoginBloc,
  SetIsSkipUsecase,
  GetIsSkipUsecase
])
void main() {
  late WalkthroughBloc walkthroughBloc;
  late MockLoginBloc mockLoginBloc;
  late MockSetIsSkipUsecase mockSetIsSkipUsecase;
  late MockGetIsSkipUsecase mockGetIsSkipUsecase;
  late Widget testWidget;

  setUp(() {
    mockSetIsSkipUsecase = MockSetIsSkipUsecase();
    mockGetIsSkipUsecase = MockGetIsSkipUsecase();
    walkthroughBloc = WalkthroughBloc(
      setIsSkipUsecase: mockSetIsSkipUsecase,
      getIsSkipUsecase: mockGetIsSkipUsecase
    );
    mockLoginBloc = MockLoginBloc();
    testWidget = buildWidget(
      loginBloc: mockLoginBloc,
      walkthroughBloc: walkthroughBloc
    );

    when(mockLoginBloc.state).thenReturn(const LoginInitial());
    when(mockLoginBloc.stream).thenAnswer((_) => Stream.fromIterable([const LoginInitial()]));
  });

  testWidgets("Should display walkthrough view properly when GetIsSkipUsecase returns a failure", (WidgetTester tester) async {
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => Left(CachedFailure(message: Failure.cacheError)));

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 1));
      
      expect(find.byKey(const Key("illustration")), findsOneWidget);
      expect(find.text("Welcome"), findsOneWidget);
      expect(find.text("Focus on your short and long-term habit to improve productivity and achieve your goals. Enjoy your way to better time management"), findsOneWidget);
      expect(find.byKey(const Key("getStartedButton")), findsOneWidget);

      verify(mockGetIsSkipUsecase(NoParam()));
    });

  });

  testWidgets("Should display login view properly when GetIsSkipUsecase returns a success", (WidgetTester tester) async {
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => const Right(WalkthroughEntity(isSkip: true)));

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 1));
      
      expect(find.byKey(const Key("logo")), findsOneWidget);
      expect(find.byKey(const Key("usernameField")), findsOneWidget);
      expect(find.byKey(const Key("passwordField")), findsOneWidget);
      expect(find.byKey(const Key("submitButton")), findsOneWidget);
      expect(find.byKey(const Key("forgotPasswordTextButton")), findsOneWidget);
      expect(find.byKey(const Key("signUpTextButton")), findsOneWidget);

      verify(mockGetIsSkipUsecase(NoParam()));
    });

  });

  testWidgets("Should redirect to login view properly when SetIsSkipUsecase returns WalkthroughSkipSuccess", (WidgetTester tester) async {
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => Left(CachedFailure(message: Failure.cacheError)));
    when(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true))).thenAnswer((_) async => const Right(null));

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      verify(mockGetIsSkipUsecase(NoParam()));

      await Future.delayed(const Duration(seconds: 1));

      await tester.tap(find.byKey(const Key("getStartedButton")));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));

      expect(find.byKey(const Key("logo")), findsOneWidget);
      expect(find.byKey(const Key("usernameField")), findsOneWidget);
      expect(find.byKey(const Key("passwordField")), findsOneWidget);
      expect(find.byKey(const Key("submitButton")), findsOneWidget);
      expect(find.byKey(const Key("forgotPasswordTextButton")), findsOneWidget);
      expect(find.byKey(const Key("signUpTextButton")), findsOneWidget);
      verify(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true)));
    });

  });

  testWidgets("Should redirect to login view properly when SetIsSkipUsecase returns WalkthroughSkipFailed", (WidgetTester tester) async {
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => Left(CachedFailure(message: Failure.cacheError)));
    when(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true))).thenAnswer((_) async => Left(CachedFailure(message: Failure.cacheError)));

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      verify(mockGetIsSkipUsecase(NoParam()));

      await Future.delayed(const Duration(seconds: 1));

      await tester.tap(find.byKey(const Key("getStartedButton")));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));

      expect(find.byKey(const Key("logo")), findsOneWidget);
      expect(find.byKey(const Key("usernameField")), findsOneWidget);
      expect(find.byKey(const Key("passwordField")), findsOneWidget);
      expect(find.byKey(const Key("submitButton")), findsOneWidget);
      expect(find.byKey(const Key("forgotPasswordTextButton")), findsOneWidget);
      expect(find.byKey(const Key("signUpTextButton")), findsOneWidget);
      verify(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true)));
    });

  });
}


Widget buildWidget({
  required WalkthroughBloc walkthroughBloc,
  required LoginBloc loginBloc
}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<WalkthroughBloc>(
        create: (_) => walkthroughBloc..add(WalkthroughGetSkip())
      ),
      BlocProvider<LoginBloc>(
        create: (_) => loginBloc
      ),
    ], 
    child: MaterialApp(
      home: const MainPage(),
      routes: {
        WalkthroughView.routeName: (context) => const WalkthroughView(),
        LoginView.routeName: (context) => const LoginView()
      },
    )
  );
}