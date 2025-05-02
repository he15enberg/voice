import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voice/common/widgets/appbar/appbar.dart';
import 'package:voice/common/widgets/card/group_chat_card.dart';
import 'package:voice/common/widgets/loaders/empty_data_loader.dart';
import 'package:voice/common/widgets/shimmers/group_chat_shimmer.dart';
import 'package:voice/features/app/controllers/chat_controller.dart';
import 'package:voice/features/app/screens/chat/chat_page.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatController = ChatController.instance;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TAppBar(
              showBackArrow: false,
              title: Text(
                "Voice Chat",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Obx(() {
              if (chatController.loading.value) {
                return TGroupChatShimmer();
              }

              if (chatController.groupChats.isEmpty) {
                return Center(child: TEmptyDataLoader());
              }
              return ListView.builder(
                padding: EdgeInsets.only(bottom: 20),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: chatController.groupChats.length,
                itemBuilder: (_, index) {
                  final groupChat = chatController.groupChats[index];
                  return TGroupChatCard(
                    groupChat: groupChat,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(groupChat: groupChat),
                        ),
                      );
                    },
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
