import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:voice/common/widgets/icons/group_chat_icon.dart';
import 'package:voice/features/app/models/group_chat_model.dart';
import 'package:voice/utils/constants/colors.dart';
import 'package:voice/utils/constants/sizes.dart';
import 'package:voice/utils/helpers/helper_functions.dart';

class TGroupChatCard extends StatelessWidget {
  const TGroupChatCard({
    super.key,
    required this.groupChat,
    required this.onTap,
  });

  final GroupChatModel groupChat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
        child: Column(
          children: [
            Row(
              children: [
                TGroupChatIcon(),
                SizedBox(width: TSizes.space10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color:
                                isDark
                                    ? TColors.white.withOpacity(0.5)
                                    : TColors.black.withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          spacing: 5,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: TColors.primary,
                              ),
                            ),
                            Text(
                              groupChat.postGroup!.domain,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,

                              style: Theme.of(
                                context,
                              ).textTheme.labelLarge!.copyWith(
                                color:
                                    isDark
                                        ? TColors.white.withOpacity(0.5)
                                        : TColors.black.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color:
                              isDark
                                  ? TColors.white.withOpacity(0.5)
                                  : TColors.black.withOpacity(0.5),
                        ),
                      ),
                      Row(
                        children: [
                          TChatTextIconCard(
                            text:
                                "${groupChat.members.length.toString()} members",
                            icon: Iconsax.profile_2user,
                          ),
                          TChatTextIconCard(
                            text:
                                "${groupChat.postGroup!.posts!.length.toString()} posts",
                            icon: Iconsax.simcard_2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TChatTextIconCard extends StatelessWidget {
  const TChatTextIconCard({super.key, required this.text, required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final Color color =
        isDark
            ? TColors.white.withOpacity(0.5)
            : TColors.black.withOpacity(0.5);
    return Row(
      children: [
        Icon(icon, size: 17.5, color: color),
        SizedBox(width: 5.0),
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: color),
        ),
        SizedBox(width: 10),
      ],
    );
  }
}
