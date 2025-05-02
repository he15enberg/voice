import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voice/features/authentication/controllers/signup_contoller.dart';
import 'package:voice/utils/constants/colors.dart';
import 'package:voice/utils/constants/sizes.dart';
import 'package:voice/utils/constants/text_strings.dart';
import 'package:voice/utils/helpers/helper_functions.dart';

class TTermsAndConditionsCheckBox extends StatelessWidget {
  const TTermsAndConditionsCheckBox({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = SignUpController.instance;
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Obx(
            () => Checkbox(
              value: controller.privacyPolicy.value,
              onChanged: (value) {
                controller.privacyPolicy.value =
                    !controller.privacyPolicy.value;
              },
            ),
          ),
        ),
        const SizedBox(width: TSizes.spaceBtwItems),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "${TTexts.iAgreeTo} ",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextSpan(
                  text: TTexts.privacyPolicy,
                  style: Theme.of(context).textTheme.bodySmall!.apply(
                    color: dark ? TColors.white : TColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: dark ? TColors.white : TColors.primary,
                  ),
                ),
                TextSpan(
                  text: " ${TTexts.and} ",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextSpan(
                  text: TTexts.termsOfUse,
                  style: Theme.of(context).textTheme.bodySmall!.apply(
                    color: dark ? TColors.white : TColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: dark ? TColors.white : TColors.primary,
                  ),
                ),
              ],
            ),
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
