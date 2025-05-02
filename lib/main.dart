import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:voice/data/repositories/authentication_repository.dart';
import 'app.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';

Future<void> main() async {
  //Widgets Binding
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  //Init Local Storage
  await GetStorage.init();
  //Init Payment Methods
  //Await Native Splash
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  //Initialise Firebase
  Get.put(AuthenticationRepository());
  //Initialize Authentication

  //Load all Material Design / Themes /Localizations / Bindings
  runApp(const App());
}
