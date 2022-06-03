import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/core/widgets/styles/text_styles.dart';
import 'package:flutter/material.dart';

class TextError extends StatelessWidget {
  final String? data;
  
  const TextError(
    this.data,{
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    if (data == null || data == "") return Container();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        data ?? "",
        textAlign: TextAlign.left,
        style: TextStyles.poppinsRegular12.copyWith(
          color: CustomColors.primary,
        ),
      ),
    );

  }
}