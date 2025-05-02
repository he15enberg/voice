import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:voice/common/widgets/icons/group_chat_icon.dart';
import 'package:voice/features/app/models/group_chat_model.dart';
import 'package:voice/features/app/screens/chat/group_chat_detail.dart';
import 'package:voice/utils/constants/colors.dart';
import 'package:voice/utils/constants/sizes.dart';

class TChatAppBar extends StatelessWidget {
  const TChatAppBar({
    super.key,
    required this.themeColor,
    required this.groupChat,
  });

  final Color themeColor;
  final GroupChatModel groupChat;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      // backgroundColor: TColors.primary.withOpacity(0.15),
      toolbarHeight: 70,
      leadingWidth: 0,
      actionsPadding: EdgeInsets.zero,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(Iconsax.arrow_left, color: themeColor),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TGroupChatDetailsPage(),
                    ),
                  ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    TGroupChatIcon(),
                    SizedBox(width: TSizes.space10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Container(
                          //   padding: EdgeInsets.symmetric(
                          //     horizontal: 5,
                          //     vertical: 2.5,
                          //   ),
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(5),
                          //     border: Border.all(color: themeColor),
                          //   ),
                          //   child: Row(
                          //     spacing: 5,
                          //     mainAxisSize: MainAxisSize.min,
                          //     children: [
                          //       Container(
                          //         height: 10,
                          //         width: 10,
                          //         decoration: BoxDecoration(
                          //           shape: BoxShape.circle,
                          //           color: TColors.primary,
                          //         ),
                          //       ),
                          //       Text(
                          //         groupChat.postGroup!.domain,
                          //         maxLines: 1,
                          //         overflow: TextOverflow.ellipsis,

                          //         style: Theme.of(
                          //           context,
                          //         ).textTheme.labelLarge!.copyWith(color: themeColor),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Text(
                            groupChat.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            groupChat.postGroup!.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.copyWith(color: themeColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
