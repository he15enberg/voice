import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:voice/common/widgets/loaders/full_screen_loader.dart';
import 'package:voice/common/widgets/loaders/loaders.dart';
import 'package:voice/data/repositories/authentication_repository.dart';
import 'package:voice/features/app/screens/navigation.dart';
import 'package:voice/utils/constants/image_strings.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  // final userController = Get.put(UserController());

  @override
  void onInit() {
    super.onInit();
    email.text = localStorage.read("REMEMBER_ME_EMAIL") ?? "";
    password.text = localStorage.read("REMEMBER_ME_PASSWORD") ?? "";
  }

  //Login
  Future<void> emailAndPasswordSignin() async {
    try {
      //Loading
      TFullScreenLoader.openLoadingDialog(
        "Logging you in...",
        TImages.doccerAnimation,
      );

      //Form Validation
      if (!loginFormKey.currentState!.validate()) {
        //Remove Loader
        TFullScreenLoader.stopLoading();
        return;
      }

      //Save Data if remember me is selected
      if (rememberMe.value) {
        localStorage.write("REMEMBER_ME_EMAIL", email.text.trim());
        localStorage.write("REMEMBER_ME_PASSWORD", password.text.trim());
      }

      //Register user intheFirebase Authentication &save user data in Firebase

      final data = {
        "email": email.text.trim(),
        "password": password.text.trim(),
      };
      await AuthenticationRepository.instance.onUserSignIn(data);

      //Remove Loader
      TFullScreenLoader.stopLoading();

      //Redirect
      Get.offAll(() => NavigationMenu());
    } catch (e) {
      //Remove Loader
      TFullScreenLoader.stopLoading();
      //Show error message
      TLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
    }
  }
}
