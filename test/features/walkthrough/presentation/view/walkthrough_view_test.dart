
import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/assets/fonts/fonts.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/widgets/styles/text_styles.dart';
import 'package:crosscheck/features/authentication/presentation/login/view/login_view.dart';
import 'package:crosscheck/features/authentication/presentation/login/bloc/login_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/login/bloc/login_state.dart';
import 'package:crosscheck/features/walkthrough/presentation/view/walkthrough_view.dart';
import 'package:crosscheck/features/walkthrough/presentation/bloc/walkthrough_bloc.dart';
import 'package:crosscheck/features/walkthrough/presentation/bloc/walkthrough_event.dart';
import 'package:crosscheck/features/walkthrough/presentation/bloc/walkthrough_model.dart';
import 'package:crosscheck/features/walkthrough/presentation/bloc/walkthrough_state.dart';
import 'package:crosscheck/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'walkthrough_view_test.mocks.dart';

@GenerateMocks([
  LoginBloc,
  WalkthroughBloc
])
void main() {
  late MockWalkthroughBloc mockWalkthroughBloc;
  late MockLoginBloc mockLoginBloc;
  late Widget testWidget;

  group("MainPage", () {
    setUp(() {
      mockWalkthroughBloc = MockWalkthroughBloc();
      mockLoginBloc = MockLoginBloc();
      testWidget = buildWidget(
        loginBloc: mockLoginBloc,
        walkthroughBloc: mockWalkthroughBloc,
        child: const MainPage()
      );

      when(mockLoginBloc.state).thenReturn(const LoginInitial());
      when(mockLoginBloc.stream).thenAnswer((_) => Stream.fromIterable([const LoginInitial()]));
    });

    testWidgets("Should display walkthrough view properly when GetIsSkipUsecase returns a failure", (WidgetTester tester) async {
      when(mockWalkthroughBloc.state).thenReturn(const WalkthroughInitial());
      when(mockWalkthroughBloc.stream).thenAnswer((_) => Stream.fromIterable([
        const WalkthroughLoadSkipFailed(message: Failure.cacheError, model: WalkthroughModel(isSkip: true))
      ]));

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      
      expect(find.byKey(const Key("illustration")), findsOneWidget);
      expect(find.text("Welcome"), findsOneWidget);
      expect(find.text("Focus on your short and long-term habit to improve productivity and achieve your goals. Enjoy your way to better time management"), findsOneWidget);
      expect(find.byKey(const Key("getStartedButton")), findsOneWidget);

    });

    testWidgets("Should display login view properly when GetIsSkipUsecase returns a success", (WidgetTester tester) async {
      when(mockWalkthroughBloc.state).thenReturn(const WalkthroughInitial());
      when(mockWalkthroughBloc.stream).thenAnswer((_) => Stream.fromIterable([
        const WalkthroughLoadSkipSuccess(model: WalkthroughModel(isSkip: true))
      ]));

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key("logo")));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key("logo")), findsOneWidget);
      await tester.ensureVisible(find.byKey(const Key("usernameField")));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key("usernameField")), findsOneWidget);
      await tester.ensureVisible(find.byKey(const Key("passwordField")));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key("passwordField")), findsOneWidget);
      await tester.ensureVisible(find.byKey(const Key("submitButton")));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key("submitButton")), findsOneWidget);
      await tester.ensureVisible(find.byKey(const Key("forgotPasswordTextButton")));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key("forgotPasswordTextButton")), findsOneWidget);
      await tester.ensureVisible(find.byKey(const Key("signUpTextButton")));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key("signUpTextButton")), findsOneWidget);

    });
  });

  group("WalkthroughView", () {
    setUp(() {
      mockWalkthroughBloc = MockWalkthroughBloc();
      mockLoginBloc = MockLoginBloc();
      testWidget = buildWidget(
        loginBloc: mockLoginBloc,
        walkthroughBloc: mockWalkthroughBloc,
        child: const MainPage()
      );

      when(mockLoginBloc.state).thenReturn(const LoginInitial());
      when(mockLoginBloc.stream).thenAnswer((_) => Stream.fromIterable([const LoginInitial()]));
    });

    testWidgets("Should redirect to login view properly when SetIsSkipUsecase returns WalkthroughSkipSuccess", (WidgetTester tester) async {
      when(mockWalkthroughBloc.state).thenReturn(const WalkthroughInitial());
      when(mockWalkthroughBloc.stream).thenAnswer((_) => Stream.fromIterable([
        const WalkthroughLoadSkipFailed(message: Failure.cacheError, model: WalkthroughModel(isSkip: true)),
        const WalkthroughSkipSuccess(model: WalkthroughModel(isSkip: true))
      ]).asyncExpand((state) async* {
        yield state;
        await Future.delayed(const Duration(seconds: 1));
      }));
      
      await tester.runAsync(() async {
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.byKey(const Key("illustration")));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key("illustration")), findsOneWidget);
        expect(find.text("Welcome"), findsOneWidget);
        expect(find.text("Focus on your short and long-term habit to improve productivity and achieve your goals. Enjoy your way to better time management"), findsOneWidget);
        await tester.ensureVisible(find.byKey(const Key("getStartedButton")));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key("getStartedButton")), findsOneWidget);

        await Future.delayed(const Duration(seconds: 2));
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.byKey(const Key("logo")));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key("logo")), findsOneWidget);

        await tester.ensureVisible(find.byKey(const Key("usernameField")));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key("usernameField")), findsOneWidget);

        await tester.ensureVisible(find.byKey(const Key("passwordField")));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key("passwordField")), findsOneWidget);

        await tester.ensureVisible(find.byKey(const Key("submitButton")));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key("submitButton")), findsOneWidget);

        await tester.ensureVisible(find.byKey(const Key("forgotPasswordTextButton")));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key("forgotPasswordTextButton")), findsOneWidget);

        await tester.ensureVisible(find.byKey(const Key("signUpTextButton")));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key("signUpTextButton")), findsOneWidget);

      });
    });

    testWidgets("Should redirect to login view properly when SetIsSkipUsecase returns WalkthroughSkipFailed", (WidgetTester tester) async {
      when(mockWalkthroughBloc.state).thenReturn(const WalkthroughInitial());
      when(mockWalkthroughBloc.stream).thenAnswer((_) => Stream.fromIterable([
        const WalkthroughLoadSkipFailed(message: Failure.cacheError, model: WalkthroughModel(isSkip: true)),
        const WalkthroughSkipFailed(message: Failure.cacheError, model: WalkthroughModel(isSkip: false))
      ]).asyncExpand((state) async* {
        yield state;
        await Future.delayed(const Duration(seconds: 1));
      }));
      
      await tester.runAsync(() async {
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.byKey(const Key("illustration")));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key("illustration")), findsOneWidget);
        expect(find.text("Welcome"), findsOneWidget);
        expect(find.text("Focus on your short and long-term habit to improve productivity and achieve your goals. Enjoy your way to better time management"), findsOneWidget);
        await tester.ensureVisible(find.byKey(const Key("getStartedButton")));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key("getStartedButton")), findsOneWidget);

        await Future.delayed(const Duration(seconds: 2));
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.byKey(const Key("logo")));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key("logo")), findsOneWidget);

        await tester.ensureVisible(find.byKey(const Key("usernameField")));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key("usernameField")), findsOneWidget);

        await tester.ensureVisible(find.byKey(const Key("passwordField")));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key("passwordField")), findsOneWidget);

        await tester.ensureVisible(find.byKey(const Key("submitButton")));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key("submitButton")), findsOneWidget);

        await tester.ensureVisible(find.byKey(const Key("forgotPasswordTextButton")));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key("forgotPasswordTextButton")), findsOneWidget);

        await tester.ensureVisible(find.byKey(const Key("signUpTextButton")));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key("signUpTextButton")), findsOneWidget);

      });

    });
  });
}

Widget buildWidget({
  required WalkthroughBloc walkthroughBloc,
  required LoginBloc loginBloc,
  required Widget child
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
      home: child,
      routes: {
        WalkthroughView.routeName: (context) => const WalkthroughView(),
        LoginView.routeName: (context) => const LoginView()
      },
    )
  );
}
