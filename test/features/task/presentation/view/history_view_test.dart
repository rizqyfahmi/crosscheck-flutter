import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/task/domain/usecases/get_history_usecase.dart';
import 'package:crosscheck/features/task/domain/usecases/get_initial_task_by_date_usecase.dart';
import 'package:crosscheck/features/task/domain/usecases/get_monthly_task_usecase.dart';
import 'package:crosscheck/features/task/domain/usecases/get_more_history_usecase.dart';
import 'package:crosscheck/features/task/domain/usecases/get_refresh_history_usecase.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_bloc.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_event.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_state.dart';
import 'package:crosscheck/features/task/presentation/view/history_view.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/utils.dart';
import 'history_view_test.mocks.dart';

@GenerateMocks([
  GetHistoryUsecase,
  GetMoreHistoryUsecase,
  GetRefreshHistoryUsecase,
  GetInitialTaskByDateUsecase,
  GetMonthlyTaskUsecase
])
void main() {
  late MockGetHistoryUsecase mockGetHistoryUsecase;
  late MockGetMoreHistoryUsecase mockGetMoreHistoryUsecase;
  late MockGetRefreshHistoryUsecase mockGetRefreshHistoryUsecase;
  late MockGetInitialTaskByDateUsecase mockGetInitialTaskByDateUsecase;
  late MockGetMonthlyTaskUsecase mockGetMonthlyTaskUsecase;
  late TaskBloc taskBloc;
  late Widget testWidget;

  setUp(() {
    mockGetHistoryUsecase = MockGetHistoryUsecase();
    mockGetMoreHistoryUsecase = MockGetMoreHistoryUsecase();
    mockGetRefreshHistoryUsecase = MockGetRefreshHistoryUsecase();
    mockGetInitialTaskByDateUsecase = MockGetInitialTaskByDateUsecase();
    mockGetMonthlyTaskUsecase = MockGetMonthlyTaskUsecase();
    taskBloc = TaskBloc(
      getHistoryUsecase: mockGetHistoryUsecase,
      getMoreHistoryUsecase: mockGetMoreHistoryUsecase,
      getRefreshHistoryUsecase: mockGetRefreshHistoryUsecase,
      getInitialTaskByDateUsecase: mockGetInitialTaskByDateUsecase,
      getMonthlyTaskUsecase: mockGetMonthlyTaskUsecase
    );
    testWidget = buildWidget(taskBloc: taskBloc);
  });

  testWidgets("Should get history properly", (WidgetTester tester) async {
    int currentTotalTasks = 0;
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      currentTotalTasks += 10;
      return Right(Utils().getTaskEntities(end: currentTotalTasks));
    });

    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      currentTotalTasks += 10;
      return Right(Utils().getTaskEntities(start: 0, end: currentTotalTasks));
    });

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);
      await tester.pump();
      expect(find.text("Loading..."), findsOneWidget);
      
      await Future.delayed(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(find.text("Loading..."), findsNothing);

      for (var i = 0; i < 10; i++) {
        await tester.ensureVisible(find.byKey(Key("TaskTile$i")));
        await tester.pump();
        expect(find.byKey(Key("TaskTile$i")), findsOneWidget); 
      }

      expect(currentTotalTasks, 10);
      
    });
  });

  testWidgets("Should not display anything when get history returns failure", (WidgetTester tester) async {
    int currentTotalTasks = 0;
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      return const Left(ServerFailure(message: Failure.generalError, data: []));
    });

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);
      await tester.pump();
      expect(find.text("Loading..."), findsOneWidget);
      
      await Future.delayed(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(find.text("Loading..."), findsNothing);
      await tester.pump();
      expect(find.byKey(const Key("responseDialog")), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key("dismissButton"), skipOffstage: false));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key("dismissButton"), skipOffstage: false), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("dismissButton"), skipOffstage: false));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key("responseDialog")), findsNothing);

      for (var i = 0; i < 10; i++) {
        await tester.pump();
        expect(find.byKey(Key("TaskTile$i")), findsNothing); 
      }

      expect(currentTotalTasks, 0);
      
    });
  });

  testWidgets("Should get more history properly", (WidgetTester tester) async {
    int currentTotalTasks = 0;
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      currentTotalTasks += 10;
      return Right(Utils().getTaskEntities(end: currentTotalTasks));
    });

    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      currentTotalTasks += 10;
      return Right(Utils().getTaskEntities(start: 0, end: currentTotalTasks));
    });

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);
      await tester.pump();
      expect(find.text("Loading..."), findsOneWidget);
      
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(find.text("Loading..."), findsNothing);

      for (var i = 0; i < 10; i++) {
        await tester.ensureVisible(find.byKey(Key("TaskTile$i")));
        await tester.pump();
        expect(find.byKey(Key("TaskTile$i")), findsOneWidget);
      }

      expect(currentTotalTasks, 10);
      
      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      expect(find.text("Loading..."), findsNothing);
      await tester.pump();

      expect(currentTotalTasks, 20);

      for (var i = 9; i >= 0; i--) {
        await tester.scrollUntilVisible(
          find.byKey(ValueKey('TaskTile$i')),
          -100.0,
          scrollable: find.byType(Scrollable),
        );
      }

      for (var i = 0; i < 20; i++) {
        await tester.scrollUntilVisible(
          find.byKey(ValueKey('TaskTile$i')),
          100.0,
          scrollable: find.byType(Scrollable),
        );
      }
    });
  });

  testWidgets("Should display only data from get history when get more history returns failure", (WidgetTester tester) async {
    int currentTotalTasks = 0;
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      currentTotalTasks += 10;
      return Right(Utils().getTaskEntities(end: currentTotalTasks));
    });

    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      return Left(ServerFailure(message: Failure.generalError, data: Utils().getTaskEntities(end: currentTotalTasks)));
    });

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);
      await tester.pump();
      expect(find.text("Loading..."), findsOneWidget);
      
      await Future.delayed(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(find.text("Loading..."), findsNothing);

      for (var i = 0; i < 10; i++) {
        await tester.ensureVisible(find.byKey(Key("TaskTile$i")));
        await tester.pump();
        expect(find.byKey(Key("TaskTile$i")), findsOneWidget);
      }

      expect(currentTotalTasks, 10);
      
      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      expect(find.text("Loading..."), findsNothing);
      await tester.pump();
      expect(find.byKey(const Key("responseDialog")), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key("dismissButton"), skipOffstage: false));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key("dismissButton"), skipOffstage: false), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("dismissButton"), skipOffstage: false));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key("responseDialog")), findsNothing);
      
      expect(currentTotalTasks, 10);

      for (var i = 9; i >= 0; i--) {
        await tester.ensureVisible(find.byKey(Key("TaskTile$i"), skipOffstage: false));
        await tester.pump();
        expect(find.byKey(Key("TaskTile$i"), skipOffstage: false), findsOneWidget);
      }

      for (var i = 0; i < 10; i++) {
        await tester.ensureVisible(find.byKey(Key("TaskTile$i"), skipOffstage: false));
        await tester.pump();
        expect(find.byKey(Key("TaskTile$i"), skipOffstage: false), findsOneWidget);
      }

      for (var i = 10; i < 20; i++) {
        await tester.pump();
        expect(find.byKey(Key("TaskTile$i"), skipOffstage: false), findsNothing);
      }

    });
  });

  testWidgets("Should get refresh history properly", (WidgetTester tester) async {
    int currentTotalTasks = 0;
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      currentTotalTasks += 10;
      return Right(Utils().getTaskEntities(end: currentTotalTasks));
    });

    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      currentTotalTasks += 10;
      return Right(Utils().getTaskEntities(start: 0, end: currentTotalTasks));
    });

    when(mockGetRefreshHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      currentTotalTasks = 10;
      return Right(Utils().getTaskEntities(start: 10, end: 20));
    });

    await tester.runAsync(() async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(testWidget);
      await tester.pump();
      expect(find.text("Loading..."), findsOneWidget);
      
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      expect(find.text("Loading..."), findsNothing);
      expect(currentTotalTasks, 10);

      await tester.fling(find.byKey(const Key("TaskTile0")), const Offset(0.0, 200.0), 1000.0);
      await tester.pump();

      expect(tester.getSemantics(find.byType(RefreshProgressIndicator)), matchesSemantics(label: 'Refresh'));

      await tester.pump(const Duration(seconds: 1)); // finish the scroll animation
      await tester.pump(const Duration(seconds: 1)); // finish the indicator settle animation
      await tester.pump();
      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      expect(find.text("Loading..."), findsNothing);

      expect(currentTotalTasks, 10);

      for (var i = 10; i < 20; i++) {
        await tester.ensureVisible(find.byKey(Key("TaskTile$i")));
        await tester.pump();
        expect(find.byKey(Key("TaskTile$i")), findsOneWidget);
      }

      handle.dispose();
    });
    
  });

  testWidgets("Should display only data from get history when refresh history returns failure", (WidgetTester tester) async {
    int currentTotalTasks = 0;
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      currentTotalTasks += 10;
      return Right(Utils().getTaskEntities(end: currentTotalTasks));
    });

    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      currentTotalTasks += 10;
      return Right(Utils().getTaskEntities(start: 0, end: currentTotalTasks));
    });

    when(mockGetRefreshHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      return Left(ServerFailure(message: Failure.generalError, data: Utils().getTaskEntities(end: currentTotalTasks)));
    });

    await tester.runAsync(() async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(testWidget);
      await tester.pump();
      expect(find.text("Loading..."), findsOneWidget);
      
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      expect(find.text("Loading..."), findsNothing);
      expect(currentTotalTasks, 10);

      await tester.fling(find.byKey(const Key("TaskTile0")), const Offset(0.0, 200.0), 1000.0);
      await tester.pump();

      expect(tester.getSemantics(find.byType(RefreshProgressIndicator)), matchesSemantics(label: 'Refresh'));

      await tester.pump(const Duration(seconds: 1)); // finish the scroll animation
      await tester.pump(const Duration(seconds: 1)); // finish the indicator settle animation
      await tester.pump();
      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      expect(find.text("Loading..."), findsNothing);
      await tester.pump();
      expect(find.byKey(const Key("responseDialog")), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key("dismissButton"), skipOffstage: false));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key("dismissButton"), skipOffstage: false), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("dismissButton"), skipOffstage: false));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key("responseDialog")), findsNothing);

      expect(currentTotalTasks, 10);

      for (var i = 0; i < 10; i++) {
        await tester.ensureVisible(find.byKey(Key("TaskTile$i")));
        await tester.pump();
        expect(find.byKey(Key("TaskTile$i")), findsOneWidget);
      }

      handle.dispose();
    });

  });

  testWidgets("Should get refresh history properly after get more history", (WidgetTester tester) async {
    int currentTotalTasks = 0;
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      currentTotalTasks += 10;
      return Right(Utils().getTaskEntities(end: currentTotalTasks));
    });

    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      currentTotalTasks += 10;
      return Right(Utils().getTaskEntities(start: 0, end: currentTotalTasks));
    });

    when(mockGetRefreshHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      currentTotalTasks = 10;
      return Right(Utils().getTaskEntities(start: 0, end: currentTotalTasks));
    });

    await tester.runAsync(() async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(testWidget);
      await tester.pump();
      expect(find.text("Loading..."), findsOneWidget);
      
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      expect(find.text("Loading..."), findsNothing);

      for (var i = 0; i < 10; i++) {
        await tester.ensureVisible(find.byKey(Key("TaskTile$i")));
        await tester.pump();
        expect(find.byKey(Key("TaskTile$i")), findsOneWidget);
      }

      expect(currentTotalTasks, 10);

      await tester.pump();
      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      expect(find.text("Loading..."), findsNothing);
      
      expect(currentTotalTasks, 20);

      for (var i = 10; i < 20; i++) {
        await tester.ensureVisible(find.byKey(Key("TaskTile$i"), skipOffstage: false));
        await tester.pump();
        expect(find.byKey(Key("TaskTile$i"), skipOffstage: false), findsOneWidget);
      }

      await tester.pump();
      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      expect(find.text("Loading..."), findsNothing);

      expect(currentTotalTasks, 30);

      for (var i = 19; i >= 0; i--) {
        await tester.ensureVisible(find.byKey(Key("TaskTile$i"), skipOffstage: false));
        await tester.pump();
        expect(find.byKey(Key("TaskTile$i"), skipOffstage: false), findsOneWidget);
      }

      expect(find.byKey(const Key("TaskTile0")), findsOneWidget);
      await tester.fling(find.byKey(const Key("TaskTile0")), const Offset(0.0, 50.0), 1000.0);
      await tester.pump();

      await tester.fling(find.byKey(const Key("TaskTile0")), const Offset(0.0, 200.0), 1000.0);
      await tester.pump();

      expect(tester.getSemantics(find.byType(RefreshProgressIndicator)), matchesSemantics(label: 'Refresh'));

      await tester.pump(const Duration(seconds: 1)); // finish the scroll animation
      await tester.pump(const Duration(seconds: 1)); // finish the indicator settle animation
      await tester.pump(const Duration(seconds: 1)); // finish the indicator hide animation
      
      await Future.delayed(const Duration(seconds: 1));
      await tester.pump();

      expect(currentTotalTasks, 10);

      handle.dispose();
    });
  });

  testWidgets("Should get more history properly after get refresh history", (WidgetTester tester) async {
    int currentTotalTasks = 0;
    when(mockGetHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      currentTotalTasks += 10;
      return Right(Utils().getTaskEntities(end: currentTotalTasks));
    });

    when(mockGetMoreHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      currentTotalTasks += 10;
      return Right(Utils().getTaskEntities(start: 0, end: currentTotalTasks));
    });

    when(mockGetRefreshHistoryUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      currentTotalTasks = 10;
      return Right(Utils().getTaskEntities(start: 0, end: currentTotalTasks));
    });

    await tester.runAsync(() async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(testWidget);
      await tester.pump();
      expect(find.text("Loading..."), findsOneWidget);

      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      await tester.pump();
      expect(find.text("Loading..."), findsNothing);
      expect(currentTotalTasks, 10);

      await tester.fling(find.byKey(const Key("TaskTile0")), const Offset(0.0, 200.0), 1000.0);
      await tester.pump();

      expect(tester.getSemantics(find.byType(RefreshProgressIndicator)), matchesSemantics(label: 'Refresh'));

      await tester.pump(const Duration(seconds: 1)); // finish the scroll animation
      await tester.pump(const Duration(seconds: 1)); // finish the indicator settle animation
      await tester.pump();
      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      expect(find.text("Loading..."), findsNothing);

      expect(currentTotalTasks, 10);

      for (var i = 0; i < 10; i++) {
        await tester.ensureVisible(find.byKey(Key("TaskTile$i")));
        await tester.pump();
        expect(find.byKey(Key("TaskTile$i")), findsOneWidget);
      }

      await tester.pump();
      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      expect(find.text("Loading..."), findsNothing);
      
      expect(currentTotalTasks, 20);

      for (var i = 9; i >= 0; i--) {
        await tester.ensureVisible(find.byKey(Key("TaskTile$i"), skipOffstage: false));
        await tester.pump();
        expect(find.byKey(Key("TaskTile$i"), skipOffstage: false), findsOneWidget);
      }

      for (var i = 0; i < 20; i++) {
        await tester.ensureVisible(find.byKey(Key("TaskTile$i"), skipOffstage: false));
        await tester.pump();
        expect(find.byKey(Key("TaskTile$i"), skipOffstage: false), findsOneWidget);
      }

      await tester.pump();
      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      expect(find.text("Loading..."), findsNothing);

      expect(currentTotalTasks, 30);

      for (var i = 19; i >= 0; i--) {
        await tester.ensureVisible(find.byKey(Key("TaskTile$i"), skipOffstage: false));
        await tester.pump();
        expect(find.byKey(Key("TaskTile$i"), skipOffstage: false), findsOneWidget);
      }

      for (var i = 0; i < 30; i++) {
        await tester.ensureVisible(find.byKey(Key("TaskTile$i"), skipOffstage: false));
        await tester.pump();
        expect(find.byKey(Key("TaskTile$i"), skipOffstage: false), findsOneWidget);
      }

      handle.dispose();
    });
  });
}

Widget buildWidget({
  required TaskBloc taskBloc
}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<TaskBloc>(
        create: (_) => taskBloc..add(TaskGetHistory())
      ),
    ], 
    child: BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        return const MaterialApp(
          home: HistoryView(),
        );
      }
    )
  );
}
