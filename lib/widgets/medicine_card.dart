import 'package:flutter/material.dart';

class MedicineCard extends StatelessWidget {
  const MedicineCard(
      {super.key,
      required this.medicineName,
      this.dosage,
      required this.time,
      required this.instructions});

  final String medicineName;
  final String? dosage;
  final String time;
  final String instructions;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        minVerticalPadding: 20,
        title: Row(
          children: [
            Text(
              time,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                dosage != null && dosage!.isNotEmpty
                    ? '$medicineName $dosage'
                    : medicineName,
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        subtitle: Text(
          instructions,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        leading: const Icon(
          Icons.alarm,
          size: 48.0,
        ),
      ),
    );
  }
}
