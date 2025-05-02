import 'package:flutter/material.dart';
import 'package:voice/features/authentication/controllers/onboarding_controller.dart';
import 'package:voice/utils/constants/colors.dart';
import 'package:voice/utils/constants/sizes.dart';
import 'package:voice/utils/device/device_utility.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: TDeviceUtils.getAppBarHeight(),
      right: TSizes.defaultSpace,
      child: TextButton(
        onPressed: () => OnBoardingController.instance.skipPage(),
        child: Text(
          "Skip",
          style: Theme.of(context).textTheme.bodyMedium!.apply(
            color: TColors.primary,
            fontSizeFactor: 1.5,
          ),
        ),
      ),
    );
  }
}
