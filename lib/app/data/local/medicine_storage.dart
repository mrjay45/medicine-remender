import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MedicineStorage {
  static const String _keyMedicines = 'medicines';

    // Save medicine data
    Future<void> saveMedicine(Map<String, dynamic> medicine) async {
      final prefs = await SharedPreferences.getInstance();
      List<String> medicines = prefs.getStringList(_keyMedicines) ?? [];
      
      // Convert medicine map to JSON string
      medicines.add(jsonEncode(medicine));
      await prefs.setStringList(_keyMedicines, medicines);
    }

    // Get all medicines
    Future<List<Map<String, dynamic>>> getMedicines() async {
      final prefs = await SharedPreferences.getInstance();
      List<String> medicines = prefs.getStringList(_keyMedicines) ?? [];
      
      return medicines.map((item) => jsonDecode(item) as Map<String, dynamic>).toList();
    }

    // Delete a medicine by index
    Future<void> deleteMedicine(int index) async {
      final prefs = await SharedPreferences.getInstance();
      List<String> medicines = prefs.getStringList(_keyMedicines) ?? [];
      
      if (index >= 0 && index < medicines.length) {
        medicines.removeAt(index);
        await prefs.setStringList(_keyMedicines, medicines);
      }
    }

    // Clear all medicines
    Future<void> clearMedicines() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyMedicines);
    }
}