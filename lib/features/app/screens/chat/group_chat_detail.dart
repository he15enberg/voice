import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:voice/common/widgets/appbar/appbar.dart';
import 'package:voice/common/widgets/card/post_card.dart';
import 'package:voice/common/widgets/icons/group_chat_icon.dart';
import 'package:voice/common/widgets/icons/user_logo_icon.dart';
import 'package:voice/common/widgets/modal/comments_model.dart';
import 'package:voice/common/widgets/texts/section_heading.dart';
import 'package:voice/features/app/controllers/chat_controller.dart';
import 'package:voice/features/app/controllers/post_controller.dart';
import 'package:voice/features/app/screens/home/post_screen.dart.dart'
    show PostScreen;
import 'package:voice/features/app/screens/home/widget/similar_posts.dart';
import 'package:voice/utils/constants/colors.dart';
import 'package:voice/utils/constants/sizes.dart';
import 'package:voice/utils/helpers/helper_functions.dart';

class TGroupChatDetailsPage extends StatelessWidget {
  const TGroupChatDetailsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final themeColor =
        isDark
            ? TColors.white.withOpacity(0.5)
            : TColors.black.withOpacity(0.5);
    final reversePrimaryColor = isDark ? TColors.black : TColors.white;
    final primaryColor = !isDark ? TColors.black : TColors.white;
    final chatController = ChatController.instance;
    final postController = PostController.instance;
    final width = THelperFunctions.screenWidth();
    final height = THelperFunctions.screenHeight();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TAppBar(showBackArrow: true),
            TGroupChatIcon(isShowTrue: true),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: width * 0.1,
              ),
              child: Column(
                spacing: 5,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.5,
                      vertical: 2.5,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: themeColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      chatController.groupChat.value.postGroup!.domain,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Text(
                    chatController.groupChat.value.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.location, size: 20, color: themeColor),
                      SizedBox(width: 5),
                      Text(
                        chatController.groupChat.value.postGroup!.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall!,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.075),
              child: Row(
                children: [
                  TGroupChartInfoCard(
                    icon: Iconsax.profile_2user,
                    text:
                        "${chatController.groupChat.value.members.length} members",
                  ),
                  SizedBox(width: 10.0),
                  TGroupChartInfoCard(
                    icon: Iconsax.simcard_2,
                    text:
                        "${chatController.groupChat.value.postGroup!.posts!.length} posts",
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Divider(color: themeColor.withOpacity(0.25)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.075),
              child: TSectionHeading(title: "Members"),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemCount: chatController.groupChat.value.members.length,
                itemBuilder: (context, index) {
                  final member = chatController.groupChat.value.members[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      children: [
                        TUserLogoIcon(),
                        SizedBox(width: 10),

                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                member.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                member.id,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Divider(color: themeColor.withOpacity(0.25)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.075),
              child: TSectionHeading(title: "Group Posts"),
            ),
            SizedBox(
              height: height * 0.625,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount:
                    chatController.groupChat.value.postGroup!.posts!.length,
                // shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) {
                  return const SizedBox(width: TSizes.spaceBtwItems);
                },
                itemBuilder: (context, index) {
                  final post =
                      chatController.groupChat.value.postGroup!.posts![index];
                  return Padding(
                    padding:
                        index == 0
                            ? EdgeInsets.only(left: TSizes.spaceBtwItems)
                            : index ==
                                chatController
                                        .groupChat
                                        .value
                                        .postGroup!
                                        .posts!
                                        .length -
                                    1
                            ? EdgeInsets.only(right: TSizes.spaceBtwItems)
                            : EdgeInsets.zero,
                    child: TPostCard(
                      isHorizontal: true,
                      post: post,
                      upvotePost: () {
                        postController.onUpvote(post.id);
                      },
                      downvotePost: () {
                        postController.onDownVote(post.id);
                      },
                      openComment: () {
                        showCommentsModal(context, post);
                      },
                      hasUserDownvoted: postController.hasUserDownvoted(post),
                      hasUserUpvoted: postController.hasUserUpvoted(post),
                      onPostTapped: () {
                        if (!postController.loading.value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => PostScreen(
                                    post: post,
                                    upvotePost: () {
                                      postController.onUpvote(post.id);
                                    },
                                    downvotePost: () {
                                      postController.onDownVote(post.id);
                                    },
                                    openComment: () {
                                      showCommentsModal(context, post);
                                    },
                                    hasUserDownvoted: postController
                                        .hasUserDownvoted(post),
                                    hasUserUpvoted: postController
                                        .hasUserUpvoted(post),
                                  ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Divider(color: themeColor.withOpacity(0.25)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.075),
              child: TSectionHeading(title: "Similar Queries"),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemCount:
                    chatController
                        .groupChat
                        .value
                        .postGroup!
                        .similarQueries
                        .length,
                itemBuilder: (context, index) {
                  final query =
                      chatController
                          .groupChat
                          .value
                          .postGroup!
                          .similarQueries[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: TColors.primary,
                          ),
                        ),
                        SizedBox(width: 10),

                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                query,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}

class TGroupChartInfoCard extends StatelessWidget {
  const TGroupChartInfoCard({
    super.key,
    required this.icon,
    required this.text,
  });
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final themeColor =
        isDark
            ? TColors.white.withOpacity(0.5)
            : TColors.black.withOpacity(0.5);
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: themeColor),
        ),
        child: Column(
          children: [
            Icon(icon, color: themeColor),
            SizedBox(height: 5),
            Text(text),
          ],
        ),
      ),
    );
  }
}
