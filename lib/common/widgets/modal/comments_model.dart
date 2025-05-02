import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax/iconsax.dart';
import 'package:voice/common/widgets/icons/user_logo_icon.dart';
import 'package:voice/features/app/controllers/post_controller.dart';
import 'package:voice/features/app/models/post_model.dart';
import 'package:voice/utils/constants/colors.dart';
import 'package:voice/utils/constants/sizes.dart';
import 'package:voice/utils/helpers/helper_functions.dart';

showCommentsModal(BuildContext context, PostModel post) {
  final postController = PostController.instance;

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Obx(() {
        final postIndex = postController.posts.indexWhere(
          (apost) => apost.id == post.id,
        );

        final comments = postController.posts[postIndex].comments;

        return Container(
          // width: THelperFunctions.screenWidth(),
          padding: EdgeInsets.only(
            top: 0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            expand: false,
            builder: (context, scrollController) {
              return Column(
                children: [
                  Text(
                    "Voice Comments",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: TSizes.space10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ListView.builder(
                        controller: scrollController,
                        padding: EdgeInsets.only(bottom: 50),
                        itemCount: comments.length,
                        itemBuilder: (_, index) {
                          final comment = comments[index];
                          return Container(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 10,
                              children: [
                                TUserLogoIcon(isShowSmall: true),
                                Column(
                                  mainAxisSize: MainAxisSize.min,

                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      comment.username,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    SizedBox(
                                      width:
                                          THelperFunctions.screenWidth() * 0.75,
                                      child: Text(
                                        comment.text,
                                        // maxLines: 2,
                                        // overflow: TextOverflow.ellipsis,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10.0,
                    ),
                    child: Row(
                      children: [
                        TUserLogoIcon(),
                        Expanded(
                          child: TextFormField(
                            minLines: 1,
                            maxLines: null,
                            controller: postController.comment,
                            decoration: InputDecoration(
                              hintText: "Add your voice comment...",
                            ).copyWith(
                              border: const OutlineInputBorder().copyWith(
                                borderRadius: BorderRadius.circular(0),
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder()
                                  .copyWith(
                                    borderRadius: BorderRadius.circular(0),
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                              focusedBorder: const OutlineInputBorder()
                                  .copyWith(
                                    borderRadius: BorderRadius.circular(0),
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                              hintStyle: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (postController.comment.text.trim().isEmpty) {
                              return;
                            }

                            postController.commentPost(
                              post.id,
                              postController.comment.text,
                            );
                            postController.comment.clear();
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: TColors.primary,
                            ),
                            child: Icon(
                              Iconsax.send_2,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      });
    },
  );
}
