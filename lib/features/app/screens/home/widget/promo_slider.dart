// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:voice/common/widgets/custom_shapes/containers/circular_container.dart';
// import 'package:voice/common/widgets/images/rounded_image.dart';
// import 'package:voice/common/widgets/shimmers/shimmer.dart';
// import 'package:voice/utils/constants/colors.dart';
// import 'package:voice/utils/constants/sizes.dart';
// import 'package:voice/utils/device/device_utility.dart';

// class TPromoSlider extends StatelessWidget {
//   const TPromoSlider({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (controller.isLoading.value) {
//         return TShimmerEffect(
//           width: TDeviceUtils.getScreenWidth(context) * 0.8,
//           height: 190.0,
//         );
//       }
//       if (controller.banners.isEmpty) {
//         return Center(
//           child: Text(
//             "No Data Found",
//             style: Theme.of(context)
//                 .textTheme
//                 .titleMedium!
//                 .apply(color: Colors.white),
//           ),
//         );
//       } else {
//         return Column(
//           children: [
//             CarouselSlider(
//               items: controller.banners
//                   .map((banner) => TRoundedImage(
//                         imageUrl: banner.imageUrl,
//                         isNetworkImage: true,
//                         onPressed: () => Get.toNamed(banner.targetScreen),
//                       ))
//                   .toList(),
//               options: CarouselOptions(
//                 viewportFraction: 1,
//                 onPageChanged: (index, reason) =>
//                     controller.updatePageIndicator(index),
//               ),
//             ),
//             const SizedBox(
//               height: TSizes.spaceBtwItems,
//             ),
//             Center(
//               child: Obx(
//                 () => Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     for (int i = 0; i < controller.banners.length; i++)
//                       TCircularContainer(
//                         width: 20.0,
//                         height: 4.0,
//                         margin: const EdgeInsets.only(right: 10.0),
//                         backgroundColor:
//                             controller.carauselCurrentIndex.value == i
//                                 ? TColors.primary
//                                 : TColors.grey,
//                       )
//                   ],
//                 ),
//               ),
//             )
//           ],
//         );
//       }
//     });
//   }
// }
