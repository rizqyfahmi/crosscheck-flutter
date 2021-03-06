import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/assets/fonts/fonts.dart';
import 'package:crosscheck/core/widgets/styles/text_styles.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_state.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_bloc.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_model.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_state.dart';
import 'package:crosscheck/features/main/presentation/view/main_view.dart';
import 'package:crosscheck/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:crosscheck/features/profile/presentation/bloc/profile_state.dart';
import 'package:crosscheck/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:crosscheck/features/settings/presentation/bloc/settings_state.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_bloc.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'main_view_test.mocks.dart';

@GenerateMocks([
  AuthenticationBloc,
  MainBloc,
  DashboardBloc,
  SettingsBloc,
  ProfileBloc,
  TaskBloc
])
void main() {
  late MockAuthenticationBloc mockAuthenticationBloc;
  late MockMainBloc mockMainBloc;
  late MockDashboardBloc mockDashboardBloc;
  late MockSettingsBloc mockSettingsBloc;
  late MockProfileBloc mockProfileBloc;
  late MockTaskBloc mockTaskBloc;
  late Widget testWidget;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    mockAuthenticationBloc = MockAuthenticationBloc();
    mockMainBloc = MockMainBloc();
    mockDashboardBloc = MockDashboardBloc();
    mockSettingsBloc = MockSettingsBloc();
    mockProfileBloc = MockProfileBloc();
    mockTaskBloc = MockTaskBloc();
    testWidget = buildWidget(
      authenticationBloc: mockAuthenticationBloc,
      mainBloc: mockMainBloc,
      dashboardBloc: mockDashboardBloc,
      settingsBloc: mockSettingsBloc,
      profileBloc: mockProfileBloc,
      taskBloc: mockTaskBloc
    );
  });

  testWidgets("Should display main view properly", (WidgetTester tester) async {
    when(mockMainBloc.state).thenReturn(const MainInit());
    when(mockMainBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockAuthenticationBloc.state).thenReturn(Authenticated());
    when(mockAuthenticationBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockDashboardBloc.state).thenReturn(DashboardInit());
    when(mockDashboardBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockProfileBloc.state).thenReturn(const ProfileInit());
    when(mockProfileBloc.stream).thenAnswer((_) => Stream.fromIterable([]));

    await mockNetworkImagesFor(() => tester.pumpWidget(testWidget));
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
    when(mockAuthenticationBloc.state).thenReturn(Authenticated());
    when(mockAuthenticationBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockDashboardBloc.state).thenReturn(DashboardInit());
    when(mockDashboardBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockProfileBloc.state).thenReturn(const ProfileInit());
    when(mockProfileBloc.stream).thenAnswer((_) => Stream.fromIterable([]));

    await mockNetworkImagesFor(() => tester.pumpWidget(testWidget));
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
    when(mockAuthenticationBloc.state).thenReturn(Authenticated());
    when(mockAuthenticationBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockDashboardBloc.state).thenReturn(DashboardInit());
    when(mockDashboardBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockProfileBloc.state).thenReturn(const ProfileInit());
    when(mockProfileBloc.stream).thenAnswer((_) => Stream.fromIterable([]));

    await mockNetworkImagesFor(() => tester.pumpWidget(testWidget));
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
    when(mockAuthenticationBloc.state).thenReturn(Authenticated());
    when(mockAuthenticationBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockDashboardBloc.state).thenReturn(DashboardInit());
    when(mockDashboardBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockProfileBloc.state).thenReturn(const ProfileInit());
    when(mockProfileBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockTaskBloc.state).thenReturn(TaskInit());
    when(mockTaskBloc.stream).thenAnswer((_) => Stream.fromIterable([]));

    await mockNetworkImagesFor(() => tester.pumpWidget(testWidget));
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
    when(mockAuthenticationBloc.state).thenReturn(Authenticated());
    when(mockAuthenticationBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockDashboardBloc.state).thenReturn(DashboardInit());
    when(mockDashboardBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockSettingsBloc.state).thenReturn(SettingsInit());
    when(mockSettingsBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockProfileBloc.state).thenReturn(const ProfileInit());
    when(mockProfileBloc.stream).thenAnswer((_) => Stream.fromIterable([]));

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);
      await mockNetworkImagesFor(() => tester.pumpAndSettle());

      final homeText = tester.widget<Text>(find.byKey(const Key("navHomeText")));
      expect(homeText.style?.color, CustomColors.secondary);
      final eventText = tester.widget<Text>(find.byKey(const Key("navEventText")));
      expect(eventText.style?.color, CustomColors.secondary);
      final historyText = tester.widget<Text>(find.byKey(const Key("navHistoryText")));
      expect(historyText.style?.color, CustomColors.secondary);
      final settingText = tester.widget<Text>(find.byKey(const Key("navSettingText")));
      expect(settingText.style?.color, CustomColors.primary);
    });
  });
}

Widget buildWidget({
  required AuthenticationBloc authenticationBloc,
  required MainBloc mainBloc,
  required DashboardBloc dashboardBloc,
  required SettingsBloc settingsBloc,
  required ProfileBloc profileBloc,
  required TaskBloc taskBloc
}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<AuthenticationBloc>(
        create: (_) => authenticationBloc
      ),
      BlocProvider<MainBloc>(
        create: (_) => mainBloc,
      ),
      BlocProvider<DashboardBloc>(
        create: (_) => dashboardBloc,
      ),
      BlocProvider<SettingsBloc>(
        create: (_) => settingsBloc,
      ),
      BlocProvider<ProfileBloc>(
        create: (_) => profileBloc
      ),
      BlocProvider<TaskBloc>(
        create: (_) => taskBloc
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