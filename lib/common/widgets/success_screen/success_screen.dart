import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:voice/common/styles/spacing_styles.dart';
import 'package:voice/utils/constants/sizes.dart';
import 'package:voice/utils/constants/text_strings.dart';
import 'package:voice/utils/device/device_utility.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
    this.isLottie = false,
    this.onPressed,
  });
  final String image, title, subTitle;
  final VoidCallback? onPressed;
  final bool isLottie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Padding(
          padding: TSpacingStyles.paddingWithAppBarHieght * 2,
          child: Column(
            children: [
              const SizedBox(height: TSizes.spaceBtwSections),
              //Image
              isLottie
                  ? Lottie.asset(image)
                  : Image(
                    width: TDeviceUtils.getScreenWidth(context) * 0.6,
                    image: AssetImage(image),
                  ),
              const SizedBox(height: TSizes.spaceBtwSections),
              //Title and subtitle
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                subTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              //Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPressed,
                  child: Text(
                    TTexts.tContinue,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium!.apply(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
