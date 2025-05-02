import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:voice/features/authentication/models/user_model.dart';
import 'package:voice/utils/exceptions/format_exceptions.dart';
import 'package:voice/utils/exceptions/platform_exceptions.dart';
import 'package:voice/utils/http/http_client.dart';
import 'package:voice/utils/logging/logger.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  //Variables
  final deviceStorage = GetStorage();
  //Get Authenticated userdata
  Rx<UserModel> user = UserModel.empty().obs;

  //Fetch userdetails based on user id

  Future<UserModel> fetchUserDetails() async {
    try {
      final userId = deviceStorage.read("userId");
      final response = await THttpHelper.get("auth/$userId");
      final userData = response["data"];
      // TLoggerHelper.info(userData);

      if (userData.toString() != "") {
        return UserModel.fromSnapshot(userData);
      } else {
        return UserModel.empty();
      }
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw "Someting went wrong. Please try again";
    }
  }

  // //Function to update user data in firestore
  // Future<void> updateUserDetails(UserModel updatedUser) async {
  //   try {
  //     await _db
  //         .collection("Users")
  //         .doc(updatedUser.id)
  //         .update(updatedUser.toJson());
  //   } on FirebaseException catch (e) {
  //     throw TFirebaseException(e.code).message;
  //   } on FormatException catch (_) {
  //     throw const TFormatException();
  //   } on PlatformException catch (e) {
  //     throw TPlatformException(e.code).message;
  //   } catch (e) {
  //     throw "Someting went wrong. Please try again";
  //   }
  // }

  // //Update a field in specific user collection
  // Future<void> updateSingleField(Map<String, dynamic> json) async {
  //   try {
  //     await _db
  //         .collection("Users")
  //         .doc(AuthenticationRepository.instance.authUser?.uid)
  //         .update(json);
  //   } on FirebaseException catch (e) {
  //     throw TFirebaseException(e.code).message;
  //   } on FormatException catch (_) {
  //     throw const TFormatException();
  //   } on PlatformException catch (e) {
  //     throw TPlatformException(e.code).message;
  //   } catch (e) {
  //     throw "Someting went wrong. Please try again";
  //   }
  // }

  // //Remove user data from firestore
  // Future<void> removeUserRecord(String userId) async {
  //   try {
  //     await _db.collection("Users").doc(userId).delete();
  //   } on FirebaseException catch (e) {
  //     throw TFirebaseException(e.code).message;
  //   } on FormatException catch (_) {
  //     throw const TFormatException();
  //   } on PlatformException catch (e) {
  //     throw TPlatformException(e.code).message;
  //   } catch (e) {
  //     throw "Someting went wrong. Please try again";
  //   }
  // }

  // //Upload any image
  // Future<String> uploadImage(String path, XFile image) async {
  //   try {
  //     final ref = FirebaseStorage.instance.ref(path).child(image.name);
  //     await ref.putFile(File(image.path));
  //     final url = await ref.getDownloadURL();
  //     return url;
  //   } on FirebaseException catch (e) {
  //     throw TFirebaseException(e.code).message;
  //   } on FormatException catch (_) {
  //     throw const TFormatException();
  //   } on PlatformException catch (e) {
  //     throw TPlatformException(e.code).message;
  //   } catch (e) {
  //     throw "Someting went wrong. Please try again";
  //   }
  // }
}
