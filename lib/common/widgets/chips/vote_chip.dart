import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TVoteChip extends StatelessWidget {
  final VoidCallback onTap;
  final String action;
  final bool isVoted;
  final int voteCount;

  const TVoteChip({
    Key? key,
    required this.onTap,
    required this.action,
    required this.isVoted,
    required this.voteCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            action == "upvote"
                ? isVoted
                    ? Iconsax.direct_up5
                    : Iconsax.direct_up
                : isVoted
                ? Iconsax.direct_down5
                : Iconsax.direct_down,
          ),
          const SizedBox(width: 5),
          Text(
            voteCount.toString(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
