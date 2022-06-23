import 'package:crosscheck/assets/images/images.dart';
import 'package:crosscheck/core/widgets/loading_modal/loading_modal.dart';
import 'package:crosscheck/core/widgets/message_modal/message_modal.dart';
import 'package:crosscheck/core/widgets/text_field/text_field.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_event.dart';
import 'package:crosscheck/features/authentication/presentation/login/bloc/login_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/login/bloc/login_event.dart';
import 'package:crosscheck/features/authentication/presentation/login/bloc/login_state.dart';
import 'package:crosscheck/features/authentication/presentation/registration/views/registration_view.dart';
import 'package:crosscheck/features/main/presentation/view/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  static String routeName = "login";

  const LoginView({Key? key}) : super(key: key);

  Widget buildFields(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children : [
        const Center(
          child: Image(
            key: Key("logo"),
            fit: BoxFit.contain,
            repeat: ImageRepeat.noRepeat,
            image: AssetImage(Images.logo),
          ),
        ),
        const SizedBox(height: 32),
        Center(
          child: Text(
            "Welcome back!",
            key: const Key("textWelcomeBack"),
            style: Theme.of(context).textTheme.headline1?.copyWith(
              color: Theme.of(context).colorScheme.onBackground
            ),
          ),
        ),
        const SizedBox(height: 48),
        BorderedTextField(
          key: const Key("usernameField"),
          hintText: "Full Name", 
          onChanged: (value) {
            context.read<LoginBloc>().add(LoginSetUsername(username: value));
          }
        ),
        const SizedBox(height: 16),
        BorderedTextField(
          key: const Key("passwordField"),
          hintText: "Password",
          obscureText: true,
          onChanged: (value) {
            context.read<LoginBloc>().add(LoginSetPassword(password: value));
          }
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                key: const Key("submitButton"),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.all(16),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  primary: Theme.of(context).colorScheme.primary
                ),
                onPressed: () {
                  context.read<LoginBloc>().add(LoginSubmit());
                },
                child: Text(
                  "Sign in",
                  key: const Key("textSignIn"),
                  style: Theme.of(context).textTheme.button?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary
                  ),
                )
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              key: const Key("forgotPasswordTextButton"),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                elevation: 0,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap
              ),
              onPressed: () {},
              child: Text(
                "Forgot Password?",
                key: const Key("textForgotPassword"),
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color: Theme.of(context).colorScheme.primary
                ),
              )
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets padding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is! LoginSuccess) return;

            context.read<AuthenticationBloc>().add(AuthenticationSetToken(token: state.token));
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const MainView(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero
              )
            );
          },
          builder: (context, state) {
            return LoadingModal(
              isLoading: state is LoginLoading,
              child: MessageModal(
                status: MessageModalStatus.error,
                message: state is LoginGeneralError ? state.message : null,
                onDismissed: () {
                  context.read<LoginBloc>().add(LoginResetGeneralError());
                },
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    constraints: BoxConstraints(
                      minHeight: (size.height - padding.top),
                      minWidth:  size.width,
                      maxWidth:  size.width
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(height: 32),
                        buildFields(context),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  key: const Key("textDontHaveAnAccount"),
                                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                    color: Theme.of(context).colorScheme.onBackground
                                  ),
                                ),
                                TextButton(
                                  key: const Key("signUpTextButton"),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    elevation: 0,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context, RegistrationView.routeName);
                                  },
                                  child: Text(
                                    "Sign up",
                                    key: const Key("textSignUp"),
                                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                      color: Theme.of(context).colorScheme.primary
                                    ),
                                  )
                                )
                              ],
                            ),
                            const SizedBox(height: 16)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        )
      )
    );
  }
}