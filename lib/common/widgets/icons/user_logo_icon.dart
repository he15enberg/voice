import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:voice/utils/constants/colors.dart';
import 'package:voice/utils/helpers/helper_functions.dart';

class TUserLogoIcon extends StatelessWidget {
  const TUserLogoIcon({super.key, this.isShowSmall = false});
  final bool? isShowSmall;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Container(
      padding: EdgeInsets.all(isShowSmall! ? 2 : 3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? TColors.white : TColors.black,
      ),
      child: Icon(
        Iconsax.user_octagon,
        size: isShowSmall! ? 25 : 30,
        color: !isDark ? TColors.white : TColors.black,
      ),
    );
  }
}
