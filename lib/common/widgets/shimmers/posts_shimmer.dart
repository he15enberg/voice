import 'package:flutter/material.dart';
import 'package:voice/common/widgets/shimmers/shimmer.dart';
import 'package:voice/utils/constants/sizes.dart';
import 'package:voice/utils/helpers/helper_functions.dart';

class TPostsShimmer extends StatelessWidget {
  const TPostsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 20),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (_, index) {
        return TPostCardShimmer();
      },
    );
  }
}

class TPostCardShimmer extends StatelessWidget {
  const TPostCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                const TShimmerEffect(width: 50.0, height: 50.0, radius: 50.0),
                const SizedBox(width: TSizes.spaceBtwItems),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    TShimmerEffect(width: 150.0, height: 15.0),
                    SizedBox(height: TSizes.spaceBtwItems / 2),
                    TShimmerEffect(width: 80.0, height: 12.0),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: TSizes.space10),

          // Image Placeholder
          TShimmerEffect(
            width: double.infinity,
            height: THelperFunctions.screenHeight() * 0.4,
          ),

          // Like / Comment / Status Row
          const SizedBox(height: 10),

          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
            child: TShimmerEffect(
              width: THelperFunctions.screenWidth() * 0.75,
              height: 18.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
            child: TShimmerEffect(width: double.infinity, height: 18.0),
          ),

          // Description
        ],
      ),
    );
  }
}
