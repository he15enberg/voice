import 'package:flutter/material.dart';
import 'package:voice/common/widgets/shimmers/shimmer.dart';
import 'package:voice/utils/constants/sizes.dart';

class TDomainShimmer extends StatelessWidget {
  const TDomainShimmer({super.key, this.itemCount = 6});

  final int itemCount;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.0,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: itemCount,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: TSizes.defaultSpace),
        separatorBuilder:
            (_, __) => const SizedBox(width: TSizes.spaceBtwItems),
        itemBuilder: (_, __) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //IMage
              TShimmerEffect(width: 55, height: 55, radius: 55),
              SizedBox(height: TSizes.spaceBtwItems / 2),

              //Text
              TShimmerEffect(width: 55, height: 8.0),
            ],
          );
        },
      ),
    );
  }
}
