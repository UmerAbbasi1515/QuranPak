import 'package:get/get.dart';

class QuranDashboardTabsController extends GetxController {
  RxInt selectedIndex = 0.obs;
  @override
  void onInit() {
    // Get.lazyPut(() => TenantDashboardGetDataController());
    // Get.lazyPut(() => GetTenantNotificationsController());
    // Get.lazyPut(() => GetContractsController());
    // Get.lazyPut(() => TenantPaymentsController());
    super.onInit();
  }

  void setIndex(int index) {
    selectedIndex.value = index;
  }
}
