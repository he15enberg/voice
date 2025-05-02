import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:voice/features/app/models/group_chat_model.dart';
import 'package:voice/features/authentication/models/user_model.dart';
import 'package:voice/utils/exceptions/format_exceptions.dart';
import 'package:voice/utils/exceptions/platform_exceptions.dart';
import 'package:voice/utils/http/http_client.dart';
import 'package:voice/utils/logging/logger.dart';

class ChatRepository extends GetxController {
  static ChatRepository get instance => Get.find();

  //Variables
  final deviceStorage = GetStorage();
  //Get Authenticated userdata
  Rx<UserModel> user = UserModel.empty().obs;

  //Fetch userdetails based on user id

  Future<List<GroupChatModel>> fetchAllGroupChats() async {
    try {
      final response = await THttpHelper.get("group-chat/");
      final groupChatData = response["data"] as List<dynamic>;

      final groupChats =
          groupChatData
              .map((groupChat) => GroupChatModel.fromJson(groupChat))
              .toList();
      return groupChats;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      print(e);
      TLoggerHelper.error(e.toString());
      throw "Something went wrong. Please try again";
    }
  }

  Future<List<GroupChatModel>> fetchAllGroupChatByUserId(String userId) async {
    try {
      final response = await THttpHelper.get("group-chat/members/$userId");
      final groupChatData = response["data"] as List<dynamic>;

      final groupChats =
          groupChatData
              .map((groupChat) => GroupChatModel.fromJson(groupChat))
              .toList();
      return groupChats;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      print(e);
      TLoggerHelper.error(e.toString());
      throw "Something went wrong. Please try again";
    }
  }

  Future<GroupChatModel> fetchBroupChatById(String groupChatId) async {
    try {
      final response = await THttpHelper.get("group-chat/$groupChatId");
      final groupChatData = response["data"] as dynamic;

      final groupChat = GroupChatModel.fromJson(groupChatData);
      return groupChat;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      print(e);
      TLoggerHelper.error(e.toString());
      throw "Something went wrong. Please try again";
    }
  }

  Future<void> sendMessage(
    String groupChatId,
    Map<String, dynamic> message,
  ) async {
    try {
      final response = await THttpHelper.post(
        "group-chat/chat/$groupChatId",
        message,
      );
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      print(e);
      TLoggerHelper.error(e.toString());
      throw "Something went wrong. Please try again";
    }
  }
}
