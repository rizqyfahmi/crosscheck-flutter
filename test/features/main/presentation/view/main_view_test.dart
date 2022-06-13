import 'package:crosscheck/assets/colors/custom_colors.dart';
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

import 'main_view_test.mocks.dart';

@GenerateMocks([
  MainBloc
])
void main() {
  late MockMainBloc mockMainBloc;
  late Widget testWidget;

  setUp(() {
    mockMainBloc = MockMainBloc();
    testWidget = buildWidget(mainBloc: mockMainBloc);
  });

  testWidgets("Should display main view properly", (WidgetTester tester) async {
    when(mockMainBloc.state).thenReturn(const MainInit());
    when(mockMainBloc.stream).thenAnswer((_) => Stream.fromIterable([]));

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();

    expect(find.text("Home"), findsWidgets);
    expect(find.text("Event"), findsWidgets);
    expect(find.text("History"), findsWidgets);
    expect(find.text("Settings"), findsWidgets);
    expect(find.byKey(const Key("plusButton")), findsOneWidget);
  });

  testWidgets("Should activate home at first time", (WidgetTester tester) async {
    when(mockMainBloc.state).thenReturn(const MainInit());
    when(mockMainBloc.stream).thenAnswer((_) => Stream.fromIterable([]));

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();

    final homeText = tester.widget<Text>(find.byKey(const Key("navHomeText")));
    expect(homeText.style?.color, CustomColors.primary);
    final eventText = tester.widget<Text>(find.byKey(const Key("navEventText")));
    expect(eventText.style?.color, CustomColors.secondary);
    final historyText = tester.widget<Text>(find.byKey(const Key("navHistoryText")));
    expect(historyText.style?.color, CustomColors.secondary);
    final settingText = tester.widget<Text>(find.byKey(const Key("navSettingText")));
    expect(settingText.style?.color, CustomColors.secondary);
  });

  testWidgets("Should activate event when chose event menu", (WidgetTester tester) async {
    when(mockMainBloc.state).thenReturn(const MainInit());
    when(mockMainBloc.stream).thenAnswer((_) => Stream.fromIterable([
      const MainChanged(model: MainModel(currentPage: BottomNavigation.event))
    ]));

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();

    final homeText = tester.widget<Text>(find.byKey(const Key("navHomeText")));
    expect(homeText.style?.color, CustomColors.secondary);
    final eventText = tester.widget<Text>(find.byKey(const Key("navEventText")));
    expect(eventText.style?.color, CustomColors.primary);
    final historyText = tester.widget<Text>(find.byKey(const Key("navHistoryText")));
    expect(historyText.style?.color, CustomColors.secondary);
    final settingText = tester.widget<Text>(find.byKey(const Key("navSettingText")));
    expect(settingText.style?.color, CustomColors.secondary);
  });

  testWidgets("Should activate history when chose history menu", (WidgetTester tester) async {
    when(mockMainBloc.state).thenReturn(const MainInit());
    when(mockMainBloc.stream).thenAnswer((_) => Stream.fromIterable([
      const MainChanged(model: MainModel(currentPage: BottomNavigation.history))
    ]));

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();

    final homeText = tester.widget<Text>(find.byKey(const Key("navHomeText")));
    expect(homeText.style?.color, CustomColors.secondary);
    final eventText = tester.widget<Text>(find.byKey(const Key("navEventText")));
    expect(eventText.style?.color, CustomColors.secondary);
    final historyText = tester.widget<Text>(find.byKey(const Key("navHistoryText")));
    expect(historyText.style?.color, CustomColors.primary);
    final settingText = tester.widget<Text>(find.byKey(const Key("navSettingText")));
    expect(settingText.style?.color, CustomColors.secondary);
  });

  testWidgets("Should activate settings when chose settings menu", (WidgetTester tester) async {
    when(mockMainBloc.state).thenReturn(const MainInit());
    when(mockMainBloc.stream).thenAnswer((_) => Stream.fromIterable([
      const MainChanged(model: MainModel(currentPage: BottomNavigation.setting))
    ]));

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();

    final homeText = tester.widget<Text>(find.byKey(const Key("navHomeText")));
    expect(homeText.style?.color, CustomColors.secondary);
    final eventText = tester.widget<Text>(find.byKey(const Key("navEventText")));
    expect(eventText.style?.color, CustomColors.secondary);
    final historyText = tester.widget<Text>(find.byKey(const Key("navHistoryText")));
    expect(historyText.style?.color, CustomColors.secondary);
    final settingText = tester.widget<Text>(find.byKey(const Key("navSettingText")));
    expect(settingText.style?.color, CustomColors.primary);
  });
}

Widget buildWidget({
  required MainBloc mainBloc
}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<MainBloc>(
        create: (_) => mainBloc,
      )
    ], 
    child: const MaterialApp(
      home: MainView(),
    )
  );
}