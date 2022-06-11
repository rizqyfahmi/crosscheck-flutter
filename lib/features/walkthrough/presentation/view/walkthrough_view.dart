import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/assets/images/images.dart';
import 'package:crosscheck/core/widgets/styles/text_styles.dart';
import 'package:crosscheck/features/authentication/presentation/login/view/login_view.dart';
import 'package:crosscheck/features/walkthrough/presentation/view_models/walkthrough_bloc.dart';
import 'package:crosscheck/features/walkthrough/presentation/view_models/walkthrough_event.dart';
import 'package:crosscheck/features/walkthrough/presentation/view_models/walkthrough_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalkthroughView extends StatelessWidget {
  static String routeName = "walkthrough";

  const WalkthroughView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SafeArea(
                      bottom: false,
                      child: Row(
                        children: const [
                          Expanded(child: Image(image: AssetImage(Images.illustration)))
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: CustomColors.primary
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 1,
                              width: double.infinity,
                              decoration: const BoxDecoration(color: Colors.white),
                            ),
                            const Image(
                              key: Key("illustration"),
                              fit: BoxFit.contain,
                              image: AssetImage(Images.divider)
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Text(
                                "Welcome",
                                textAlign: TextAlign.center,
                                style: TextStyles.poppinsBold22
                                    .copyWith(color: Colors.white),
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
                                textAlign: TextAlign.center,
                                style: TextStyles.poppinsRegular14.copyWith(color: Colors.white),
                              ),
                              const SizedBox(height: 64),
                              Row(
                                children: [
                                  Expanded(
                                    key: const Key("getStartedButton"),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        context.read<WalkthroughBloc>().add(const WalkthroughSetSkip(isSkip: true));
                                      }, 
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        padding: const EdgeInsets.all(16),
                                        minimumSize: Size.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(100)
                                        ),
                                      ),
                                      child: Text(
                                        "Get started",
                                        style: TextStyles.poppinsMedium18.copyWith(
                                          color: CustomColors.primary
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