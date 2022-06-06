import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/core/widgets/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingModal extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingModal({
    Key? key,
    this.isLoading = false,
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return child;
    }

    return Stack (
      children: [
        child,
        Positioned(
          child: Container(
            color: Colors.black.withOpacity(0.5),
          )
        ),
        Center(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12))
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(
                  height: 48,
                  width: 48,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballPulseSync,
                    colors: [CustomColors.primary],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Loading...",
                  key: Key("loadingText"),
                  style: TextStyles.poppinsMedium14,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}