import 'package:get/get.dart';
import 'package:holy_quran/quran_dashboard/home/home_contoller.dart';

class QuranDashboardTabsController extends GetxController {
  RxInt selectedIndex = 0.obs;
  @override
  void onInit() {
    Get.lazyPut(() => HomeController());
    // Get.lazyPut(() => GetTenantNotificationsController());
    // Get.lazyPut(() => GetContractsController());
    // Get.lazyPut(() => TenantPaymentsController());
    super.onInit();
  }

  void setIndex(int index) {
    selectedIndex.value = index;
  }
}
