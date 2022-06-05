import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/assets/icons/crosscheck/crosscheck_icons.dart';
import 'package:crosscheck/core/widgets/styles/text_styles.dart';
import 'package:flutter/material.dart';

enum MessageModalStatus {
  success,
  error
}

class MessageModal extends StatefulWidget {
  final Widget child;
  final MessageModalStatus status;
  final String? title;
  final String? message;
  final VoidCallback? onDismissed;
  
  const MessageModal({
    Key? key,
    required this.status,
    required this.child,
    this.title,
    required this.message,
    this.onDismissed
  }) : super(key: key);

  @override
  State<MessageModal> createState() => _MessageModalState();
}

class _MessageModalState extends State<MessageModal> {
  late bool isShown;

  @override
  void didUpdateWidget(covariant MessageModal oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      isShown = (widget.message != null);
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      isShown = (widget.message != null);
    });
  }

  Widget buildTitle(BuildContext context) {
    final tempTitle = widget.title ?? (widget.status == MessageModalStatus.error ? "Error!" : "Congratulations!");

    return Column(
      children: [
        Text(
          tempTitle,
          textAlign: TextAlign.center,
          style: TextStyles.poppinsBold18.copyWith(
            color: CustomColors.ternary
          )
        ),
        const SizedBox(height: 16)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    final color = widget.status == MessageModalStatus.error ? CustomColors.primary : CustomColors.success;
    final icon = widget.status == MessageModalStatus.error ? Crosscheck.cross : Crosscheck.check;

    if (!isShown) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        Positioned(
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
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
                                                      buildTitle(context),
                                                      Text(
                                                        widget.message ?? "",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyles.poppinsMedium14
                                                      ),
                                                      const SizedBox(height: 32),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: ElevatedButton(
                                                              key: const Key("dismissButton"),
                                                              onPressed: () {
                                                                setState(() {
                                                                  isShown = false;
                                                                  if (widget.onDismissed != null) {
                                                                    widget.onDismissed!();
                                                                  }
                                                                });
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
                                          child: Icon(icon, color: Colors.white, size: 128),
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
        )
      ],
    );

  }
}