import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voice/common/widgets/loaders/loaders.dart';
import 'package:voice/data/repositories/authentication_repository.dart';
import 'package:voice/data/repositories/user_repository.dart';
import 'package:voice/features/authentication/models/user_model.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final authenticationRepository = AuthenticationRepository.instance;

  //Variables
  final profileLoading = false.obs;
  final loggingOut = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;
  final userRepository = Get.put(UserRepository());

  final hidePassword = true.obs;
  final verifEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  final imageUploading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      loggingOut.value = true;
      await authenticationRepository.logoutUser();
    } catch (e) {
      TLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
    } finally {
      loggingOut.value = false;
    }
  }

  // //Save the User record for any Registration Provider
  // Future<void> saveUserRecord(UserCredential? userCredentials) async {
  //   try {
  //     //First UpdateRx User and then check if userdata is already stored. If not store new data
  //     await fetchUserRecord();
  //     if (user.value.id.isEmpty) {
  //       if (userCredentials != null) {
  //         //Compute Name tofirst and last names
  //         final nameParts = UserModel.nameParts(
  //           userCredentials.user!.displayName ?? "",
  //         );
  //         final userName = UserModel.generateUserName(
  //           userCredentials.user!.displayName ?? "",
  //         );

  //         //Map Data
  //         final user = UserModel(
  //           id: userCredentials.user!.uid,
  //           firstName: nameParts[0],
  //           lastName:
  //               nameParts.length > 1 ? nameParts.sublist(1).join(' ') : "",
  //           userName: userName,
  //           email: userCredentials.user!.email ?? "",
  //           phoneNumber: userCredentials.user!.phoneNumber ?? "",
  //           profilePicture: userCredentials.user!.photoURL ?? "",
  //         );
  //         //Save user data
  //         await userRepository.saveUserRecord(user);
  //       }
  //     }
  //   } catch (e) {
  //     TLoaders.warningSnackBar(
  //       title: "Data not saved",
  //       message:
  //           "Something went wrong while saving your information. You can resave yourdata inyour profile",
  //     );
  //   }
  // }

  // //Delete AccountWarning pop up
  // void deleteAccountWarningPopUp() {
  //   Get.defaultDialog(
  //     titlePadding: const EdgeInsets.only(top: TSizes.defaultSpace),
  //     contentPadding: const EdgeInsets.all(TSizes.md),
  //     title: "Delete Account",
  //     middleText:
  //         "Are you sure you want to delete your account permanently? This action is not reversible and all of your data will be removed permanently",
  //     confirm: ElevatedButton(
  //       onPressed: () async => deleteUserAccount(),
  //       style: ElevatedButton.styleFrom(
  //         padding: const EdgeInsets.symmetric(horizontal: 25.5, vertical: 12.5),
  //         backgroundColor: Colors.red,
  //         side: const BorderSide(color: Colors.red),
  //       ),
  //       child: Text(
  //         "Delete",
  //         style: Theme.of(
  //           Get.overlayContext!,
  //         ).textTheme.titleMedium!.apply(color: Colors.white),
  //       ),
  //     ),
  //     cancel: OutlinedButton(
  //       style: OutlinedButton.styleFrom(
  //         padding: const EdgeInsets.symmetric(horizontal: 25.5, vertical: 12.5),
  //       ),
  //       onPressed: () => Navigator.of(Get.overlayContext!).pop(),
  //       child: Text(
  //         "Cancel",
  //         style: Theme.of(Get.overlayContext!).textTheme.titleMedium!,
  //       ),
  //     ),
  //   );
  // }

  // //Delete User account
  // void deleteUserAccount() async {
  //   try {
  //     TFullScreenLoader.openLoadingDialog(
  //       "Processing",
  //       TImages.doccerAnimation,
  //     );

  //     //First reauthenticate user
  //     final auth = AuthenticationRepository.instance;
  //     final provider =
  //         auth.authUser!.providerData.map((e) => e.providerId).first;
  //     if (provider.isNotEmpty) {
  //       //Re Verify Auth email
  //       //User logged in using googke
  //       if (provider == "google.com") {
  //         await auth.signInWithGoogle();
  //         await auth.deleteAccount();
  //         TFullScreenLoader.stopLoading();
  //         Get.offAll(() => const LoginScreen());
  //         //user loggedin using email password
  //       } else if (provider == "password") {
  //         TFullScreenLoader.stopLoading();
  //         Get.to(() => const ReAuthLoginForm());
  //       }
  //     }
  //   } catch (e) {
  //     TFullScreenLoader.stopLoading();
  //     TLoaders.warningSnackBar(title: "Oh Snap!", message: e.toString());
  //   }
  // }

  // //Reauthenticate before deleting
  // Future<void> reAuthenticateEmailandPasswordUser() async {
  //   try {
  //     //Loading
  //     TFullScreenLoader.openLoadingDialog(
  //       "Processing...",
  //       TImages.doccerAnimation,
  //     );

  //     //Check Internet Connectivty
  //     final isConnected = await NetworkManager.instance.isConnected();
  //     if (!isConnected) {
  //       //Remove Loader
  //       TFullScreenLoader.stopLoading();
  //       TLoaders.warningSnackBar(
  //         title: 'No Internet Connection',
  //         message:
  //             "You are not connected to the network. Please get connected to proceed.",
  //       );
  //       return;
  //     }

  //     //Form Validation
  //     if (!reAuthFormKey.currentState!.validate()) {
  //       //Remove Loader
  //       TFullScreenLoader.stopLoading();
  //       return;
  //     }

  //     // Register user intheFirebase Authentication &save user data in Firebase
  //     await AuthenticationRepository.instance
  //         .reAuthenticateWithEmailAndPassword(
  //           verifEmail.text.trim(),
  //           verifyPassword.text.trim(),
  //         );
  //     await AuthenticationRepository.instance.deleteAccount();

  //     //Remove Loader
  //     TFullScreenLoader.stopLoading();

  //     //Redirect
  //     Get.offAll(() => const LoginScreen());
  //   } catch (e) {
  //     //Remove Loader
  //     TFullScreenLoader.stopLoading();
  //     //Show error message
  //     TLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
  //   }
  // }

  // //Upload Profile IMage
  // uploadUserProfilePicture() async {
  //   try {
  //     imageUploading.value = true;
  //     final image = await ImagePicker().pickImage(
  //       source: ImageSource.gallery,
  //       imageQuality: 70,
  //       maxHeight: 512,
  //       maxWidth: 512,
  //     );
  //     if (image != null) {
  //       //Upload Image
  //       final imageUrl = await userRepository.uploadImage(
  //         "Users/Images/Profile/",
  //         image,
  //       );

  //       //Update User Image Record
  //       Map<String, dynamic> json = {"ProfilePicture": imageUrl};
  //       await userRepository.updateSingleField(json);

  //       user.value.profilePicture = imageUrl;
  //       user.refresh();

  //       TLoaders.succcesSnackBar(
  //         title: "Congratulations",
  //         message: "Your profile image has been updated",
  //       );
  //     }
  //   } catch (e) {
  //     TLoaders.errorSnackBar(
  //       title: "Oh Snap!",
  //       message: "Something went wrong: $e",
  //     );
  //   } finally {
  //     imageUploading.value = false;
  //   }
  // }
}
