import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:voice/common/widgets/appbar/appbar.dart';
import 'package:voice/common/widgets/card/post_card.dart';
import 'package:voice/common/widgets/images/circular_image.dart';
import 'package:voice/common/widgets/loaders/empty_data_loader.dart';
import 'package:voice/common/widgets/modal/comments_model.dart';
import 'package:voice/common/widgets/shimmers/posts_shimmer.dart';
import 'package:voice/common/widgets/shimmers/shimmer.dart';
import 'package:voice/common/widgets/texts/section_heading.dart';
import 'package:voice/features/app/controllers/post_controller.dart';
import 'package:voice/features/app/controllers/user_controller.dart';
import 'package:voice/features/app/screens/home/post_screen.dart.dart';
import 'package:voice/features/app/screens/profile/widgets/profile_menu.dart';
import 'package:voice/utils/constants/colors.dart';
import 'package:voice/utils/constants/sizes.dart';
import 'package:voice/utils/helpers/helper_functions.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    final postController = PostController.instance;
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      //Body
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Obx(() {
                          final networkImage =
                              controller.user.value.profilePicture;

                          if (controller.imageUploading.value) {
                            return const TShimmerEffect(
                              height: 80.0,
                              width: 80.0,
                              radius: 80.0,
                            );
                          } else {
                            return networkImage.isNotEmpty
                                ? CircleAvatar(
                                  radius: 42.5,
                                  backgroundColor: TColors.primary,
                                  foregroundColor: TColors.primary,
                                  child: TCircularImage(
                                    image: networkImage,
                                    fit: BoxFit.cover,
                                    width: 80.0,
                                    height: 80.0,
                                    isNetworkImage: networkImage.isNotEmpty,
                                  ),
                                )
                                : Container(
                                  padding: EdgeInsets.all(5),
                                  width: 80.0,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        isDark ? TColors.white : TColors.black,
                                  ),
                                  child: Icon(
                                    Iconsax.user_octagon,
                                    size: 55,
                                    color:
                                        !isDark ? TColors.white : TColors.black,
                                  ),
                                );
                          }
                        }),
                        TextButton(
                          onPressed: () => {},
                          child: Text(
                            "Change Profile Picture",
                            style: Theme.of(context).textTheme.bodyMedium!
                                .apply(color: TColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Details
                  // SizedBox(
                  //   height: TSizes.spaceBtwItems / 2,
                  // ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  const TSectionHeading(
                    title: "Profile Information",
                    showActionButton: false,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  TProfileMenu(
                    title: "Username",
                    value: controller.user.value.userName,
                    onPressed: () {},
                  ),

                  TProfileMenu(
                    title: "User ID",
                    icon: Iconsax.copy,
                    needIcon: true,
                    value: controller.user.value.id,
                    onPressed: () {},
                  ),
                  TProfileMenu(
                    title: "Email",
                    value: controller.user.value.email,
                    onPressed: () {},
                  ),
                  TProfileMenu(
                    title: "Phone",
                    value: controller.user.value.phoneNumber,
                    onPressed: () {},
                  ),
                  TProfileMenu(
                    title: "Role",
                    value: controller.user.value.role,
                    onPressed: () {},
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.logout();
                      },
                      child: Text(
                        "Logout",
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.apply(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Column(
              children: [
                //Heading
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: TSectionHeading(
                    title: "Your Voice Posts",
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

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
                      );
                    },
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
