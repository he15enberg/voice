import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voice/common/widgets/appbar/appbar.dart';
import 'package:voice/common/widgets/card/post_card.dart';
import 'package:voice/common/widgets/loaders/empty_data_loader.dart';
import 'package:voice/common/widgets/modal/comments_model.dart';
import 'package:voice/common/widgets/shimmers/posts_shimmer.dart';
import 'package:voice/features/app/controllers/domain_controller.dart';
import 'package:voice/features/app/controllers/post_controller.dart';
import 'package:voice/features/app/models/domain_model.dart';
import 'package:voice/features/app/models/post_model.dart';
import 'package:voice/features/app/screens/home/post_screen.dart.dart';

class DomainScreen extends StatelessWidget {
  final DomainModel domain;

  DomainScreen({Key? key, required this.domain}) : super(key: key) {
    // Load posts when widget is initialized, but after the current build frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DomainController.instance.loadPostsForDomain(domain.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = DomainController.instance;
    final postController = PostController.instance;

    return Scaffold(
      body: Column(
        children: [
          TAppBar(
            showBackArrow: true,
            title: Text(
              domain.name,
              maxLines: 2,
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(fontSize: 18),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const TPostsShimmer();
              }

              final posts = controller.domainPosts;

              if (posts.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 100.0),
                  child: TEmptyDataLoader(),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.only(top: 10),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return TPostCard(
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
                                  hasUserUpvoted: postController.hasUserUpvoted(
                                    post,
                                  ),
                                ),
                          ),
                        );
                      }
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
