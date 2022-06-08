import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/assets/images/images.dart';
import 'package:crosscheck/core/widgets/loading_modal/loading_modal.dart';
import 'package:crosscheck/core/widgets/message_modal/message_modal.dart';
import 'package:crosscheck/core/widgets/styles/text_styles.dart';
import 'package:crosscheck/core/widgets/text_field/text_field.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/view_models/authentication_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/view_models/authentication_event.dart';
import 'package:crosscheck/features/authentication/presentation/login/view_models/login_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/login/view_models/login_event.dart';
import 'package:crosscheck/features/authentication/presentation/login/view_models/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  static String routeName = "login";

  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

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
        const Center(
          child: Text(
            "Welcome back!",
            style: TextStyles.poppinsBold22,
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
                  primary: CustomColors.primary
                ),
                onPressed: () {
                  context.read<LoginBloc>().add(LoginSubmit());
                },
                child: const Text(
                  "Sign in",
                  style: TextStyles.poppinsMedium18,
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
                style: TextStyles.poppinsMedium14.copyWith(
                  color: CustomColors.primary
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
      body: SafeArea(
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is! LoginSuccess) return;

            context.read<AuthenticationBloc>().add(AuthenticationSetToken(token: state.token));
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
                                  style: TextStyles.poppinsMedium12.copyWith(
                                    color: CustomColors.secondary
                                  )
                                ),
                                TextButton(
                                  key: const Key("signUpTextButton"),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    elevation: 0,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    "Sign up",
                                    style: TextStyles.poppinsMedium12.copyWith(
                                      color: CustomColors.primary
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