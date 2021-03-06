
import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/assets/fonts/fonts.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/widgets/styles/text_styles.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_state.dart';
import 'package:crosscheck/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:crosscheck/features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';
import 'package:crosscheck/features/main/domain/usecase/get_active_bottom_navigation_usecase.dart';
import 'package:crosscheck/features/main/domain/usecase/set_active_bottom_navigation_usecase.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_bloc.dart';
import 'package:crosscheck/features/main/presentation/view/main_view.dart';
import 'package:crosscheck/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:crosscheck/features/profile/presentation/bloc/profile_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../../utils/utils.dart';
import 'dashboard_view_test.mocks.dart';

@GenerateMocks([
  AuthenticationBloc,
  SetActiveBottomNavigationUsecase,
  GetActiveBottomNavigationUsecase,
  GetDashboardUsecase,
  ProfileBloc
])
void main() {
  late MockAuthenticationBloc mockAuthenticationBloc;
  late MockProfileBloc mockProfileBloc;
  late MockSetActiveBottomNavigationUsecase mockSetActiveBottomNavigationUsecase;
  late MockGetActiveBottomNavigationUsecase mockGetActiveBottomNavigationUsecase;
  late MockGetDashboardUsecase mockGetDashboardUsecase;
  late DashboardBloc dashboardBloc;
  late MainBloc mainBloc;
  late Widget testWidget;

  setUp(() {
    mockAuthenticationBloc = MockAuthenticationBloc();
    mockProfileBloc = MockProfileBloc();
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
      profileBloc: mockProfileBloc,
      dashboardBloc: dashboardBloc, 
      mainBloc: mainBloc
    );
  });

  testWidgets("Should display initial dashboard page properly", (WidgetTester tester) async {
    when(mockAuthenticationBloc.state).thenReturn(Authenticated());
    when(mockAuthenticationBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockProfileBloc.state).thenReturn(const ProfileInit());
    when(mockProfileBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockGetActiveBottomNavigationUsecase(any)).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return Right(DashboardEntity(fullname: "fulan", photoUrl: "https://via.placeholder.com/60x60/F24B59/F24B59?text=.", progress: 8, upcoming: 23, completed: 2, activities: Utils().activityEntity));
    });

    await tester.runAsync(() async {
      await mockNetworkImagesFor(() => tester.pumpWidget(testWidget));
      await tester.pump();

      expect(find.text("-"), findsOneWidget);
      expect(find.text("You have no task right now"), findsOneWidget);
      expect(tester.widgetList<Text>(find.text("0")).length, 2);
      expect(tester.widgetList<Text>(find.text("0%")).length, 1);
    });

  });

  testWidgets("Should display loading modal properly", (WidgetTester tester) async {
    when(mockAuthenticationBloc.state).thenReturn(Authenticated());
    when(mockAuthenticationBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockProfileBloc.state).thenReturn(const ProfileInit());
    when(mockProfileBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockGetActiveBottomNavigationUsecase(any)).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return Right(DashboardEntity(fullname: "fulan", photoUrl: "https://via.placeholder.com/60x60/F24B59/F24B59?text=.", progress: 8, upcoming: 23, completed: 2, activities: Utils().activityEntity));
    });

    await tester.runAsync(() async {
      await mockNetworkImagesFor(() => tester.pumpWidget(testWidget));
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
    when(mockProfileBloc.state).thenReturn(const ProfileInit());
    when(mockProfileBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockGetActiveBottomNavigationUsecase(any)).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return Right(DashboardEntity(fullname: "fulan", photoUrl: "https://via.placeholder.com/60x60/F24B59/F24B59?text=.", progress: 8, upcoming: 23, completed: 2, activities: Utils().activityEntity));
    });

    await tester.runAsync(() async {
      await mockNetworkImagesFor(() => tester.pumpWidget(testWidget));
      await tester.pump();
      await tester.pump();

      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 4));
      await tester.pump();
      expect(find.text("Loading..."), findsNothing);
      
      expect(find.text("You have 23 tasks right now"), findsOneWidget);
      expect(find.text("8%"), findsOneWidget);
    });

  });

  testWidgets("Should display error modal when get dashboard is failed", (WidgetTester tester) async {
    when(mockAuthenticationBloc.state).thenReturn(Authenticated());
    when(mockAuthenticationBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockProfileBloc.state).thenReturn(const ProfileInit());
    when(mockProfileBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockGetActiveBottomNavigationUsecase(any)).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Left(ServerFailure(message: Failure.generalError));
    });

    await tester.runAsync(() async {
      await mockNetworkImagesFor(() => tester.pumpWidget(testWidget));
      await tester.pump();
      await tester.pump();

      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 4));
      await tester.pump();
      expect(find.text("Loading..."), findsNothing);

      expect(find.text(Failure.generalError), findsOneWidget);
    });

  });

  testWidgets("Should display error modal when get dashboard is failed", (WidgetTester tester) async {
    when(mockAuthenticationBloc.state).thenReturn(Authenticated());
    when(mockAuthenticationBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockProfileBloc.state).thenReturn(const ProfileInit());
    when(mockProfileBloc.stream).thenAnswer((_) => Stream.fromIterable([]));
    when(mockGetActiveBottomNavigationUsecase(any)).thenAnswer((_) async => const Right(BottomNavigationEntity(currentPage: BottomNavigation.home)));
    when(mockGetDashboardUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Left(ServerFailure(message: Failure.generalError));
    });

    await tester.runAsync(() async {
      await mockNetworkImagesFor(() => tester.pumpWidget(testWidget));
      await tester.pump();
      await tester.pump();

      expect(find.text("Loading..."), findsOneWidget);
      await Future.delayed(const Duration(seconds: 4));
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
  required ProfileBloc profileBloc,
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
      ),
      BlocProvider<ProfileBloc>(
        create: (_) => profileBloc
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