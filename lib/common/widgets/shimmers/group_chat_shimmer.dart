import 'package:flutter/material.dart';
import 'package:voice/common/widgets/shimmers/shimmer.dart';
import 'package:voice/utils/constants/sizes.dart';
import 'package:voice/utils/helpers/helper_functions.dart';

class TGroupChatShimmer extends StatelessWidget {
  const TGroupChatShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 20),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      itemBuilder: (_, index) {
        return TGroupChatCardShimmer();
      },
    );
  }
}

class TGroupChatCardShimmer extends StatelessWidget {
  const TGroupChatCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        children: [
          // Group Icon Shimmer
          const TShimmerEffect(width: 50, height: 50, radius: 25),
          const SizedBox(width: TSizes.space10),

          // Texts Shimmer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Domain Chip Shimmer
                const TShimmerEffect(width: 150, height: 15),
                const SizedBox(height: 8),

                // Group Name Shimmer
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: const TShimmerEffect(
                    width: double.infinity,
                    height: 18,
                  ),
                ),
                const SizedBox(height: 5),

                // Location Shimmer
                const TShimmerEffect(width: 100, height: 14),
                const SizedBox(height: 5),

                // Member and Post count Shimmer
                Row(
                  children: const [
                    TShimmerEffect(width: 80, height: 14),
                    SizedBox(width: 10),
                    TShimmerEffect(width: 80, height: 14),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
