import 'package:flutter/material.dart';
import 'package:voice/utils/constants/colors.dart';

class TStatusText extends StatelessWidget {
  const TStatusText({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.5, vertical: 2.5),
      decoration: BoxDecoration(
        color: getStatusColor(status),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(status, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}

Color getStatusColor(String status) {
  if (status == "Processing") {
    return TColors.warning;
  } else if (status == "Approved") {
    return TColors.success;
  } else if (status == "Rejected") {
    return TColors.error;
  } else {
    return TColors.primary;
  }
}
