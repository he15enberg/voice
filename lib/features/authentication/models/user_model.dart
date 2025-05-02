import 'package:voice/utils/formatters/formatter.dart';

class UserModel {
  final String id;
  String role;
  final String userName;
  final String email;
  String phoneNumber;
  String profilePicture;
  String password; // Added password field

  UserModel({
    required this.id,
    required this.role,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    required this.password,
  });

  //get fullname

  //format phonenumber
  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  //Split full name
  static List<String> nameParts(fullName) => fullName.split(" ");

  //generate username
  static String generateUserName(fullname) {
    List<String> nameParts = fullname.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUserName = "$firstName$lastName";
    String userNameWithData = "tstore_$camelCaseUserName";
    return userNameWithData;
  }

  //create empty username
  static UserModel empty() => UserModel(
    id: "",
    role: "",
    userName: "",
    email: "",
    phoneNumber: "",
    profilePicture: "",
    password: "",
  );

  // Convert model to json - Fixed field names to match backend expectations
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "role": role,
      "name": userName,
      "email": email,
      "phone": phoneNumber,
      "password": password,
      "profilePicture": profilePicture,
    };
  }

  //factory method to create a usermodel from a firebase document snapshot
  factory UserModel.fromSnapshot(Map<String, dynamic> data) {
    return UserModel(
      id: data["_id"] ?? "",
      role: data["role"] ?? "",
      userName: data["name"] ?? "",
      email: data["email"] ?? "",
      phoneNumber: data["phone"] ?? "",
      profilePicture: data["profilePicture"] ?? "",
      password: data["password"] ?? "",
    );
  }
}
