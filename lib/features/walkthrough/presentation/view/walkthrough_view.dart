import 'package:crosscheck/assets/images/images.dart';
import 'package:crosscheck/features/authentication/presentation/login/view/login_view.dart';
import 'package:crosscheck/features/walkthrough/presentation/bloc/walkthrough_bloc.dart';
import 'package:crosscheck/features/walkthrough/presentation/bloc/walkthrough_event.dart';
import 'package:crosscheck/features/walkthrough/presentation/bloc/walkthrough_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalkthroughView extends StatelessWidget {
  static String routeName = "walkthrough";

  const WalkthroughView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocConsumer<WalkthroughBloc, WalkthroughState>(
        listener: (context, state) {
          if ((state is WalkthroughSkipSuccess) || (state is WalkthroughSkipFailed)) {
            Navigator.pushReplacement(
              context, 
              PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation)  => const LoginView(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero
              )
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SafeArea(
                      bottom: false,
                      child: Row(
                        children: const [
                          Expanded(
                            child: Image(
                              key: Key("illustration"),
                              image: AssetImage(Images.illustration)
                            )
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Positioned(
                              top: -1,
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.background
                                ),
                              ),
                            ),
                            const Image(
                              fit: BoxFit.contain,
                              image: AssetImage(Images.divider)
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Text(
                                "Welcome",
                                key: const Key("textWelcome"),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline1?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              const SizedBox(height: 32),
                              Text(
                                "Focus on your short and long-term habit to improve productivity and achieve your goals. Enjoy your way to better time management",
                                key: const Key("textWelcomeDescription"),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary
                                ),
                              ),
                              const SizedBox(height: 64),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      key: const Key("getStartedButton"),
                                      onPressed: () async {
                                        context.read<WalkthroughBloc>().add(const WalkthroughSetSkip(isSkip: true));
                                      }, 
                                      style: ElevatedButton.styleFrom(
                                        primary: Theme.of(context).colorScheme.background,
                                        padding: const EdgeInsets.all(16),
                                        minimumSize: Size.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(100)
                                        ),
                                      ),
                                      child: Text(
                                        "Get started",
                                        key: const Key("textGetStarted"),
                                        style: Theme.of(context).textTheme.button?.copyWith(
                                          color: Theme.of(context).colorScheme.primary
                                        ),
                                      )
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}