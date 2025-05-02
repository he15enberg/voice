import 'package:get/get.dart';
import 'package:voice/features/authentication/screens/signup/signup.dart';
import '../features/authentication/screens/login/login.dart';
import '../routes/routes.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: TRoutes.signin, page: () => const LoginScreen()),
    GetPage(name: TRoutes.signup, page: () => const SignUpScreen()),
  ];
}
