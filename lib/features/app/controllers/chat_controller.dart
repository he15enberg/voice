import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:voice/common/widgets/loaders/loaders.dart';
import 'package:voice/data/repositories/chat_repository.dart';
import 'package:voice/features/app/controllers/user_controller.dart';
import 'package:voice/features/app/models/group_chat_model.dart';
import 'package:voice/utils/device/device_utility.dart';
import 'package:voice/utils/logging/logger.dart';

class ChatController extends GetxController {
  static ChatController get instance => Get.find();
  final chatRepository = Get.put(ChatRepository());

  final userController = UserController.instance;

  final deviceStorage = GetStorage();

  final loading = false.obs;

  final RxList<GroupChatModel> groupChats = <GroupChatModel>[].obs;
  final Rx<GroupChatModel> groupChat = GroupChatModel.empty().obs;
  final RxList<types.Message> messages = <types.Message>[].obs;
  final RxBool isSending = false.obs;
  late types.User user;
  @override
  void onInit() async {
    super.onInit();
    fetchAllGroupChatByUserId();
    final userId = deviceStorage.read("userId");

    user = types.User(id: userId);
  }

  Future<void> fetchAllGroupChat() async {
    try {
      loading.value = true;

      final groupChats = await chatRepository.fetchAllGroupChats();
      this.groupChats.value = groupChats;
    } catch (e) {
      groupChats.value = [];
    } finally {
      loading.value = false;
    }
  }

  Future<void> fetchAllGroupChatByUserId() async {
    try {
      loading.value = true;
      final userId = deviceStorage.read("userId");
      final groupChats = await chatRepository.fetchAllGroupChatByUserId(userId);
      this.groupChats.value = groupChats;
    } catch (e) {
      groupChats.value = [];
    } finally {
      loading.value = false;
    }
  }

  Future<void> fetchGroupChatById(groupChatId) async {
    try {
      loading.value = true;

      final groupChat = await chatRepository.fetchBroupChatById(groupChatId);
      this.groupChat.value = groupChat;
      messages.value = convertMessageModelsToTypesMessages(groupChat.messages!);
    } catch (e) {
      groupChat.value = GroupChatModel.empty();
    } finally {
      loading.value = false;
    }
  }

  List<types.Message> convertMessageModelsToTypesMessages(
    List<MessageModel> messageModels,
  ) {
    final List<types.Message> chatMessages = [];
    final uuid = Uuid();

    // Loop through messages in reverse order (latest first)
    for (final messageModel in messageModels.reversed) {
      final types.User author = types.User(
        id: messageModel.user?.id ?? 'unknown',
        firstName: messageModel.user?.name,
      );

      if (messageModel.type == 'text') {
        chatMessages.add(
          types.TextMessage(
            author: author,
            id: uuid.v4(),
            text: messageModel.message,
            createdAt: messageModel.createdAt.millisecondsSinceEpoch,
          ),
        );
      } else if (messageModel.type == 'post' && messageModel.post != null) {
        final postContent = '''
      Title: ${messageModel.post!.title}
      Description: ${messageModel.post!.desc}
      Domain: ${messageModel.post!.domain}
      Location: ${messageModel.post!.location}
      Status: ${messageModel.post!.status}
      ''';

        chatMessages.add(
          types.CustomMessage(
            author: author,
            id: uuid.v4(),
            metadata: {
              "postImageUrl": messageModel.post!.imageUrl,
              'postId': messageModel.post!.id,
              "text": messageModel.message,
              'authorName': author.firstName!,
              'title': messageModel.post!.title,
              'desc': messageModel.post!.desc,
              'domain': messageModel.post!.domain,
              'location': messageModel.post!.location,
              'status': messageModel.post!.status,
              'submittedBy': messageModel.post!.submittedBy.name,
              'upvotes': messageModel.post!.upvotes.length,
              'downvotes': messageModel.post!.downvotes.length,
              'commentsCount': messageModel.post!.comments.length,
            },
            createdAt: messageModel.createdAt.millisecondsSinceEpoch,
          ),
        );
      }
    }

    return chatMessages;
  }

  void _addMessage(types.Message message) {
    messages.insert(0, message);
  }

  void handleSendPressed(types.PartialText message) async {
    TDeviceUtils.hideKeyboard(Get.context!);

    isSending.value = true;

    try {
      final textMessage = types.TextMessage(
        author: user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: message.text,
      );

      final userId = userController.user.value.id;

      final newMesssage = {
        "userId": userId,
        "message": message.text,
        "role": "Student",
        "type": "text",
        "post": null,
      };

      await chatRepository.sendMessage(groupChat.value.id, newMesssage);
      _addMessage(textMessage);
    } catch (e) {
      print("Error sending message: $e");

      TLoaders.errorSnackBar(
        title: "Oh Snap!",
        message: "Something went wrong: $e",
      );
    } finally {
      isSending.value = false;
    }
  }
}
