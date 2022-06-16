import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/assets/icons/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CloudyCard extends StatelessWidget {
  final Widget child;

  const CloudyCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: CustomColors.borderField),
        borderRadius:  BorderRadius.circular(12)
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: Opacity(
              opacity: 0.12, child: SvgPicture.asset(CustomIcons.cloud)
            )
          ),
          Positioned(
            left: 16,
            top: 16,
            child: Opacity(
              opacity: 0.12, child: SvgPicture.asset(CustomIcons.cloudSmall)
            )
          ),
          child
        ],
      ),
    );
  }
}