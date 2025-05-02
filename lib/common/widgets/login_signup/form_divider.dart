import 'package:flutter/material.dart';
import 'package:voice/utils/constants/colors.dart';
import 'package:voice/utils/helpers/helper_functions.dart';

class TFormDivider extends StatelessWidget {
  const TFormDivider({super.key, required this.dividerText});
  final String dividerText;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Row(
      children: [
        Flexible(
          child: Divider(
            color: dark ? TColors.darkGrey : TColors.grey,
            thickness: 0.5,
            indent: 60.0,
            endIndent: 5.0,
          ),
        ),
        Text(dividerText, style: Theme.of(context).textTheme.labelMedium),
        Flexible(
          child: Divider(
            color: dark ? TColors.darkGrey : TColors.grey,
            thickness: 0.5,
            indent: 5.0,
            endIndent: 60.0,
          ),
        ),
      ],
    );
  }
}
