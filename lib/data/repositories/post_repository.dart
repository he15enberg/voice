import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:voice/features/app/models/post_model.dart';
import 'package:voice/features/authentication/models/user_model.dart';
import 'package:voice/utils/exceptions/format_exceptions.dart';
import 'package:voice/utils/exceptions/platform_exceptions.dart';
import 'package:voice/utils/http/http_client.dart';
import 'package:voice/utils/logging/logger.dart';

class PostRepository extends GetxController {
  static PostRepository get instance => Get.find();

  //Variables
  final deviceStorage = GetStorage();
  //Get Authenticated userdata
  Rx<UserModel> user = UserModel.empty().obs;

  //Fetch userdetails based on user id

  Future<List<PostModel>> fetchAllPosts() async {
    try {
      final response = await THttpHelper.get("post/");
      final postsData = response["data"] as List<dynamic>;

      final posts = postsData.map((post) => PostModel.fromJson(post)).toList();
      return posts;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      TLoggerHelper.error(e.toString());
      throw "Something went wrong. Please try again";
    }
  }

  Future<List<PostModel>> fetchUserPosts(userId) async {
    try {
      final response = await THttpHelper.get("post/$userId");
      final postsData = response["data"] as List<dynamic>;

      final posts = postsData.map((post) => PostModel.fromJson(post)).toList();
      return posts;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      TLoggerHelper.error(e.toString());
      throw "Something went wrong. Please try again";
    }
  }

  Future<List<PostModel>> fetchSimilarPosts(postId) async {
    try {
      final response = await THttpHelper.get("post/similar-posts/$postId");
      print(response);
      final postsData = response["data"] as List<dynamic>;

      final posts = postsData.map((post) => PostModel.fromJson(post)).toList();
      return posts;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      TLoggerHelper.error(e.toString());
      throw "Something went wrong. Please try again";
    }
  }

  Future<void> createVoicePost(postData) async {
    try {
      final response = await THttpHelper.post("post/create", postData);
      final userData = response["data"];
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      final error = jsonDecode(e.toString());
      final message = error["message"];
      TLoggerHelper.error(message);

      throw message;
    }
  }

  Future<void> upVotePost(postId, userId) async {
    try {
      final response = await THttpHelper.post("post/vote/$postId", {
        "userId": userId,
        "action": "upvote",
      });
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      TLoggerHelper.error(e.toString());

      throw "Someting went wrong. Please try again";
    }
  }

  Future<void> downVotePost(postId, userId) async {
    try {
      final response = await THttpHelper.post("post/vote/$postId", {
        "userId": userId,
        "action": "downvote",
      });
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      TLoggerHelper.error(e.toString());

      throw "Someting went wrong. Please try again";
    }
  }

  Future<CommentModel> commentOnPost(postId, userId, text) async {
    try {
      final response = await THttpHelper.post("post/comment/$postId", {
        "userId": userId,
        "text": text,
      });
      return CommentModel.fromJson(response["data"]);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      TLoggerHelper.error(e.toString());

      throw "Someting went wrong. Please try again";
    }
  }
}
