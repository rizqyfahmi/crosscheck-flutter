
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_state.dart';
import 'package:crosscheck/features/dashboard/domain/entities/activity_entity.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/activity_model.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_model.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_bloc.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_model.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_state.dart';
import 'package:crosscheck/features/main/presentation/view/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'dashboard_view_test.mocks.dart';

@GenerateMocks([
  AuthenticationBloc,
  DashboardBloc,
  MainBloc
])
void main() {
  late MockAuthenticationBloc mockAuthenticationBloc;
  late MockDashboardBloc mockDashboardBloc;
  late MockMainBloc mockMainBloc;
  late DashboardModel dashboardBlocModel;
  late Widget testWidget;

  const String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";
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
  final double weeklyTotal = activities.map((e) => double.parse(e.total.toString())).reduce((value, result) => value + result);
  setUp(() {
    dashboardBlocModel = DashboardModel(
      username: "N/A",
      upcoming: 23,
      completed: 2,
      progress: "8%",
      taskText: "You have 23 tasks right now",
      activities: activities.map((activity) {
        final calculatedProgress = (activity.total / weeklyTotal) * 100;
        return ActivityModel(
          progress: (calculatedProgress).toStringAsFixed(0), 
          isActive: currentDate.weekday == activity.date.weekday, 
          date: activity.date, 
          total: activity.total,
          heightBar: (calculatedProgress / 100 * 160)
        );
      }).toList()
    );
    mockAuthenticationBloc = MockAuthenticationBloc();
    mockDashboardBloc = MockDashboardBloc();
    mockMainBloc = MockMainBloc();
    testWidget = buildWidget(authenticationBloc: mockAuthenticationBloc, dashboardBloc: mockDashboardBloc, mainBloc: mockMainBloc);
  });

  testWidgets("Should display initial dashboard page properly", (WidgetTester tester) async {
    when(mockMainBloc.state).thenReturn(const MainChanged(model: MainModel(currentPage: BottomNavigation.home)));
    when(mockMainBloc.stream).thenAnswer((_) => Stream.fromIterable([
      const MainLoading(model: MainModel(currentPage: BottomNavigation.home))
    ]));
    when(mockAuthenticationBloc.state).thenReturn(const Authenticated(token: token));
    when(mockAuthenticationBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockDashboardBloc.state).thenReturn(DashboardInit());
    when(mockDashboardBloc.stream).thenAnswer((_) => Stream.fromIterable([]));

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
    when(mockMainBloc.state).thenReturn(const MainChanged(model: MainModel(currentPage: BottomNavigation.home)));
    when(mockMainBloc.stream).thenAnswer((_) => Stream.fromIterable([
      const MainLoading(model: MainModel(currentPage: BottomNavigation.home))
    ]));
    when(mockAuthenticationBloc.state).thenReturn(const Authenticated(token: token));
    when(mockAuthenticationBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockDashboardBloc.state).thenReturn(DashboardInit());
    when(mockDashboardBloc.stream).thenAnswer((_) => Stream.fromIterable([
      DashboardLoading(model: DashboardModel()),
    ]).asyncExpand((state) async* {
      yield state;
      await Future.delayed(const Duration(seconds: 2));
    }));

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);
      await tester.pump();

      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      
    });

  });

  testWidgets("Should properly load data on dashboard page", (WidgetTester tester) async {
    when(mockMainBloc.state).thenReturn(const MainInit());
    when(mockMainBloc.stream).thenAnswer((_) => Stream.fromIterable([
      const MainChanged(model: MainModel(currentPage: BottomNavigation.home)),
      const MainLoading(model: MainModel(currentPage: BottomNavigation.home)),
      const MainLoadingCompleted(model: MainModel(currentPage: BottomNavigation.home))
    ]).asyncExpand((state) async* {
      yield state;
      await Future.delayed(const Duration(seconds: 1));
    }));
    when(mockAuthenticationBloc.state).thenReturn(const Authenticated(token: token));
    when(mockAuthenticationBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockDashboardBloc.state).thenReturn(DashboardInit());
    when(mockDashboardBloc.stream).thenAnswer((_) => Stream.fromIterable([
      DashboardLoading(model: DashboardModel()),
      DashboardSuccess(model: dashboardBlocModel)
    ]).asyncExpand((state) async* {
      await Future.delayed(const Duration(seconds: 1));
      yield state;
    }));

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);
      await tester.pump();

      await Future.delayed(const Duration(seconds: 1));
      await tester.pump();

      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 1));
      await tester.pump();

      await Future.delayed(const Duration(seconds: 1));
      await tester.pump();

      await Future.delayed(const Duration(seconds: 1));
      await tester.pump();
      
      await Future.delayed(const Duration(seconds: 1));
      await tester.pump();
      
      expect(find.text("You have 23 tasks right now"), findsOneWidget);
      expect(find.text("8%"), findsOneWidget);
    });

  });

  testWidgets("Should display error modal when get dashboard is failed", (WidgetTester tester) async {
    when(mockMainBloc.state).thenReturn(const MainChanged(model: MainModel(currentPage: BottomNavigation.home)));
    when(mockMainBloc.stream).thenAnswer((_) => Stream.fromIterable([
      const MainLoading(model: MainModel(currentPage: BottomNavigation.home)),
      const MainGeneralError(model: MainModel(currentPage: BottomNavigation.home), message: Failure.generalError)
    ]).asyncExpand((state) async* {
      yield state;
      if (state is MainGeneralError) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }));
    when(mockAuthenticationBloc.state).thenReturn(const Authenticated(token: token));
    when(mockAuthenticationBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockDashboardBloc.state).thenReturn(DashboardInit());
    when(mockDashboardBloc.stream).thenAnswer((_) => Stream.fromIterable([
      DashboardLoading(model: DashboardModel()),
      DashboardGeneralError(model: DashboardModel(), message: Failure.generalError)
    ]).asyncExpand((state) async* {
      yield state;
      if (state is DashboardLoading) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }));

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);
      await tester.pump();

      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 1));
      await tester.pump();

      expect(find.text(Failure.generalError), findsOneWidget);
    });

  });

  testWidgets("Should display error modal when get dashboard is failed", (WidgetTester tester) async {
    when(mockMainBloc.state).thenReturn(const MainChanged(model: MainModel(currentPage: BottomNavigation.home)));
    when(mockMainBloc.stream).thenAnswer((_) => Stream.fromIterable([
      const MainLoading(model: MainModel(currentPage: BottomNavigation.home)),
      const MainGeneralError(model: MainModel(currentPage: BottomNavigation.home), message: Failure.generalError),
      const MainNoGeneralError(model: MainModel(currentPage: BottomNavigation.home))
    ]).asyncExpand((state) async* {
      yield state;
      if (state is MainGeneralError) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }));
    when(mockAuthenticationBloc.state).thenReturn(const Authenticated(token: token));
    when(mockAuthenticationBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockDashboardBloc.state).thenReturn(DashboardInit());
    when(mockDashboardBloc.stream).thenAnswer((_) => Stream.fromIterable([
      DashboardLoading(model: DashboardModel()),
      DashboardGeneralError(model: DashboardModel(), message: Failure.generalError),
      DashboardNoGeneralError(model: DashboardModel())
    ]).asyncExpand((state) async* {
      yield state;
      if ((state is DashboardLoading) || (state is DashboardGeneralError)) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }));

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);
      await tester.pump();

      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 1));
      await tester.pump();

      expect(find.text(Failure.generalError), findsOneWidget);
      await Future.delayed(const Duration(seconds: 1));
      await tester.pump();

      expect(find.text(Failure.generalError), findsNothing);
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
    child: const MaterialApp(
      home: MainView(),
    )
  );
}