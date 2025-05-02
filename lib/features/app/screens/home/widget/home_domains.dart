import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voice/common/widgets/image_text_widdgets/vertical_image_text.dart';
import 'package:voice/common/widgets/shimmers/domain_shimmer.dart';
import 'package:voice/features/app/controllers/domain_controller.dart';
import 'package:voice/features/app/screens/home/widget/domain_screen.dart';
import 'package:voice/utils/constants/sizes.dart';

class THomeDomains extends StatelessWidget {
  const THomeDomains({super.key});

  @override
  Widget build(BuildContext context) {
    final domainController = Get.put(DomainController());
    return Obx(() {
      if (domainController.isLoading.value) {
        return const TDomainShimmer();
      }
      if (domainController.domains.isEmpty) {
        return Center(
          child: Text(
            "No Data Found",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.apply(color: Colors.white),
          ),
        );
      }
      return SizedBox(
        height: 80.0,
        child: ListView.builder(
          itemCount: domainController.domains.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: TSizes.defaultSpace),
          itemBuilder: (_, index) {
            final domain = domainController.domains[index];
            return TVerticalImageText(
              image: domain.image,
              title: domain.name,
              isNetworkImage: false,

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DomainScreen(domain: domain),
                  ),
                );
              },
            );
          },
        ),
      );
    });
  }
}
