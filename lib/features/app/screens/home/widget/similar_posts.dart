import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voice/common/widgets/card/post_card.dart';
import 'package:voice/common/widgets/loaders/empty_data_loader.dart';
import 'package:voice/common/widgets/modal/comments_model.dart';
import 'package:voice/common/widgets/shimmers/posts_shimmer.dart';
import 'package:voice/features/app/controllers/post_controller.dart';
import 'package:voice/features/app/screens/home/post_screen.dart.dart';
import 'package:voice/utils/constants/sizes.dart';

class TSimilarPostsList extends StatelessWidget {
  final String postId;

  TSimilarPostsList({Key? key, required this.postId}) : super(key: key) {
    // Load posts when widget is initialized, but after the current build frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await PostController.instance.fetchSimilarPosts(postId);
    });
  }
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final postController = PostController.instance;

    return Obx(() {
      if (postController.similarPostsLoading.value) {
        return const TPostCardShimmer();
      }

      final similarPosts = postController.similarPosts;

      if (similarPosts.isEmpty) {
        return const Padding(
          padding: EdgeInsets.only(top: 100.0),
          child: TEmptyDataLoader(),
        );
      }

      return ListView.separated(
        controller: scrollController,
        padding: EdgeInsets.zero,
        itemCount: similarPosts.length,
        // shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) {
          return const SizedBox(width: TSizes.spaceBtwItems);
        },
        itemBuilder: (context, index) {
          final post = similarPosts[index];
          return Padding(
            padding:
                index == 0
                    ? EdgeInsets.only(left: TSizes.spaceBtwItems)
                    : index == similarPosts.length - 1
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
                            hasUserDownvoted: postController.hasUserDownvoted(
                              post,
                            ),
                            hasUserUpvoted: postController.hasUserUpvoted(post),
                          ),
                    ),
                  );
                }
              },
            ),
          );
        },
      );
    });
  }
}
