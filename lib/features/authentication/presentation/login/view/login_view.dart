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

  GlobalKey formKey = GlobalKey();
  double height = 0;
  double opacity = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      MediaQueryData mediaQuery = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
      final double statusBar = mediaQuery.padding.top;
      final double screenHeight = mediaQuery.size.height - statusBar;
      const double bufferHeight = 100; // it's used for error validation massage

      final RenderBox box = formKey.currentContext?.findRenderObject() as RenderBox;
      final double contentHeight = box.size.height + bufferHeight;

      if (height > 0) return;

      setState(() {
        height = contentHeight > screenHeight ? contentHeight : screenHeight;
      });
      
      // Change state of opacity separately from height to avoid glitch when load the registration form
      setState(() {
        opacity = 1;
      });
    });
  }

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

  Widget buildForm(BuildContext context) {
    Widget fields = buildFields(context);

    if (height > 0) {
      fields = Expanded(
        child: buildFields(context),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        key: formKey,
        mainAxisSize: MainAxisSize.min,
        children: [
          fields,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                child: Opacity(
                  opacity: opacity,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (height > 0) {
                        return SingleChildScrollView(
                          child: SizedBox(
                            height: height,
                            child: buildForm(context),
                          ),
                        );
                      }
                        
                      return buildForm(context);
                    },
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