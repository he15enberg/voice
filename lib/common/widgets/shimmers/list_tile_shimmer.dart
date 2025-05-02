import 'package:flutter/material.dart';
import 'package:voice/common/widgets/shimmers/shimmer.dart';
import 'package:voice/utils/constants/sizes.dart';

class TListTileShimmer extends StatelessWidget {
  const TListTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            TShimmerEffect(width: 50.0, height: 50.0, radius: 50.0),
            SizedBox(width: TSizes.spaceBtwItems),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TShimmerEffect(width: 100.0, height: 15.0),
                SizedBox(height: TSizes.spaceBtwItems / 2),
                TShimmerEffect(width: 80.0, height: 12.0),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
