import 'package:flutter/material.dart';
import 'package:voice/common/widgets/shimmers/shimmer.dart';
import 'package:voice/utils/constants/sizes.dart';

class TChatShimmer extends StatelessWidget {
  const TChatShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          // Left aligned message (receiver)
          _buildMessageShimmer(false, 200.0, 50.0),
          const SizedBox(height: 16),

          // Left aligned message (receiver) - short
          _buildMessageShimmer(false, 120.0, 50.0),
          const SizedBox(height: 16),

          // Right aligned message (sender)
          _buildMessageShimmer(true, 250.0, 300.0),
          const SizedBox(height: 16),

          // Left aligned message (receiver) - longer
          _buildMessageShimmer(false, 300.0, 50.0),
          const SizedBox(height: 10),

          // Right aligned message (sender) - longer
          _buildMessageShimmer(false, 150.0, 50.0),
          const SizedBox(height: 16),

          // Right aligned message (sender) - medium
          _buildMessageShimmer(true, 160.0, 50.0),
        ],
      ),
    );
  }

  Widget _buildMessageShimmer(bool isSender, double width, double height) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: TShimmerEffect(width: width, height: height, radius: TSizes.sm),
    );
  }
}
