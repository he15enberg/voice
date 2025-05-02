import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:voice/features/app/models/alert_model.dart';
import 'package:voice/features/app/models/post_model.dart';
import 'package:voice/utils/exceptions/format_exceptions.dart';
import 'package:voice/utils/exceptions/platform_exceptions.dart';
import 'package:voice/utils/http/http_client.dart';
import 'package:voice/utils/logging/logger.dart';

class AlertRepository extends GetxController {
  static AlertRepository get instance => Get.find();

  Future<List<AlertModel>> fetchAllAlerts() async {
    try {
      final response = await THttpHelper.get("alert");
      final alertData = response["data"] as List<dynamic>;
      final alerts =
          alertData.map((alert) => AlertModel.fromJson(alert)).toList();
      return alerts;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      TLoggerHelper.error(e.toString());
      throw "Something went wrong. Please try again";
    }
  }
}
