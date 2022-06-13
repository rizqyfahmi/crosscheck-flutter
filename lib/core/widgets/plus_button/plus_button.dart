import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/assets/icons/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PlusButton extends StatefulWidget {
  const PlusButton({Key? key}) : super(key: key);

  @override
  State<PlusButton> createState() => _PlusButtonState();
}

class _PlusButtonState extends State<PlusButton> {

  List<BoxShadow> boxShadow = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      boxShadow = getBoxShadow();
    });
  }

  List<BoxShadow> getBoxShadow() {
    return [
      BoxShadow(
        offset: const Offset(0, 4),
        color: Colors.black.withOpacity(0.2),
        blurRadius: 0.4
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          boxShadow = [];
        });
      },
      onTapUp: (_) {
        setState(() {
          boxShadow = getBoxShadow();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.primary,
          borderRadius: BorderRadius.circular(48),
          boxShadow: boxShadow
        ),
        child: SvgPicture.asset(
          CustomIcons.plus,
          color: Colors.white,
        ),
      ),              
    );
  }
}