import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:voice/utils/constants/colors.dart';
import 'package:voice/utils/helpers/helper_functions.dart';

class TShimmerEffect extends StatelessWidget {
  const TShimmerEffect({
    super.key,
    this.height = 15.0,
    required this.width,
    this.horizontalPadding = 0.0,
    this.verticalPadding = 0.0,
    this.radius = 15.0,
    this.color,
  });
  final double height, width, radius, horizontalPadding, verticalPadding;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Shimmer.fromColors(
        baseColor:
            dark
                ? const Color.fromARGB(120, 48, 48, 48)
                : const Color.fromARGB(120, 224, 224, 224),
        highlightColor: dark ? Colors.grey[700]! : Colors.grey[100]!,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color ?? (dark ? TColors.darkerGrey : TColors.white),
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
    );
  }
}
