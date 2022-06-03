import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/core/widgets/styles/text_styles.dart';
import 'package:flutter/material.dart';

class BorderedTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final ValueSetter<String> onChanged;

  const BorderedTextField({
    Key? key,
    required this.hintText,
    this.obscureText = false,
    required this.onChanged
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.all(16),
        hintText: hintText,
        hintStyle: TextStyles.poppinsRegular14.copyWith(
          color: CustomColors.placeholderText
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: CustomColors.ternary),
          borderRadius: BorderRadius.circular(12)
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: CustomColors.borderField),
          borderRadius: BorderRadius.circular(12)
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: CustomColors.borderField),
          borderRadius: BorderRadius.circular(12)
        )
      ),
      onChanged: onChanged,
    );
  }
}