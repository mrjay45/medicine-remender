import 'package:get/get.dart';
import 'package:lc_corparate/app/routes/app_routes.dart';
import 'package:lc_corparate/modules/add_medicine/views/add_medicine_view.dart';
import 'package:lc_corparate/modules/home/views/home_view.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeView(),
    ),
    GetPage(
      name: AppRoutes.ADD_MEDICINE,
      page: () => const AddMedicineView(),
      transition: Transition.rightToLeft,
    ),
  ];
}
