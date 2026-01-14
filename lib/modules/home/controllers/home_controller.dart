import 'package:get/get.dart';
import 'package:lc_corparate/app/data/local/medicine_storage.dart';
import 'package:lc_corparate/app/data/models/medicine_model.dart';
import 'package:lc_corparate/app/services/notification_service.dart';

class HomeController extends GetxController {
  final MedicineStorage _storage = MedicineStorage();
  final NotificationService _notificationService = NotificationService();
  final RxList<MedicineModel> medicines = <MedicineModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMedicines();
  }

  // Load all medicines from storage
  Future<void> loadMedicines() async {
    isLoading.value = true;
    try {
      final medicineList = await _storage.getMedicines();
      medicines.value =
          medicineList.map((json) => MedicineModel.fromJson(json)).toList();

      // Sort medicines by time (earliest first)
      medicines.sort((a, b) {
        final timeA = _parseTimeToMinutes(a.time ?? '');
        final timeB = _parseTimeToMinutes(b.time ?? '');
        return timeA.compareTo(timeB);
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to load medicines');
    } finally {
      isLoading.value = false;
    }
  }

  // Convert time string to minutes for comparison
  int _parseTimeToMinutes(String time) {
    if (time.isEmpty) return 9999; // Put empty times at the end

    try {
      final RegExp timeRegex =
          RegExp(r'(\d{1,2}):(\d{2})\s*(AM|PM)', caseSensitive: false);
      final match = timeRegex.firstMatch(time);

      if (match != null) {
        int hour = int.parse(match.group(1)!);
        final minute = int.parse(match.group(2)!);
        final period = match.group(3)!.toUpperCase();

        if (period == 'PM' && hour != 12) {
          hour += 12;
        } else if (period == 'AM' && hour == 12) {
          hour = 0;
        }

        return hour * 60 + minute;
      }
    } catch (e) {
      return 9999;
    }
    return 9999;
  }

  // Delete a medicine by index
  Future<void> deleteMedicine(int index) async {
    try {
      await _storage.deleteMedicine(index);
      await _notificationService.cancelNotification(index);
      await loadMedicines();
      Get.snackbar(
        'Success',
        'Medicine deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete medicine');
    }
  }

  // Clear all medicines
  Future<void> clearAllMedicines() async {
    try {
      await _storage.clearMedicines();
      medicines.clear();
      Get.snackbar(
        'Success',
        'All medicines cleared',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to clear medicines');
    }
  }
}
