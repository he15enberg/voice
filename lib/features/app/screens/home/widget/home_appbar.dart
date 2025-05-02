import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voice/common/widgets/appbar/appbar.dart';
import 'package:voice/common/widgets/icons/notification_icon.dart';
import 'package:voice/common/widgets/shimmers/shimmer.dart';
import 'package:voice/features/app/controllers/alert_controller.dart';
import 'package:voice/features/app/controllers/user_controller.dart';
import 'package:voice/features/app/screens/alerts/alerts.dart';
import 'package:voice/utils/constants/colors.dart';
import 'package:voice/utils/constants/text_strings.dart';

class THomeAppBar extends StatelessWidget {
  const THomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    final alertController = AlertController.instance;

    return TAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TTexts.homeAppbarTitle,
            style: Theme.of(
              context,
            ).textTheme.labelMedium!.apply(color: TColors.grey),
          ),
          SizedBox(height: 2.5),
          Obx(() {
            if (controller.profileLoading.value) {
              //Display a shimmer loader wile profile ferching data
              return const TShimmerEffect(height: 15.0, width: 100.0);
            } else {
              return Text(
                controller.user.value.userName,
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall!.apply(color: TColors.white),
              );
            }
          }),
        ],
      ),
      actions: [
        Obx(
          () => TNotificationIcon(
            iconColor: Colors.white,
            alertCount:
                alertController.loading.value
                    ? 0
                    : alertController.alerts.length,
            onPressed: () {
              if (!alertController.loading.value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            AlertsScreen(alerts: alertController.alerts),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
