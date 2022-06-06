import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/assets/images/images.dart';
import 'package:crosscheck/core/widgets/loading_modal/loading_modal.dart';
import 'package:crosscheck/core/widgets/message_modal/message_modal.dart';
import 'package:crosscheck/core/widgets/styles/text_styles.dart';
import 'package:crosscheck/core/widgets/text_error/text_error.dart';
import 'package:crosscheck/core/widgets/text_field/text_field.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/view_models/authentication_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/view_models/authentication_event.dart';
import 'package:crosscheck/features/authentication/presentation/registration/view_models/registration_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/registration/view_models/registration_event.dart';
import 'package:crosscheck/features/authentication/presentation/registration/view_models/registration_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({Key? key}) : super(key: key);

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {

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
      const double bufferHeight = 200; // it's used for error validation massage

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
            "Create your account",
            style: TextStyles.poppinsBold22,
          ),
        ),
        const SizedBox(height: 48),
        BorderedTextField(
          key: const Key("nameField"),
          hintText: "Full Name", 
          onChanged: (value) {
            context.read<RegistrationBloc>().add(RegistrationSetName(value));
          }
        ),
        BlocBuilder<RegistrationBloc, RegistrationState>(
          builder: (context, state) => TextError(state.model.errorName)
        ),
        const SizedBox(height: 16),
        BorderedTextField(
          key: const Key("emailField"),
          hintText: "Email Address", 
          onChanged: (value) {
            context.read<RegistrationBloc>().add(RegistrationSetEmail(value));
          }
        ),
        BlocBuilder<RegistrationBloc, RegistrationState>(
          builder: (context, state) => TextError(state.model.errorEmail)
        ),
        const SizedBox(height: 16),
        BorderedTextField(
          key: const Key("passwordField"),
          hintText: "Password",
          obscureText: true,
          onChanged: (value) {
            context.read<RegistrationBloc>().add(RegistrationSetPassword(value));
          }
        ),
        BlocBuilder<RegistrationBloc, RegistrationState>(
          builder: (context, state) => TextError(state.model.errorPassword)
        ),
        const SizedBox(height: 16),
        BorderedTextField(
          key: const Key("confirmPasswordField"),
          hintText: "Confirm Password",
          obscureText: true,
          onChanged: (value) {
            context.read<RegistrationBloc>().add(RegistrationSetConfirmPassword(value));
          }
        ),
        BlocBuilder<RegistrationBloc, RegistrationState>(
          builder: (context, state) => TextError(state.model.errorConfirmPassword)
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
                  context.read<RegistrationBloc>().add(RegistrationSubmit());
                },
                child: const Text(
                  "Create an account",
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
            Text(
              "Already have an account? ",
              style: TextStyles.poppinsMedium14.copyWith(
                color: CustomColors.secondary
              ),
            ),
            TextButton(
              key: const Key("signInTextButton"),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                elevation: 0,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap
              ),
              onPressed: () {},
              child: Text(
                "Sign In",
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
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "By creating and/or using an account, you agree",
                style: TextStyles.poppinsMedium12.copyWith(
                  color: CustomColors.secondary
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "to our ",
                    style: TextStyles.poppinsMedium12.copyWith(
                      color: CustomColors.secondary
                    ),
                  ),
                  TextButton(
                    key: const Key("tncTextButton"),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      elevation: 0,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap
                    ),
                    onPressed: () {},
                    child: Text(
                      "Term & Conditions.",
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<RegistrationBloc, RegistrationState>(
          listener: (context, state) {
            if (state is! RegistrationSuccess) return;

            context.read<AuthenticationBloc>().add(AuthenticationSetToken(token: state.token));
          },
          builder: (context, state) {
            return LoadingModal(
              isLoading: state is RegistrationLoading,
              child: MessageModal(
                status: MessageModalStatus.error,
                message: state is RegistrationGeneralError ? state.message : null,
                onDismissed: () {
                  context.read<RegistrationBloc>().add(RegistrationResetGeneralError());
                },
                child: Opacity(
                  opacity: opacity,
                  child: LayoutBuilder(builder: (context, constraints) {
                    if (height > 0) {
                      return SingleChildScrollView(
                        child: SizedBox(
                          height: height,
                          child: buildForm(context),
                        ),
                      );
                    }
              
                    return buildForm(context);
                  }),
                ),
              )
            );
          }
        )
      ),
    );
  }
}