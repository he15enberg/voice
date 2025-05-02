import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:voice/utils/constants/image_strings.dart';
import 'package:voice/utils/constants/sizes.dart';

class TEmptyDataLoader extends StatelessWidget {
  const TEmptyDataLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.125,
      ),
      child: Column(
        children: [
          Lottie.asset(
            TImages.pencilAnimation,
            width: MediaQuery.of(context).size.width * 0.65,
          ),
          Text(
            "Oops! No Voice Posts Found.",
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.apply(color: Colors.white),
          ),
          const SizedBox(height: TSizes.space10),
          Text(
            "Raise your voice on the isssues surrounding you.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
