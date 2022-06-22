import 'package:crosscheck/core/utils/locator.dart' as di;
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/login/view/login_view.dart';
import 'package:crosscheck/features/authentication/presentation/login/bloc/login_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/registration/bloc/registration_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/registration/views/registration_view.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_bloc.dart';
import 'package:crosscheck/features/main/presentation/view/main_view.dart';
import 'package:crosscheck/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:crosscheck/features/settings/presentation/bloc/settings_event.dart';
import 'package:crosscheck/features/settings/presentation/bloc/settings_state.dart';
import 'package:crosscheck/features/walkthrough/presentation/view/walkthrough_view.dart';
import 'package:crosscheck/features/walkthrough/presentation/bloc/walkthrough_bloc.dart';
import 'package:crosscheck/features/walkthrough/presentation/bloc/walkthrough_event.dart';
import 'package:crosscheck/features/walkthrough/presentation/bloc/walkthrough_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  List<BlocProvider<StateStreamableSource<Object?>>> providers = [
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
    ),
    BlocProvider<MainBloc>(
      create: (_) => di.locator<MainBloc>()
    ),
    BlocProvider<DashboardBloc>(
      create: (_) => di.locator<DashboardBloc>()
    ),
    BlocProvider<SettingsBloc>(
      create: (_) => di.locator<SettingsBloc>()..add(SettingsLoad())
    )
  ];
  runApp(MyApp(providers: providers));
}

class MyApp extends StatelessWidget {

  final List<BlocProvider<StateStreamableSource<Object?>>> providers;

  const MyApp({Key? key, required this.providers}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: providers,
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            theme: state.model.themeData,
            home: const MainPage(),
            routes: {
              WalkthroughView.routeName: (context) => const WalkthroughView(),
              RegistrationView.routeName: (context) => const RegistrationView(),
              LoginView.routeName: (context) => const LoginView(),
              MainView.routeName: (context) => const MainView()
            },
          );
        }
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