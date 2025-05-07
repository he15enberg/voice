import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:voice/common/widgets/card/post_card.dart';
import 'package:voice/common/widgets/container/primary_header_container.dart';
import 'package:voice/common/widgets/container/search_container.dart';
import 'package:voice/common/widgets/loaders/empty_data_loader.dart';
import 'package:voice/common/widgets/modal/comments_model.dart';
import 'package:voice/common/widgets/shimmers/posts_shimmer.dart';
import 'package:voice/common/widgets/texts/section_heading.dart';
import 'package:voice/features/app/controllers/alert_controller.dart';
import 'package:voice/features/app/controllers/chat_controller.dart';
import 'package:voice/features/app/controllers/post_controller.dart';
import 'package:voice/features/app/controllers/user_controller.dart';
import 'package:voice/features/app/screens/home/post_screen.dart.dart';
import 'package:voice/features/app/screens/home/widget/home_appbar.dart';
import 'package:voice/features/app/screens/home/widget/home_domains.dart';
import 'package:voice/utils/constants/colors.dart';
import 'package:voice/utils/constants/sizes.dart';
import 'package:voice/utils/helpers/helper_functions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final postController = Get.put(PostController());
    final chatController = Get.put(ChatController());
    final alertController = Get.put(AlertController());

    return Scaffold(
      body: LiquidPullToRefresh(
        height: 200,
        springAnimationDurationInMilliseconds: 500,
        backgroundColor: TColors.primary,
        color: Color.fromARGB(255, 93, 119, 255),
        showChildOpacityTransition: false,
        onRefresh: () async {
          await postController.fetchAllPosts();
          await postController.fetchUserPosts();
        },

        child: SingleChildScrollView(
          child: Column(
            children: [
              const TPrimaryHeaderContainer(
                child: Column(
                  children: [
                    //App Bar
                    THomeAppBar(),
                    SizedBox(height: TSizes.space10),
                    //SearchBar
                    TSearchContainer(text: "Search voice queries"),
                    SizedBox(height: TSizes.spaceBtwSections),
                    //Categories
                    Column(
                      children: [
                        //Heading
                        Padding(
                          padding: EdgeInsets.only(left: TSizes.defaultSpace),
                          child: TSectionHeading(
                            title: "Available Domains",
                            showActionButton: false,
                            textColor: Colors.white,
                          ),
                        ),
                        SizedBox(height: TSizes.spaceBtwItems),
                        //Categories
                        THomeDomains(),
                      ],
                    ),
                    SizedBox(height: TSizes.spaceBtwSections),
                  ],
                ),
              ),
              //Body
              Column(
                children: [
                  //Heading
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TSectionHeading(
                      title: "Recent Voices",
                      onPressed: () {},
                    ),
                  ),
                  Obx(() {
                    if (postController.loading.value) {
                      return TPostsShimmer();
                    }

                    if (postController.posts.isEmpty) {
                      return Center(child: TEmptyDataLoader());
                    }
                    return ListView.builder(
                      padding: EdgeInsets.only(bottom: 20),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: postController.posts.length,
                      itemBuilder: (_, index) {
                        final post = postController.posts[index];
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
                          hasUserDownvoted: postController.hasUserDownvoted(
                            post,
                          ),
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
                        );
                      },
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
