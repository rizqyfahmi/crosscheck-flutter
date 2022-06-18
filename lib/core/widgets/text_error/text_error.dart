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
        style: Theme.of(context).textTheme.bodyText2?.copyWith(
          color: Theme.of(context).colorScheme.primary
        ),
      ),
    );

  }
}