import 'package:crosscheck/core/locator/locator.dart' as di;
import 'package:crosscheck/features/authentication/presentation/authentication/view_models/authentication_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/registration/view_models/registration_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/registration/views/registration_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (_) => di.locator<AuthenticationBloc>()
        ),
        BlocProvider<RegistrationBloc>(
          create: (_) => di.locator<RegistrationBloc>()
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: const RegistrationView(),
      ),
    );
  }
}
