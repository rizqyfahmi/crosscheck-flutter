import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/features/profile/domain/entities/profile_entity.dart';
import 'package:crosscheck/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:crosscheck/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:crosscheck/features/profile/presentation/bloc/profile_event.dart';
import 'package:crosscheck/features/settings/domain/usecase/get_theme_usecase.dart';
import 'package:crosscheck/features/settings/domain/usecase/set_theme_usecase.dart';
import 'package:crosscheck/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:crosscheck/features/settings/presentation/view/settings_view.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'profile_settings_section_test.mocks.dart';

@GenerateMocks([
  GetProfileUsecase,
  SetThemeUsecase,
  GetThemeUsecase
])
void main() {
  late MockGetProfileUsecase mockGetProfileUsecase;
  late MockSetThemeUsecase mockSetThemeUsecase;
  late MockGetThemeUsecase mockGetThemeUsecase;
  late ProfileBloc profileBloc;
  late SettingsBloc settingsBloc;
  late Widget testWidget;

  setUp(() {
    mockGetProfileUsecase = MockGetProfileUsecase();
    mockSetThemeUsecase = MockSetThemeUsecase();
    mockGetThemeUsecase = MockGetThemeUsecase();
    profileBloc = ProfileBloc(getProfileUsecase: mockGetProfileUsecase);
    settingsBloc = SettingsBloc(setThemeUsecase: mockSetThemeUsecase, getThemeUsecase: mockGetThemeUsecase);
    testWidget = buildWidget(
      profileBloc: profileBloc,
      settingsBloc: settingsBloc
    );
  });

  testWidgets('Should properly display profile section in settings view', (WidgetTester tester) async {
    final entity = ProfileEntity(id: "123", fullname: "fulan", email: "fulan@email.com", dob: DateTime.parse("1991-01-11"), address: "Indonesia", photoUrl: "https://via.placeholder.com/60x60");
    when(mockGetProfileUsecase(NoParam())).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      return Right(entity);
    });

    await tester.runAsync(() async {
      await mockNetworkImagesFor(() => tester.pumpWidget(testWidget));
      
      expect(find.byKey(const Key("loadingIndicator")), findsNothing);
      
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump();

      expect(find.byKey(const Key("loadingIndicator")), findsOneWidget);
      
      await Future.delayed(const Duration(seconds: 1));
      await tester.pump();
      expect(find.byKey(const Key("loadingIndicator")), findsNothing);

      await tester.ensureVisible(find.byKey(const Key("imageProfile")));
      await tester.pumpAndSettle();
      Image imageProfile = tester.widget(find.byKey(const Key("imageProfile")));
      expect((imageProfile.image as NetworkImage).url, "https://via.placeholder.com/60x60");
      
      await tester.ensureVisible(find.byKey(const Key("textProfileFullName")));
      await tester.pumpAndSettle();
      Text textProfileFullName = tester.widget(find.byKey(const Key("textProfileFullName")));
      expect(textProfileFullName.data, "fulan");
      
      await tester.ensureVisible(find.byKey(const Key("textProfileEmail")));
      await tester.pumpAndSettle();
      Text textProfileEmail = tester.widget(find.byKey(const Key("textProfileEmail")));
      expect(textProfileEmail.data, "fulan@email.com");

      await tester.ensureVisible(find.byKey(const Key("textFullName")));
      await tester.pumpAndSettle();
      Text textFullName = tester.widget(find.byKey(const Key("textFullName")));
      expect(textFullName.data, "fulan");

      await tester.ensureVisible(find.byKey(const Key("textEmailAddress")));
      await tester.pumpAndSettle();
      Text textEmailAddress = tester.widget(find.byKey(const Key("textEmailAddress")));
      expect(textEmailAddress.data, "fulan@email.com");

      await tester.ensureVisible(find.byKey(const Key("textDOB")));
      await tester.pumpAndSettle();
      Text textDOB = tester.widget(find.byKey(const Key("textDOB")));
      expect(textDOB.data, "11-01-1991");

      await tester.ensureVisible(find.byKey(const Key("textAddress")));
      await tester.pumpAndSettle();
      Text textAddress = tester.widget(find.byKey(const Key("textAddress")));
      expect(textAddress.data, "Indonesia");
    });
    
  });

  testWidgets("Should display general error modal when get profile returns serverFailure", (WidgetTester tester) async {
    when(mockGetProfileUsecase(NoParam())).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      return const Left(ServerFailure(message: Failure.generalError));
    });

    await tester.runAsync(() async {
      await mockNetworkImagesFor(() => tester.pumpWidget(testWidget));

      expect(find.byKey(const Key("loadingIndicator")), findsNothing);

      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump();

      expect(find.byKey(const Key("loadingIndicator")), findsOneWidget);
      
      await Future.delayed(const Duration(seconds: 1));
      await tester.pump();
      expect(find.byKey(const Key("loadingIndicator")), findsNothing);
      expect(find.byKey(const Key("responseDialog")), findsOneWidget);

      await tester.ensureVisible(find.byKey(const Key("dismissButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("dismissButton")));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key("responseDialog")), findsNothing);

      await tester.ensureVisible(find.byKey(const Key("imageProfile")));
      await tester.pumpAndSettle();
      Image imageProfile = tester.widget(find.byKey(const Key("imageProfile")));
      expect((imageProfile.image as NetworkImage).url, "https://via.placeholder.com/60x60/F24B59/F24B59?text=.");
      
      await tester.ensureVisible(find.byKey(const Key("textProfileFullName")));
      await tester.pumpAndSettle();
      Text textProfileFullName = tester.widget(find.byKey(const Key("textProfileFullName")));
      expect(textProfileFullName.data, "-");
      
      await tester.ensureVisible(find.byKey(const Key("textProfileEmail")));
      await tester.pumpAndSettle();
      Text textProfileEmail = tester.widget(find.byKey(const Key("textProfileEmail")));
      expect(textProfileEmail.data, "-");

      await tester.ensureVisible(find.byKey(const Key("textFullName")));
      await tester.pumpAndSettle();
      Text textFullName = tester.widget(find.byKey(const Key("textFullName")));
      expect(textFullName.data, "-");

      await tester.ensureVisible(find.byKey(const Key("textEmailAddress")));
      await tester.pumpAndSettle();
      Text textEmailAddress = tester.widget(find.byKey(const Key("textEmailAddress")));
      expect(textEmailAddress.data, "-");

      await tester.ensureVisible(find.byKey(const Key("textDOB")));
      await tester.pumpAndSettle();
      Text textDOB = tester.widget(find.byKey(const Key("textDOB")));
      expect(textDOB.data, "-");

      await tester.ensureVisible(find.byKey(const Key("textAddress")));
      await tester.pumpAndSettle();
      Text textAddress = tester.widget(find.byKey(const Key("textAddress")));
      expect(textAddress.data, "-");
      
    });
  });

  testWidgets("Should display general error modal when get profile returns cacheFailure", (WidgetTester tester) async {
    when(mockGetProfileUsecase(NoParam())).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      return const Left(CacheFailure(message: Failure.cacheError));
    });

    await tester.runAsync(() async {
      await mockNetworkImagesFor(() => tester.pumpWidget(testWidget));
      expect(find.byKey(const Key("loadingIndicator")), findsNothing);

      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump();

      expect(find.byKey(const Key("loadingIndicator")), findsOneWidget);
      
      await Future.delayed(const Duration(seconds: 1));
      await tester.pump();
      expect(find.byKey(const Key("loadingIndicator")), findsNothing);
      expect(find.byKey(const Key("responseDialog")), findsOneWidget);

      await tester.ensureVisible(find.byKey(const Key("dismissButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("dismissButton")));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key("responseDialog")), findsNothing);

      await tester.ensureVisible(find.byKey(const Key("imageProfile")));
      await tester.pumpAndSettle();
      Image imageProfile = tester.widget(find.byKey(const Key("imageProfile")));
      expect((imageProfile.image as NetworkImage).url, "https://via.placeholder.com/60x60/F24B59/F24B59?text=.");
      
      await tester.ensureVisible(find.byKey(const Key("textProfileFullName")));
      await tester.pumpAndSettle();
      Text textProfileFullName = tester.widget(find.byKey(const Key("textProfileFullName")));
      expect(textProfileFullName.data, "-");
      
      await tester.ensureVisible(find.byKey(const Key("textProfileEmail")));
      await tester.pumpAndSettle();
      Text textProfileEmail = tester.widget(find.byKey(const Key("textProfileEmail")));
      expect(textProfileEmail.data, "-");

      await tester.ensureVisible(find.byKey(const Key("textFullName")));
      await tester.pumpAndSettle();
      Text textFullName = tester.widget(find.byKey(const Key("textFullName")));
      expect(textFullName.data, "-");

      await tester.ensureVisible(find.byKey(const Key("textEmailAddress")));
      await tester.pumpAndSettle();
      Text textEmailAddress = tester.widget(find.byKey(const Key("textEmailAddress")));
      expect(textEmailAddress.data, "-");

      await tester.ensureVisible(find.byKey(const Key("textDOB")));
      await tester.pumpAndSettle();
      Text textDOB = tester.widget(find.byKey(const Key("textDOB")));
      expect(textDOB.data, "-");

      await tester.ensureVisible(find.byKey(const Key("textAddress")));
      await tester.pumpAndSettle();
      Text textAddress = tester.widget(find.byKey(const Key("textAddress")));
      expect(textAddress.data, "-");
    });
  });
}

Widget buildWidget({
  required ProfileBloc profileBloc,
  required SettingsBloc settingsBloc
}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<SettingsBloc>(
          create: (_) => settingsBloc
      ),
      BlocProvider<ProfileBloc>(
          create: (_) => profileBloc..add(ProfileGetData())
      )
    ],
    child: MaterialApp(
      home: Builder(
        builder: (context) {
          return const Scaffold(
            body: SettingsView(),
          );
        }
      ),
    )
  );
}
