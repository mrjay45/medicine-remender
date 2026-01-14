import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lc_corparate/app/data/local/medicine_storage.dart';
import 'package:lc_corparate/app/data/models/medicine_model.dart';
import 'package:lc_corparate/app/services/notification_service.dart';
import 'package:lc_corparate/modules/home/controllers/home_controller.dart';

class AddMedicineController extends GetxController {
  final MedicineStorage _storage = MedicineStorage();
  final NotificationService _notificationService = NotificationService();

  final medicineNameController = TextEditingController();
  final dosageController = TextEditingController();
  final timeController = TextEditingController();

  // Store the actual time values
  int? selectedHour;
  int? selectedMinute;

  final List<String> frequencies = [
    'Morning',
    'Afternoon',
    'Evening',
    'Night',
  ];

  final selectedFrequency = 'Morning'.obs;

  @override
  void onClose() {
    medicineNameController.dispose();
    dosageController.dispose();
    timeController.dispose();
    super.onClose();
  }

  // Select time method
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      selectedHour = picked.hour;
      selectedMinute = picked.minute;
      timeController.text = picked.format(context);
    }
  }

  // Update selected frequency
  void updateFrequency(String? newValue) {
    if (newValue != null) {
      selectedFrequency.value = newValue;
    }
  }

  // Save medicine
  Future<void> saveMedicine() async {
    if (medicineNameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter medicine name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (dosageController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter dosage',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (timeController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select time',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Create medicine model
    final medicine = MedicineModel(
      medicineName: medicineNameController.text,
      dosage: dosageController.text,
      time: timeController.text,
      frequency: selectedFrequency.value,
    );

    // Save to storage
    await _storage.saveMedicine(medicine.toJson());

    // Schedule daily notification using the actual time values
    if (selectedHour != null && selectedMinute != null) {
      final medicines = await _storage.getMedicines();
      final notificationId = medicines.length;

      try {
        await _notificationService.scheduleDailyNotification(
          id: notificationId,
          title: 'Time to take your medicine!',
          body: '${medicine.medicineName} - ${medicine.dosage}',
          hour: selectedHour!,
          minute: selectedMinute!,
        );
      } catch (e) {
        Get.snackbar(
          'Warning',
          'Medicine saved but reminder failed to schedule',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }

    // Update home controller if it exists
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().loadMedicines();
    }

    Get.snackbar(
      'Success',
      'Medicine and reminder added successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Clear fields
    medicineNameController.clear();
    dosageController.clear();
    timeController.clear();
    selectedHour = null;
    selectedMinute = null;
    selectedFrequency.value = 'Morning';

    // Navigate back
    Get.back();
  }

  void cancel() {
    Get.back();
  }
}
