import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:voice/common/widgets/loaders/full_screen_loader.dart";
import "package:voice/common/widgets/loaders/loaders.dart";
import "package:voice/data/repositories/authentication_repository.dart";
import "package:voice/features/app/screens/navigation.dart";
import "package:voice/utils/constants/image_strings.dart";

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  //Variables
  final hidePassword = true.obs;
  final privacyPolicy = false.obs;

  final email = TextEditingController();
  final RxString role = "Student".obs;
  final userName = TextEditingController();
  final password = TextEditingController();
  final phoneNumber = TextEditingController();
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  //SignUp
  void signup() async {
    try {
      //Loading
      TFullScreenLoader.openLoadingDialog(
        "As we are processing your information...",
        TImages.doccerAnimation,
      );

      //Form Validation
      if (!signUpFormKey.currentState!.validate()) {
        //Remove Loader
        TFullScreenLoader.stopLoading();
        return;
      }

      //Privacy Policy Check
      if (!privacyPolicy.value) {
        TLoaders.warningSnackBar(
          title: "Accept Privacy Policy",
          message:
              "In order to create account , you must read and accept the Privacy Policy & Terms of use",
        );
      }

      final newUser = {
        "role": role.value,
        "name": userName.text.trim(),
        "email": email.text.trim(),
        "password": password.text.trim(),
        "phone": phoneNumber.text.trim(),
        "profilePicture": "",
      };
      print(newUser);
      await AuthenticationRepository.instance.onUserSignUp(newUser);

      //Remove Loader
      TFullScreenLoader.stopLoading();

      //Show Success Mesage
      TLoaders.succcesSnackBar(
        title: "Congratulations",
        message: "Your account has been created. Verify mail to continue",
      );

      //Move to Verify Email Screen
      Get.offAll(() => NavigationMenu());
    } catch (e) {
      //Remove Loader
      TFullScreenLoader.stopLoading();
      //Show error message
      TLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
    }
  }
}
