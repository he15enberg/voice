import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:voice/utils/constants/colors.dart';
import 'package:voice/utils/helpers/helper_functions.dart';

class TGroupChatIcon extends StatelessWidget {
  const TGroupChatIcon({super.key, this.isShowTrue = false});
  final bool? isShowTrue;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Container(
      padding: EdgeInsets.all(isShowTrue! ? 4 : 3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? TColors.white : TColors.black,
      ),
      child: Icon(
        Iconsax.voice_cricle,
        size: isShowTrue! ? 100 : 35,
        color: !isDark ? TColors.white : TColors.black,
      ),
    );
  }
}
