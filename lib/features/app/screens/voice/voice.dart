import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:voice/common/widgets/appbar/appbar.dart';
import 'package:voice/features/app/screens/voice/speech_screen.dart';
import 'package:voice/features/app/screens/voice/widgets/create_post_form.dart';
import 'package:voice/utils/constants/colors.dart';
import 'package:voice/utils/constants/sizes.dart';
import 'package:voice/utils/helpers/helper_functions.dart';

class VoiceScreen extends StatelessWidget {
  const VoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final themeColor =
        isDark
            ? TColors.white.withOpacity(0.25)
            : TColors.black.withOpacity(0.1);
    final reversePrimaryColor = isDark ? TColors.black : TColors.white;
    final primaryColor = !isDark ? TColors.black : TColors.white;

    return Scaffold(
      appBar: TAppBar(
        title: Text(
          "Raise Issue",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
          child: Column(
            children: [
              Text(
                "Speak your issue — we'll convert it to a post automatically. ",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: TSizes.space10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: SlideAction(
                  elevation: 0,

                  height: 55,
                  text: "Slide to raise voice",
                  textStyle: Theme.of(context).textTheme.titleMedium,
                  innerColor: primaryColor,
                  outerColor: themeColor,
                  onSubmit:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SpeechScreen()),
                      ),
                  sliderButtonIconPadding: 10,
                  sliderButtonIcon: Icon(
                    Iconsax.direct_right5,
                    color: reversePrimaryColor,
                  ),
                ),
              ),
              SizedBox(height: TSizes.space10),
              Row(
                children: [
                  Expanded(child: Divider()),
                  SizedBox(width: 5),

                  Text("or", style: Theme.of(context).textTheme.bodyMedium),
                  SizedBox(width: 5),

                  Expanded(child: Divider()),
                ],
              ),
              SizedBox(height: TSizes.space10),

              Text(
                "Write your concern and share it instantly. ",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: TSizes.space10),
              TCreatePostForm(),
            ],
          ),
        ),
      ),
    );
  }
}
