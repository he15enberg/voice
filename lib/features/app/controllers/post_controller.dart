import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voice/common/widgets/loaders/loaders.dart';
import 'package:voice/data/repositories/post_repository.dart';
import 'package:voice/features/app/controllers/alert_controller.dart';
import 'package:voice/features/app/controllers/chat_controller.dart';
import 'package:voice/features/app/controllers/user_controller.dart';
import 'package:voice/features/app/models/post_model.dart';
import 'package:voice/utils/device/device_utility.dart';
import 'package:voice/utils/logging/logger.dart';

class PostController extends GetxController {
  static PostController get instance => Get.find();
  final postRepository = Get.put(PostRepository());

  final userController = UserController.instance;

  final deviceStorage = GetStorage();

  //Variables
  final hidePassword = true.obs;
  final privacyPolicy = false.obs;

  final title = TextEditingController();
  final desc = TextEditingController();
  final RxString location = "".obs;
  final locationError = false.obs;

  final RxString imageUrl = "".obs;

  final comment = TextEditingController();

  final imageUploading = false.obs;
  final imageError = false.obs;
  final loading = false.obs;
  final similarPostsLoading = false.obs;

  GlobalKey<FormState> createPostFormKey = GlobalKey<FormState>();

  final RxList<PostModel> posts = <PostModel>[].obs;
  final RxList<PostModel> userPosts = <PostModel>[].obs;
  final RxList<PostModel> similarPosts = <PostModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllPosts();
    fetchUserPosts();
  }

  Future<void> fetchAllPosts() async {
    try {
      loading.value = true;
      final posts = await postRepository.fetchAllPosts();
      this.posts.value = posts;
    } catch (e) {
      posts.value = [];
    } finally {
      loading.value = false;
    }
  }

  Future<void> fetchUserPosts() async {
    try {
      loading.value = true;
      final userId = userController.user.value.id;

      final posts = await postRepository.fetchUserPosts(userId);
      userPosts.value = posts;
    } catch (e) {
      userPosts.value = [];
    } finally {
      loading.value = false;
    }
  }

  Future<void> fetchSimilarPosts(String postId) async {
    try {
      similarPostsLoading.value = true;

      final posts = await postRepository.fetchSimilarPosts(postId);
      similarPosts.value = posts;
    } catch (e) {
      similarPosts.value = [];
    } finally {
      similarPostsLoading.value = false;
    }
  }

  Future<void> onUpvote(postId) async {
    try {
      final userId = userController.user.value.id;
      await postRepository.upVotePost(postId, userId);
    } catch (e) {
      TLoaders.errorSnackBar(
        title: "Oh Snap!",
        message: "Something went wrong: $e",
      );
    } finally {
      fetchAllPosts();
    }
  }

  Future<void> onDownVote(postId) async {
    try {
      final userId = userController.user.value.id;
      await postRepository.downVotePost(postId, userId);
    } catch (e) {
      TLoaders.errorSnackBar(
        title: "Oh Snap!",
        message: "Something went wrong: $e",
      );
    } finally {
      fetchAllPosts();
    }
  }

  bool hasUserUpvoted(PostModel post) {
    final userId = userController.user.value.id;
    return post.upvotes.contains(userId);
  }

  bool hasUserDownvoted(PostModel post) {
    final userId = userController.user.value.id;
    return post.downvotes.contains(userId);
  }

  Future<void> commentPost(postId, text) async {
    try {
      final userId = userController.user.value.id;
      final newComment = await postRepository.commentOnPost(
        postId,
        userId,
        text,
      );
    } catch (e) {
      TLoaders.errorSnackBar(
        title: "Oh Snap!",
        message: "Something went wrong: $e",
      );
    } finally {
      fetchAllPosts();
    }
  }

  Future<void> createPost() async {
    try {
      loading.value = true;
      //Form Validation
      if (imageUrl.value.isEmpty) {
        imageError.value = true;
      } else {
        imageError.value = false;
      }
      if (location.value.isEmpty) {
        locationError.value = true;
      } else {
        locationError.value = false;
      }

      // Validate form
      if (!createPostFormKey.currentState!.validate() ||
          imageError.value ||
          locationError.value) {
        loading.value = false;
        return;
      }

      final userId = deviceStorage.read("userId");

      final newPost = {
        "title": title.text,
        "desc": desc.text,
        "userId": userId,
        "location": location.value,
        "imageurl": imageUrl.value,
      };
      // TLoggerHelper.info(newPost.toString());
      await postRepository.createVoicePost(newPost);
      resetForm();
      TLoaders.succcesSnackBar(
        title: "Congratulations",
        message: "Your voice post created successfully.",
      );
      await ChatController.instance.fetchAllGroupChatByUserId();
      await AlertController.instance.fetchAllAlerts();
    } catch (e) {
      TLoaders.errorSnackBar(
        title: "Oh Snap!",
        message: "Something went wrong: $e",
      );
    } finally {
      loading.value = false;
      fetchAllPosts();
    }
  }

  void resetForm() {
    title.clear();
    desc.clear();
    location.value = "";
    imageUrl.value = "";
    imageError.value = false;
    locationError.value = false;
    createPostFormKey.currentState?.reset();
  }

  getBase64Image() async {
    try {
      imageUploading.value = true;

      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxHeight: 512,
        maxWidth: 512,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        final base64Image = base64Encode(bytes);
        imageUrl.value = base64Image;
      } else {
        TLoaders.errorSnackBar(
          title: "Oh Snap!",
          message: "Something went wrong: Cannot upload image",
        );
      }
    } catch (e) {
      TLoggerHelper.error(e.toString());

      TLoaders.errorSnackBar(
        title: "Oh Snap!",
        message: "Something went wrong: $e",
      );
      return ""; // also return on exception
    } finally {
      imageUploading.value = false;
    }
  }
}
