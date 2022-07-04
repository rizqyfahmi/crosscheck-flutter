import 'dart:ui';

import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/assets/icons/custom_icons.dart';
import 'package:crosscheck/core/widgets/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_indicator/loading_indicator.dart';

Future showLoadingDialog({
  required BuildContext context
}) async {
  return await showDialog(
    barrierDismissible: false,
    useSafeArea: false,
    context: context,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Center(
          child: Container(
            key: const Key("loadingIndicator"),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12))
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 48,
                  width: 48,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballPulseSync,
                    colors: [CustomColors.primary],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Loading...",
                  key: const Key("loadingText"),
                  style: TextStyles.poppinsMedium14.copyWith(
                    color: CustomColors.secondary
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  );
}

enum ResponseDialogStatus {
  success, error
}

Future showResponseDialog({
  required BuildContext context,
  required ResponseDialogStatus status,
  String? title,
  String? message
}) async {
  final tempTitle = title ?? (status == ResponseDialogStatus.error ? "Error!" : "Congratulations!");
  final color = status == ResponseDialogStatus.error ? CustomColors.primary : CustomColors.success;
  final icon = status == ResponseDialogStatus.error ? CustomIcons.cross : CustomIcons.check;

  return await showDialog(
    barrierDismissible: false,
    useRootNavigator: false,
    context: context,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                      children: [
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, contraints) {
                              final size = contraints.maxWidth / 1.5;
                              return Stack(
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: size / 2,
                                        width: size
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              key: const Key("responseDialog"),
                                              clipBehavior: Clip.antiAlias,
                                              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(Radius.circular(12))
                                              ),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    top: -(size / 2),
                                                    left: 0,
                                                    right: 0,
                                                    child: Center(
                                                      child: Container(
                                                        height: size,
                                                        width: size,
                                                        padding: const EdgeInsets.all(16),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: color.withOpacity(0.2)
                                                        ),
                                                        child: Container(
                                                          height: size,
                                                          width: size,
                                                          padding: const EdgeInsets.all(16),
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: color.withOpacity(0.2)
                                                          ),
                                                          child: Container(
                                                            height: size,
                                                            width: size,
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: color.withOpacity(0.2)
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        SizedBox(
                                                          height: size / 2,
                                                          width: size
                                                        ),
                                                        const SizedBox(height: 32),
                                                        Text(
                                                          tempTitle,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyles.poppinsBold18.copyWith(
                                                            color: CustomColors.tertiary
                                                          )
                                                        ),
                                                        const SizedBox(height: 16),
                                                        Text(
                                                          message ?? "",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyles.poppinsMedium14.copyWith(
                                                            color: CustomColors.secondary
                                                          )
                                                        ),
                                                        const SizedBox(height: 32),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: ElevatedButton(
                                                                key: const Key("dismissButton"),
                                                                onPressed: () {
                                                                  Navigator.of(context, rootNavigator: true).pop();
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                  elevation: 0,
                                                                  minimumSize: Size.zero,
                                                                  padding: const EdgeInsets.all(16),
                                                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(100),
                                                                    side: BorderSide(
                                                                      color: color
                                                                    )
                                                                  ),
                                                                  primary: Colors.transparent,
                                                                  onPrimary: color
                                                                ),
                                                                child: Text(
                                                                  "Got it",
                                                                  style: TextStyles.poppinsMedium14.copyWith(
                                                                    color: color
                                                                  ),
                                                                )
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: Container(
                                        height: size,
                                        width: size,
                                        padding: const EdgeInsets.all(16),
                                        child: Container(
                                          height: size,
                                          width: size,
                                          padding: const EdgeInsets.all(16),
                                          child: Container(
                                            height: size,
                                            width: size,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: color
                                            ),
                                            child: SvgPicture.asset(icon),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 16,
                            margin: const EdgeInsets.symmetric(horizontal: 48),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12), 
                                bottomRight: Radius.circular(12)
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  );
}