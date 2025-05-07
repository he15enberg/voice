import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:voice/common/widgets/chips/vote_chip.dart';
import 'package:voice/common/widgets/icons/user_logo_icon.dart';
import 'package:voice/common/widgets/texts/section_heading.dart';
import 'package:voice/common/widgets/texts/status_text.dart';
import 'package:voice/features/app/models/post_model.dart';
import 'package:voice/features/app/screens/home/widget/similar_posts.dart';
import 'package:voice/utils/constants/colors.dart';
import 'package:voice/utils/constants/sizes.dart';
import 'package:voice/utils/helpers/helper_functions.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({
    super.key,
    this.needHero = true,

    required this.hasUserUpvoted,
    required this.hasUserDownvoted,
    required this.openComment,
    required this.upvotePost,
    required this.downvotePost,
    required this.post,
  });
  final bool needHero;

  final bool hasUserUpvoted;
  final bool hasUserDownvoted;
  final VoidCallback upvotePost;
  final VoidCallback downvotePost;
  final VoidCallback openComment;
  final PostModel post;
  @override
  Widget build(BuildContext context) {
    final height = THelperFunctions.screenHeight();
    final width = THelperFunctions.screenWidth();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: needHero ? "Post Image ${post.id}" : "Heisenberg",

              child: Stack(
                children: [
                  Container(
                    height: height * 0.5,

                    child: Image.memory(
                      base64Decode(post.imageUrl),
                      fit: BoxFit.cover,
                      width: double.infinity,
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
                  ),
                  Positioned(
                    top: 45,

                    child: Container(
                      width: width,
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(7.5),

                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Iconsax.arrow_left_1,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(width: TSizes.spaceBtwItems),
                          Flexible(
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

                                  Flexible(
                                    child: Text(
                                      post.domain,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
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
                  Row(
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
                  SizedBox(height: TSizes.space10),

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
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Divider(),
                  ),
                  TSectionHeading(title: "Similar Posts"),
                ],
              ),
            ),
            Container(
              height: height * 0.625,
              child: TSimilarPostsList(postId: post.id),
            ),
          ],
        ),
      ),
    );
  }
}
