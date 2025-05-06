import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:iconsax/iconsax.dart';
import 'package:voice/common/widgets/appbar/chat_app_bar.dart';
import 'package:voice/common/widgets/chips/vote_chip.dart';
import 'package:voice/common/widgets/icons/user_logo_icon.dart';
import 'package:voice/common/widgets/shimmers/chat_shimmer.dart';
import 'package:voice/common/widgets/texts/status_text.dart';
import 'package:voice/features/app/controllers/chat_controller.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'package:voice/features/app/models/group_chat_model.dart';
import 'package:voice/utils/constants/colors.dart';
import 'package:voice/utils/helpers/helper_functions.dart';

class ChatPage extends StatefulWidget {
  final GroupChatModel groupChat;

  const ChatPage({Key? key, required this.groupChat}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Initialize controller once in initState
  late final ChatController chatController;

  @override
  void initState() {
    super.initState();
    // Get the instance of controller instead of creating a new one
    chatController = Get.find<ChatController>();
    // Fetch chat data after widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatController.fetchGroupChatById(widget.groupChat.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final themeColor =
        isDark
            ? TColors.white.withOpacity(0.5)
            : TColors.black.withOpacity(0.5);
    final reversePrimaryColor = isDark ? TColors.black : TColors.white;
    final primaryColor = !isDark ? TColors.black : TColors.white;

    return Scaffold(
      body: Column(
        children: [
          TChatAppBar(themeColor: themeColor, groupChat: widget.groupChat),
          Expanded(
            child: Obx(() {
              if (chatController.loading.value) {
                return TChatShimmer();
              }

              return Chat(
                messages: chatController.messages.toList(),
                onSendPressed: chatController.handleSendPressed,
                showUserAvatars: true,
                showUserNames: true,
                user: chatController.user,
                theme: DefaultChatTheme(
                  backgroundColor: reversePrimaryColor,
                  primaryColor: primaryColor,
                  secondaryColor: isDark ? TColors.darkerGrey : TColors.grey,
                  userAvatarNameColors: [primaryColor],
                  sentMessageBodyTextStyle: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(color: reversePrimaryColor),
                  receivedMessageBodyTextStyle:
                      Theme.of(context).textTheme.bodyLarge!,
                  userNameTextStyle: Theme.of(context).textTheme.titleLarge!,
                  sentMessageCaptionTextStyle: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(color: reversePrimaryColor),
                  receivedMessageCaptionTextStyle: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(color: reversePrimaryColor),
                  dateDividerTextStyle: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(color: primaryColor),
                  messageBorderRadius: 15,
                  messageInsetsHorizontal: 15,
                  messageInsetsVertical: 10,
                  inputContainerDecoration: BoxDecoration(
                    color: isDark ? TColors.grey : TColors.black,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                  ),
                  inputTextCursorColor: Colors.black,
                  inputPadding: const EdgeInsets.symmetric(vertical: 5),
                  inputMargin: EdgeInsets.zero,
                  inputTextColor: reversePrimaryColor,
                  inputTextStyle: Theme.of(context).textTheme.bodyLarge!,
                  sendButtonIcon: Obx(
                    () =>
                        chatController.isSending.value
                            ? Container(
                              padding: const EdgeInsets.all(7.5),
                              decoration: const BoxDecoration(
                                color: TColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                            : Container(
                              padding: const EdgeInsets.all(7.5),
                              decoration: const BoxDecoration(
                                color: TColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Iconsax.send_2,
                                color: Colors.white,
                              ),
                            ),
                  ),
                  inputTextDecoration: InputDecoration(
                    hintText: "Chat your voice",
                    hintStyle: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.copyWith(color: reversePrimaryColor),
                    border: const OutlineInputBorder().copyWith(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: const OutlineInputBorder().copyWith(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: const OutlineInputBorder().copyWith(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
                hideBackgroundOnEmojiMessages: true,
                customMessageBuilder: customMessageBuilder,
                avatarBuilder: (author) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 5.0),
                    child: TUserLogoIcon(),
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

Widget customMessageBuilder(
  types.CustomMessage message, {
  required int messageWidth,
  bool showName = true,
}) {
  final customMessage = {
    'authorName': message.metadata?['authorName'] ?? '',
    'postImageUrl': message.metadata?['postImageUrl'] ?? '',
    'text': message.metadata?['text'] ?? '',
    "title": message.metadata?['title'] ?? '',
    "desc": message.metadata?['description'] ?? '',
    "location": message.metadata?['location'] ?? '',
    "domain": message.metadata?['domain'] ?? '',
    "status": message.metadata?['status'] ?? '',
    "upvotes": message.metadata?['upvotes'] ?? 0,
    "downvotes": message.metadata?['downvotes'] ?? 0,
    "commentsCount": message.metadata?['commentsCount'] ?? 0,
  };
  final isDark = THelperFunctions.isDarkMode(Get.context!);

  final reversePrimaryColor = isDark ? TColors.black : TColors.white;
  final primaryColor = !isDark ? TColors.black : TColors.white;
  final themeColor =
      isDark ? TColors.white.withOpacity(0.5) : TColors.black.withOpacity(0.5);
  // Build a custom widget for post messages
  return Container(
    color: TColors.primary.withOpacity(0.8),
    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Voice Message",
          style: Theme.of(
            Get.context!,
          ).textTheme.titleMedium!.copyWith(color: TColors.white),
        ),
        const SizedBox(height: 5),

        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.memory(
            base64Decode(customMessage["postImageUrl"]),
            fit: BoxFit.cover,
            width: double.infinity,
            height: THelperFunctions.screenHeight() * 0.3,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                // color:
                //     THelperFunctions.isDarkMode(context)
                //         ? TColors.white.withOpacity(0.1)
                //         : TColors.black.withOpacity(0.1),
                height: THelperFunctions.screenHeight() * 0.3,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Iconsax.warning_2,
                      size: 35,
                      color: TColors.white,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Image not found.",
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium!.copyWith(color: TColors.white),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Error while loading image data.",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: TColors.white.withOpacity(0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 5),

        Text(
          message.metadata?['title'] ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            Get.context!,
          ).textTheme.titleLarge!.copyWith(color: TColors.white),
        ),
        Text(
          message.metadata?['desc'] ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            Get.context!,
          ).textTheme.bodyMedium!.copyWith(color: TColors.white),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Row(
            children: [
              Icon(
                Iconsax.location,
                size: 20,
                color: TColors.white.withOpacity(0.5),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  message.metadata?['location'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(Get.context!).textTheme.bodySmall!.copyWith(
                    color: TColors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),

        Container(
          padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: TColors.white.withOpacity(0.5)),
          ),
          child: Text(
            message.metadata?['domain'] ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(Get.context!).textTheme.labelMedium!.copyWith(
              color: TColors.white.withOpacity(0.5),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 7.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TStatusText(status: message.metadata?['status'] ?? ''),
              Row(
                children: [
                  TVoteChip(
                    onTap: () {},
                    action: "upvote",
                    isVoted: false,
                    voteCount: message.metadata?['upvotes'] ?? '',
                  ),
                  const SizedBox(width: 10),
                  TVoteChip(
                    onTap: () {},
                    action: "downvote",
                    isVoted: false,
                    voteCount: message.metadata?['downvotes'] ?? '',
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(color: primaryColor.withOpacity(0.25)),
        Text(
          message.metadata?['text'] ?? '',
          style: Theme.of(
            Get.context!,
          ).textTheme.titleMedium!.copyWith(color: TColors.white),
        ),
      ],
    ),
  );
}
