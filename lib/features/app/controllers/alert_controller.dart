import 'package:get/get.dart';
import 'package:voice/data/repositories/alert_repository.dart';
import 'package:voice/features/app/models/alert_model.dart';

class AlertController extends GetxController {
  static AlertController get instance => Get.find();
  final alertRepository = Get.put(AlertRepository());

  final RxList<AlertModel> alerts = <AlertModel>[].obs;
  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllAlerts();
  }

  Future<void> fetchAllAlerts() async {
    try {
      loading.value = true;
      final alerts = await alertRepository.fetchAllAlerts();
      this.alerts.value = alerts;
    } catch (e) {
      alerts.value = [];
    } finally {
      loading.value = false;
    }
  }
}
