import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:voice/utils/constants/colors.dart';
import 'package:voice/utils/helpers/helper_functions.dart';

class TNotificationIcon extends StatelessWidget {
  const TNotificationIcon({
    super.key,
    this.iconColor,
    required this.onPressed,
    required this.alertCount,
  });
  final Color? iconColor;
  final int alertCount;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Stack(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            Iconsax.notification_bing,
            color: iconColor ?? (dark ? TColors.white : TColors.black),
          ),
        ),
        Positioned(
          right: 0.0,
          child: Container(
            width: 18.0,
            height: 18.0,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: Center(
              child: Text(
                alertCount.toString(),
                style: Theme.of(context).textTheme.labelLarge!.apply(
                  color: TColors.white,
                  fontSizeFactor: 0.85,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
