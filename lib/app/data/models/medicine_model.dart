class MedicineModel{
  String? medicineName;
  String? dosage;
  String? time;
  String? frequency;

  MedicineModel({this.medicineName, this.dosage, this.time, this.frequency});

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      medicineName: json['medicineName'],
      dosage: json['dosage'],
      time: json['time'],
      frequency: json['frequency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicineName': medicineName,
      'dosage': dosage,
      'time': time,
      'frequency': frequency,
    };
  }
}