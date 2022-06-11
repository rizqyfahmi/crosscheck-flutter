import 'package:crosscheck/core/locator/locator.dart' as di;
import 'package:crosscheck/features/authentication/presentation/authentication/view_models/authentication_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/login/view/login_view.dart';
import 'package:crosscheck/features/authentication/presentation/login/view_models/login_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/registration/view_models/registration_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/registration/views/registration_view.dart';
import 'package:crosscheck/features/walkthrough/presentation/view/walkthrough_view.dart';
import 'package:crosscheck/features/walkthrough/presentation/view_models/walkthrough_bloc.dart';
import 'package:crosscheck/features/walkthrough/presentation/view_models/walkthrough_event.dart';
import 'package:crosscheck/features/walkthrough/presentation/view_models/walkthrough_state.dart';
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
        ),
        BlocProvider<LoginBloc>(
          create: (_) => di.locator<LoginBloc>()
        ),
        BlocProvider<WalkthroughBloc>(
          create: (_) => di.locator<WalkthroughBloc>()..add(WalkthroughGetSkip())
        )
      ],
      child: MaterialApp(
        home: const MainPage(),
        routes: {
          WalkthroughView.routeName: (context) => const WalkthroughView(),
          RegistrationView.routeName: (context) => const RegistrationView(),
          LoginView.routeName: (context) => const LoginView()
        },
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  void navigate(BuildContext context, Widget destination) {
    Navigator.pushReplacement(
      context, 
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation)  => destination,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<WalkthroughBloc, WalkthroughState>(
        listener: (context, state) {
          if (state is WalkthroughLoadSkipFailed) {
            return navigate(context, const WalkthroughView());
          }

          if (state is WalkthroughLoadSkipSuccess) {
            return navigate(context, const LoginView());
          }

        },
        child: const Scaffold(),
      ),
    );
  }
}