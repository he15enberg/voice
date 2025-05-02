import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voice/common/widgets/texts/section_heading.dart';
import 'package:voice/features/app/controllers/post_controller.dart';
import 'package:voice/utils/constants/colors.dart';
import 'package:voice/utils/helpers/helper_functions.dart';

const List<String> locations = [
  "Anna University Main Building",

  "Department of Electronics & Communication Engineering",
  "Anna University Swimming Pool",
  "College of Engineering, Guindy",
  "Department of Civil Engineering",
  "Department of Information Science and Technology",
  "Anna University Central Library",
  "Department of Industrial Engineering",
  "Department of Biotechnology",
  "Department of Nuclear Physics",
  "Institute for Energy Studies",
];
showMapModal(BuildContext context) {
  final postController = PostController.instance;
  final isDark = THelperFunctions.isDarkMode(context);

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        // width: THelperFunctions.screenWidth(),
        child: DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,

              child: Column(
                children: [
                  Image.asset(
                    "assets/images/content/map.jpg",
                    width: THelperFunctions.screenWidth(),
                    height: THelperFunctions.screenHeight() * 0.4,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 5,
                    ),
                    child: TSectionHeading(title: "Pick Locations"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 50),
                      itemCount: locations.length,
                      itemBuilder: (_, index) {
                        final location = locations[index];
                        return Obx(
                          () => Container(
                            // ✅ Move Obx here
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color:
                                    isDark
                                        ? TColors.white.withOpacity(0.25)
                                        : TColors.black.withOpacity(0.25),
                              ),
                            ),
                            child: Column(
                              children: [
                                RadioListTile<String>(
                                  title: Text(
                                    location,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  fillColor: WidgetStateProperty.all(
                                    TColors.primary,
                                  ),
                                  value: location,
                                  groupValue: postController.location.value,
                                  onChanged: (value) {
                                    postController.location.value = value!;
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
