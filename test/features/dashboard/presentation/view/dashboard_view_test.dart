
import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/assets/fonts/fonts.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/widgets/styles/text_styles.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_state.dart';
import 'package:crosscheck/features/dashboard/domain/entities/activity_entity.dart';
import 'package:crosscheck/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:crosscheck/features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';
import 'package:crosscheck/features/main/domain/usecase/get_active_bottom_navigation_usecase.dart';
import 'package:crosscheck/features/main/domain/usecase/set_active_bottom_navigation_usecase.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_bloc.dart';
import 'package:crosscheck/features/main/presentation/view/main_view.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'dashboard_view_test.mocks.dart';

@GenerateMocks([
  AuthenticationBloc,
  SetActiveBottomNavigationUsecase,
  GetActiveBottomNavigationUsecase,
  GetDashboardUsecase
])
void main() {
  late MockAuthenticationBloc mockAuthenticationBloc;
  late MockSetActiveBottomNavigationUsecase mockSetActiveBottomNavigationUsecase;
  late MockGetActiveBottomNavigationUsecase mockGetActiveBottomNavigationUsecase;
  late MockGetDashboardUsecase mockGetDashboardUsecase;
  late DashboardBloc dashboardBloc;
  late MainBloc mainBloc;
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
  setUp(() {
    mockAuthenticationBloc = MockAuthenticationBloc();
    mockSetActiveBottomNavigationUsecase = MockSetActiveBottomNavigationUsecase();
    mockGetActiveBottomNavigationUsecase = MockGetActiveBottomNavigationUsecase();
    mainBloc = MainBloc(
      getActiveBottomNavigationUsecase: mockGetActiveBottomNavigationUsecase,
      setActiveBottomNavigationUsecase: mockSetActiveBottomNavigationUsecase
    );
    mockGetDashboardUsecase = MockGetDashboardUsecase();
    dashboardBloc = DashboardBloc(getDashboardUsecase: mockGetDashboardUsecase);
    testWidget = buildWidget(
      authenticationBloc: mockAuthenticationBloc, 
      dashboardBloc: dashboardBloc, 
      mainBloc: mainBloc
    );
  });

  testWidgets("Should display initial dashboard page properly", (WidgetTester tester) async {
    when(mockAuthenticationBloc.state).thenReturn(Authenticated());
    when(mockAuthenticationBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockGetActiveBottomNavigationUsecase(any)).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return Right(DashboardEntity(progress: 8, upcoming: 23, completed: 2, activities: activities));
    });

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);
      await tester.pump();

      expect(find.text("N/A"), findsOneWidget);
      expect(find.text("You have no task right now"), findsOneWidget);
      expect(tester.widgetList<Text>(find.text("0")).length, 2);
      expect(tester.widgetList<Text>(find.text("0%")).length, 1);
    });

  });

  testWidgets("Should display loading modal properly", (WidgetTester tester) async {
    when(mockAuthenticationBloc.state).thenReturn(Authenticated());
    when(mockAuthenticationBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockGetActiveBottomNavigationUsecase(any)).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return Right(DashboardEntity(progress: 8, upcoming: 23, completed: 2, activities: activities));
    });

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);
      await tester.pump();
      await tester.pump();

      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      
    });

  });

  testWidgets("Should properly load data on dashboard page", (WidgetTester tester) async {
    when(mockAuthenticationBloc.state).thenReturn(Authenticated());
    when(mockAuthenticationBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockGetActiveBottomNavigationUsecase(any)).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return Right(DashboardEntity(progress: 8, upcoming: 23, completed: 2, activities: activities));
    });

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);
      await tester.pump();
      await tester.pump();

      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      expect(find.text("Loading..."), findsNothing);
      
      expect(find.text("You have 23 tasks right now"), findsOneWidget);
      expect(find.text("8%"), findsOneWidget);
    });

  });

  testWidgets("Should display error modal when get dashboard is failed", (WidgetTester tester) async {
    when(mockAuthenticationBloc.state).thenReturn(Authenticated());
    when(mockAuthenticationBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockGetActiveBottomNavigationUsecase(any)).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return Left(ServerFailure(message: Failure.generalError));
    });

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);
      await tester.pump();
      await tester.pump();

      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      expect(find.text("Loading..."), findsNothing);

      expect(find.text(Failure.generalError), findsOneWidget);
    });

  });

  testWidgets("Should display error modal when get dashboard is failed", (WidgetTester tester) async {
    when(mockAuthenticationBloc.state).thenReturn(Authenticated());
    when(mockAuthenticationBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockGetActiveBottomNavigationUsecase(any)).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return Left(ServerFailure(message: Failure.generalError));
    });

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);
      await tester.pump();
      await tester.pump();

      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      expect(find.text("Loading..."), findsNothing);

      expect(find.text(Failure.generalError), findsOneWidget);

      await tester.ensureVisible(find.byKey(const Key("dismissButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("dismissButton")));
      await tester.pump();
    });

  });
}

Widget buildWidget({
  required AuthenticationBloc authenticationBloc,
  required DashboardBloc dashboardBloc,
  required MainBloc mainBloc
}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<AuthenticationBloc>(
        create: (_) => authenticationBloc
      ),
      BlocProvider<DashboardBloc>(
        create: (_) => dashboardBloc
      ),
      BlocProvider<MainBloc>(
        create: (_) => mainBloc
      )
    ], 
    child: MaterialApp(
      theme: ThemeData(
        shadowColor: Colors.black.withOpacity(0.5),
        backgroundColor: CustomColors.secondary,
        fontFamily: FontFamily.poppins,
        colorScheme: const ColorScheme(
          brightness: Brightness.light, 
          primary: CustomColors.primary, 
          onPrimary: Colors.white, 
          secondary: CustomColors.secondary, 
          onSecondary: Colors.white, 
          error: CustomColors.primary, 
          onError: CustomColors.secondary, 
          background: Colors.white, 
          onBackground: CustomColors.secondary, 
          surface: Colors.white, 
          onSurface: Colors.white,
          surfaceTint: CustomColors.placeholderText
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyles.poppinsBold34,
          headline1: TextStyles.poppinsBold24,
          subtitle1: TextStyles.poppinsBold16,
          subtitle2: TextStyles.poppinsRegular16,
          bodyText1: TextStyles.poppinsRegular14,
          bodyText2: TextStyles.poppinsRegular12,
          button: TextStyles.poppinsRegular16
        )
      ),
      home: const MainView(),
    )
  );
}