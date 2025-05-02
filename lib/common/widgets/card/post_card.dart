import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:voice/common/widgets/chips/vote_chip.dart';
import 'package:voice/common/widgets/icons/user_logo_icon.dart';
import 'package:voice/common/widgets/texts/status_text.dart';
import 'package:voice/features/app/models/post_model.dart';
import 'package:voice/utils/constants/colors.dart';
import 'package:voice/utils/constants/sizes.dart';
import 'package:voice/utils/helpers/helper_functions.dart';

class TPostCard extends StatelessWidget {
  const TPostCard({
    super.key,
    this.needHero = true,
    this.isHorizontal = false,
    required this.hasUserUpvoted,
    required this.hasUserDownvoted,
    required this.openComment,
    required this.upvotePost,
    required this.downvotePost,
    required this.onPostTapped,
    required this.post,
  });
  final bool needHero;
  final bool isHorizontal;
  final bool hasUserUpvoted;
  final bool hasUserDownvoted;
  final VoidCallback upvotePost;
  final VoidCallback downvotePost;
  final VoidCallback openComment;
  final VoidCallback onPostTapped;
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Container(
      padding:
          isHorizontal
              ? EdgeInsets.symmetric(vertical: 10)
              : EdgeInsets.only(bottom: 20.0),
      width: THelperFunctions.screenWidth(),
      decoration:
          isHorizontal
              ? BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color:
                      isDark
                          ? TColors.white.withOpacity(0.25)
                          : TColors.black.withOpacity(0.25),
                ),
              )
              : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              spacing: 10,
              children: [
                TUserLogoIcon(),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        post.submittedBy.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        post.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
                Icon(Iconsax.edit),
              ],
            ),
          ),
          SizedBox(height: TSizes.space10),
          InkWell(
            onTap: onPostTapped,
            child: Hero(
              tag: needHero ? "Post Image ${post.id}" : "Walter White",
              child: Stack(
                children: [
                  Image.memory(
                    base64Decode(post.imageUrl),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: THelperFunctions.screenHeight() * 0.4,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color:
                            THelperFunctions.isDarkMode(context)
                                ? TColors.white.withOpacity(0.1)
                                : TColors.black.withOpacity(0.1),
                        height: THelperFunctions.screenHeight() * 0.4,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Iconsax.warning_2, size: 35),
                            const SizedBox(height: 5),
                            Text(
                              "Image not found.",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Error while loading image data.",
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 10,
                    left: 10.0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 7.5,
                        vertical: 2.5,
                      ),
                      decoration: BoxDecoration(
                        color: TColors.primary.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        spacing: 5,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Iconsax.category, size: 17.5),

                          Text(
                            post.domain,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 7.5, bottom: 5.0),
                  child: Row(
                    children: [
                      TVoteChip(
                        onTap: upvotePost,
                        action: "upvote",
                        isVoted: hasUserUpvoted,
                        voteCount: post.upvotes.length,
                      ),
                      SizedBox(width: 15),

                      TVoteChip(
                        onTap: downvotePost,
                        action: "downvote",
                        isVoted: hasUserDownvoted,
                        voteCount: post.downvotes.length,
                      ),

                      SizedBox(width: 15),
                      GestureDetector(
                        onTap: openComment,
                        child: Row(
                          spacing: 5,
                          children: [
                            Icon(Iconsax.message_text),
                            Text(
                              post.comments.length.toString(),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      TStatusText(status: post.status),
                    ],
                  ),
                ),
                Text(
                  post.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 5),
                Text(
                  post.desc,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
