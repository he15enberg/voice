import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:voice/common/widgets/appbar/appbar.dart';
import 'package:voice/features/app/controllers/speechtotext_controller.dart';
import 'package:voice/utils/constants/colors.dart';
import 'package:voice/utils/helpers/helper_functions.dart';

class SpeechScreen extends StatelessWidget {
  SpeechScreen({Key? key}) : super(key: key);

  final SpeechToTextController controller = Get.put(SpeechToTextController());

  @override
  Widget build(BuildContext context) {
    final height = THelperFunctions.screenHeight();
    final width = THelperFunctions.screenWidth();
    final isDark = THelperFunctions.isDarkMode(context);
    final themeColor =
        isDark
            ? TColors.white.withOpacity(0.25)
            : TColors.black.withOpacity(0.25);
    final reversePrimaryColor = isDark ? TColors.black : TColors.white;
    final primaryColor = !isDark ? TColors.black : TColors.white;

    return Scaffold(
      appBar: TAppBar(
        title: Text(
          "Voice Speech to Post",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        showBackArrow: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "Tap the voice icon, speak your issue, and we'll turn it into a post for you.",

              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Container(
            height: height * 0.65,
            margin: EdgeInsets.only(top: 15),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Stack(
              children: [
                Container(
                  height: height * 0.65,
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: themeColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Obx(
                    () => SingleChildScrollView(
                      child: Text(
                        controller.recognizedText.value,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 1,
                  right: 1,
                  left: 1,
                  child: Container(
                    child: Obx(() {
                      if (controller.confidence.value != 0.0) {
                        return AnimatedConfidenceIndicator(
                          confidence: controller.confidence.value,
                        );
                      }
                      return Container();
                    }),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,

                  child: Container(
                    child: Obx(() {
                      if (controller.recognizedText.value.trim() != "") {
                        return GestureDetector(
                          onTap: () {
                            controller.recognizedText.value = "";
                            controller.confidence.value = 0.0;
                          },
                          child: Container(
                            padding: EdgeInsets.all(7.5),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Iconsax.trash,
                              color: reversePrimaryColor,
                            ),
                          ),
                        );
                      }
                      return Container();
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Obx(() {
          final isTextEmpty = controller.recognizedText.value.trim() == "";
          return GestureDetector(
            onTap: controller.startListening,

            child: AvatarGlow(
              startDelay: const Duration(milliseconds: 1000),
              glowColor: TColors.primary,
              glowShape: BoxShape.circle,
              animate: controller.isListening.value,
              curve: Curves.fastOutSlowIn,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                // padding: EdgeInsets.all(
                //   controller.loading.value
                //       ? 10
                //       : isTextEmpty
                //       ? 10
                //       : 24,
                // ),
                height:
                    controller.loading.value
                        ? 60
                        : isTextEmpty
                        ? 60
                        : 50,
                width:
                    controller.loading.value
                        ? 60
                        : isTextEmpty
                        ? 60
                        : width * 0.9,
                decoration: BoxDecoration(
                  color: TColors.primary,
                  borderRadius: BorderRadius.circular(
                    controller.loading.value
                        ? 100
                        : isTextEmpty
                        ? 100
                        : 10,
                  ),
                ),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child:
                      controller.loading.value
                          ? CircularProgressIndicator(color: Colors.white)
                          : isTextEmpty
                          ? Icon(
                            Iconsax.voice_cricle,
                            key: ValueKey('icon'),
                            color: Colors.white,
                            size: 45,
                          )
                          : Text(
                            "Generate Post",
                            key: ValueKey('text'),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                ),
              ),
            ),
          );
        }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class AnimatedConfidenceIndicator extends StatelessWidget {
  final double confidence;

  const AnimatedConfidenceIndicator({Key? key, required this.confidence})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final themeColor =
        isDark
            ? TColors.white.withOpacity(0.25)
            : TColors.black.withOpacity(0.25);
    final reversePrimaryColor = isDark ? Colors.black : Colors.white;
    final primaryColor = !isDark ? Colors.black : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Progress bar with animation
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: confidence),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                builder: (context, value, _) {
                  return LinearProgressIndicator(
                    minHeight: 24,
                    value: value,
                    backgroundColor:
                        isDark ? TColors.darkerGrey : TColors.darkGrey,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  );
                },
              ),
            ),

            // Animated text overlay
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: confidence),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              builder: (context, value, _) {
                return Text(
                  'Confidence ${(value * 100).toStringAsFixed(1)}%',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(color: reversePrimaryColor),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
