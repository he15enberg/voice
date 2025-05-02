import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:voice/common/widgets/modal/map_modal.dart';
import 'package:voice/features/app/controllers/post_controller.dart';
import 'package:voice/utils/constants/colors.dart';
import 'package:voice/utils/constants/sizes.dart';
import 'package:voice/utils/device/device_utility.dart';
import 'package:voice/utils/helpers/helper_functions.dart';
import 'package:voice/utils/validators/validation.dart';

class TCreatePostForm extends StatelessWidget {
  const TCreatePostForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PostController.instance;
    final isDark = THelperFunctions.isDarkMode(context);

    return Form(
      key: controller.createPostFormKey,
      child: Column(
        children: [
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    controller.getBase64Image();
                  },
                  child: Container(
                    width: double.infinity,
                    height: TDeviceUtils.getScreenHeight(context) * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        TSizes.inputFieldRadius,
                      ),
                      border: Border.all(
                        width: 1,
                        color:
                            controller.imageError.value
                                ? TColors.warning
                                : isDark
                                ? TColors.white.withOpacity(0.5)
                                : TColors.black.withOpacity(0.15),
                      ),
                    ),
                    child:
                        controller.imageUrl.value == ""
                            ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Iconsax.image, size: 30),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Add Voice Image",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Drag an Image or Browse it from your mobile",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(
                                TSizes.inputFieldRadius,
                              ),
                              child: Image.memory(
                                base64Decode(controller.imageUrl.value),
                                fit: BoxFit.cover,
                              ),
                            ),
                  ),
                ),
                if (controller.imageError.value)
                  Padding(
                    padding: const EdgeInsets.only(top: 2, left: 10),
                    child: Text(
                      "Voice image is required.",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color:
                            THelperFunctions.isDarkMode(context)
                                ? const Color.fromARGB(255, 241, 189, 189)
                                : TColors.error,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Title
          TextFormField(
            minLines: 1,
            maxLines: null,
            controller: controller.title,
            validator: (value) => TValidator.validateEmptyText("Title", value),
            decoration: const InputDecoration(
              labelText: "Title",
              prefixIcon: Icon(Iconsax.magicpen),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Description
          TextFormField(
            minLines: 3,
            maxLines: null,
            controller: controller.desc,
            validator:
                (value) => TValidator.validateEmptyText("Description", value),
            decoration: const InputDecoration(
              labelText: "Description",
              prefixIcon: Icon(Iconsax.subtitle),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Location
          // TextFormField(
          //   minLines: 1,
          //   maxLines: null,
          //   controller: controller.location,
          //   validator:
          //       (value) => TValidator.validateEmptyText("Location", value),
          //   decoration: const InputDecoration(
          //     labelText: "Location",
          //     prefixIcon: Icon(Iconsax.location),
          //   ),
          // ),
          GestureDetector(
            onTap: () {
              showMapModal(context);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              height: 55.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
                border: Border.all(
                  width: 1,
                  color:
                      controller.locationError.value
                          ? TColors.warning
                          : isDark
                          ? TColors.white.withOpacity(0.5)
                          : TColors.black.withOpacity(0.15),
                ),
              ),
              child: Row(
                spacing: 15,
                children: [
                  Icon(
                    Iconsax.location,
                    color:
                        isDark
                            ? TColors.white.withOpacity(0.5)
                            : TColors.black.withOpacity(0.15),
                  ),
                  Expanded(
                    child: Obx(
                      () => Text(
                        controller.location.isEmpty
                            ? "Pick Location"
                            : controller.location.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (controller.locationError.value)
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2, left: 10),
                  child: Text(
                    "Voice Location is required.",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color:
                          THelperFunctions.isDarkMode(context)
                              ? const Color.fromARGB(255, 241, 189, 189)
                              : TColors.error,
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Submit button
          Obx(() {
            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    controller.loading.value
                        ? null
                        : () {
                          controller.createPost();
                          TDeviceUtils.hideKeyboard(context);
                        },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 15,
                  children: [
                    Text(
                      controller.loading.value ? "Creating" : "Create Voice",
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium!.apply(color: Colors.white),
                    ),
                    if (controller.loading.value)
                      SizedBox(
                        height: 20.0,
                        width: 20.0,
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
