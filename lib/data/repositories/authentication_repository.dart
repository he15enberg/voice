import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:voice/features/app/screens/navigation.dart';
import 'package:voice/features/authentication/models/user_model.dart';
import 'package:voice/features/authentication/screens/login/login.dart';
import 'package:voice/features/authentication/screens/onboarding/onboarding.dart';
import 'package:voice/utils/exceptions/format_exceptions.dart';
import 'package:voice/utils/exceptions/platform_exceptions.dart';
import 'package:voice/utils/http/http_client.dart';
import 'package:voice/utils/local_storage/storage_utility.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //Variables
  final deviceStorage = GetStorage();
  //Get Authenticated userdata
  Rx<UserModel> user = UserModel.empty().obs;

  //called from main.dart on app launch
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  //Function to show relevant screen
  screenRedirect() async {
    final isAuthenticated = deviceStorage.read("isAuthenticated") ?? false;

    if (isAuthenticated) {
      // Initialize User specific storage bucket
      final userId = deviceStorage.read("userId");
      await TLocalStorage.init(userId);
      Get.offAll(() => const NavigationMenu());
    } else {
      deviceStorage.writeIfNull("isFirstTime", true);
      final isFirstTime = deviceStorage.read("isFirstTime") ?? true;

      isFirstTime
          ? Get.offAll(() => const OnBoardingScreen())
          : Get.offAll(() => const LoginScreen());
    }
  }

  /////////////////////////Email and Password Sign in//////////////////
  ///[EmailAuthentication] - Login
  Future<void> onUserSignUp(user) async {
    try {
      final response = await THttpHelper.post("auth/signup", user);
      final userData = response["data"];
      deviceStorage.writeIfNull("isAuthenticated", true);
      deviceStorage.write("userId", userData["_id"]);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw "Someting went wrong. Please try again";
    }
  }

  Future<void> onUserSignIn(data) async {
    try {
      final response = await THttpHelper.post("auth/signin", data);
      final userData = response["data"];
      deviceStorage.writeIfNull("isAuthenticated", true);
      deviceStorage.write("userId", userData["_id"]);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw "Someting went wrong. Please try again";
    }
  }

  Future<void> logoutUser() async {
    try {
      deviceStorage.remove("isAuthenticated");
      deviceStorage.remove("userId");

      Get.offAll(() => const LoginScreen());
    } catch (e) {
      throw "Logout failed. Please try again.";
    }
  }
}
