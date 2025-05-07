import 'package:flutter/material.dart';
import 'package:voice/common/widgets/shimmers/shimmer.dart';
import 'package:voice/utils/constants/sizes.dart';
import 'package:voice/utils/constants/colors.dart';

class TProfileShimmer extends StatelessWidget {
  const TProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Image Section
          Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                // Profile Image
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      // Profile Picture Loading Shimmer
                      const TShimmerEffect(
                        height: 80.0,
                        width: 80.0,
                        radius: 80.0,
                      ),
                      const SizedBox(height: 8),
                      // Change Profile Button Shimmer
                      const TShimmerEffect(
                        height: 20.0,
                        width: 150.0,
                        radius: TSizes.sm,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: TSizes.spaceBtwItems),

                // Profile Information Section Header
                _buildSectionHeadingShimmer(),
                const SizedBox(height: TSizes.spaceBtwItems),

                // Profile Menu Items
                _buildProfileMenuItemShimmer(),
                const SizedBox(height: TSizes.spaceBtwItems / 2),
                _buildProfileMenuItemShimmer(),
                const SizedBox(height: TSizes.spaceBtwItems / 2),
                _buildProfileMenuItemShimmer(),
                const SizedBox(height: TSizes.spaceBtwItems / 2),
                _buildProfileMenuItemShimmer(),
                const SizedBox(height: TSizes.spaceBtwItems / 2),
                _buildProfileMenuItemShimmer(),

                const SizedBox(height: TSizes.spaceBtwItems),

                // Logout Button
                const TShimmerEffect(
                  height: 50.0,
                  width: double.infinity,
                  radius: TSizes.buttonRadius,
                ),
              ],
            ),
          ),

          const SizedBox(height: TSizes.spaceBtwItems),
        ],
      ),
    );
  }

  Widget _buildSectionHeadingShimmer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const TShimmerEffect(height: 20.0, width: 150.0, radius: TSizes.sm),
        const TShimmerEffect(height: 20.0, width: 60.0, radius: TSizes.sm),
      ],
    );
  }

  Widget _buildProfileMenuItemShimmer() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: TSizes.sm,
        horizontal: TSizes.md,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TShimmerEffect(
                height: 15.0,
                width: 80.0,
                radius: TSizes.xs,
              ),
              const SizedBox(height: 8),
              const TShimmerEffect(
                height: 15.0,
                width: 180.0,
                radius: TSizes.xs,
              ),
            ],
          ),
          const TShimmerEffect(height: 25.0, width: 25.0, radius: TSizes.xs),
        ],
      ),
    );
  }
}
