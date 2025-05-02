import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:voice/common/widgets/appbar/appbar.dart';
import 'package:voice/common/widgets/loaders/empty_data_loader.dart';
import 'package:voice/features/app/models/alert_model.dart';
import 'package:voice/utils/constants/colors.dart';
import 'package:voice/utils/helpers/helper_functions.dart';

Color getAlertColor(String alertType) {
  if (alertType == "warning") {
    return TColors.warning;
  } else if (alertType == "success") {
    return TColors.success;
  } else if (alertType == "error") {
    return TColors.error;
  } else {
    return TColors.primary;
  }
}

String formatDateTime(DateTime dateTime) {
  final DateFormat formatter = DateFormat("MMM d, yyyy h:mma");
  return formatter.format(dateTime);
}

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key, required this.alerts});
  final List<AlertModel> alerts;
  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TAppBar(
              showBackArrow: true,
              title: Text(
                "Voice Alerts",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            alerts.length == 0
                ? Center(child: TEmptyDataLoader())
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 20),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: alerts.length,
                    itemBuilder: (_, index) {
                      final alert = alerts[index];
                      return Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(bottom: 5),

                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(10),
                          // border: Border.all(
                          //   color:
                          //       isDark
                          //           ? TColors.white.withOpacity(0.25)
                          //           : TColors.black.withOpacity(0.25),
                          // ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            Container(
                              padding: EdgeInsets.all(7.5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: getAlertColor(alert.type),
                              ),
                              child: Icon(Iconsax.message_notif),
                            ),
                            Expanded(
                              child: Column(
                                spacing: 5,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    spacing: 5,
                                    children: [
                                      Icon(Iconsax.calendar_1, size: 15),
                                      Text(
                                        formatDateTime(alert.createdAt),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium!.copyWith(
                                          color:
                                              isDark
                                                  ? TColors.white.withOpacity(
                                                    0.75,
                                                  )
                                                  : TColors.black.withOpacity(
                                                    0.75,
                                                  ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Text(
                                    alert.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                    alert.message,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
