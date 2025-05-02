import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:voice/features/app/screens/chat/chat.dart';
import 'package:voice/features/app/screens/home/home.dart';
import 'package:voice/features/app/screens/profile/profile.dart';
import 'package:voice/features/app/screens/voice/voice.dart';
import 'package:voice/utils/constants/colors.dart';
import 'package:voice/utils/helpers/helper_functions.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      //Body
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
      //Bottom navigation
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80.0,
          elevation: 0.0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) {
            controller.selectedIndex.value = index;
          },
          backgroundColor: dark ? TColors.black : Colors.white,
          indicatorColor:
              dark
                  ? TColors.white.withOpacity(0.1)
                  : TColors.black.withOpacity(0.1),
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: "Home"),
            NavigationDestination(
              icon: Icon(Iconsax.voice_square),
              label: "Voice",
            ),
            NavigationDestination(icon: Icon(Iconsax.message), label: "Chat"),
            NavigationDestination(icon: Icon(Iconsax.user), label: "Profile"),
          ],
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  static NavigationController get instance => Get.find();
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    const HomeScreen(),
    const VoiceScreen(),
    const ChatScreen(),
    // const ChatPage(),
    const ProfileScreen(),
  ];
}
