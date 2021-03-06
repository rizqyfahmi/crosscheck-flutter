import 'package:crosscheck/assets/images/images.dart';
import 'package:crosscheck/core/widgets/loading_modal/loading_modal.dart';
import 'package:crosscheck/core/widgets/message_modal/message_modal.dart';
import 'package:crosscheck/core/widgets/styles/text_styles.dart';
import 'package:crosscheck/core/widgets/text_error/text_error.dart';
import 'package:crosscheck/core/widgets/text_field/text_field.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_event.dart';
import 'package:crosscheck/features/authentication/presentation/registration/bloc/registration_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/registration/bloc/registration_event.dart';
import 'package:crosscheck/features/authentication/presentation/registration/bloc/registration_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationView extends StatelessWidget {
  static String routeName = "registration";

  const RegistrationView({Key? key}) : super(key: key);

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
            "Create your account",
            key: const Key("textCreateYourAccount"),
            style: Theme.of(context).textTheme.headline1?.copyWith(
              color: Theme.of(context).colorScheme.onBackground
            ),
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
                  primary: Theme.of(context).colorScheme.primary
                ),
                onPressed: () {
                  context.read<RegistrationBloc>().add(RegistrationSubmit());
                },
                child: Text(
                  "Create an account",
                  key: const Key("textCreateAnAccount"),
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
            Text(
              "Already have an account? ",
              key: const Key("textAlreadyHaveAnAccount"),
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: Theme.of(context).colorScheme.onBackground
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
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Sign In",
                key: const Key("textSignIn"),
                style: TextStyles.poppinsMedium14.copyWith(
                  color: Theme.of(context).colorScheme.primary
                ),
              )
            )
          ],
        ),
        const SizedBox(height: 32),
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
        child: BlocConsumer<RegistrationBloc, RegistrationState>(
          listener: (context, state) {
            if (state is! RegistrationSuccess) return;

            context.read<AuthenticationBloc>().add(AuthenticationSetAuthenticated());
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
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              "By creating and/or using an account, you agree",
                              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                color: Theme.of(context).colorScheme.onBackground
                              )
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "to our ",
                                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                    color: Theme.of(context).colorScheme.onBackground
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
                                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                      color: Theme.of(context).colorScheme.primary
                                    ),
                                  )
                                )
                              ],
                            ),
                            const SizedBox(height: 16)
                          ],
                        ),
                      ],
                    )
                  ),
                ),
              )
            );
          }
        )
      ),
    );
  }
}