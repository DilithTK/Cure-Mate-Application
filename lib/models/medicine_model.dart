class MedicineModel {
  final String name;
  final String? dosage;
  final String? frequency;
  String status; 

  MedicineModel({
    required this.name,
    this.dosage,
    this.frequency,
    this.status = 'pending', 
  });

  factory MedicineModel.fromMap(Map<String, dynamic> map) {
    return MedicineModel(
      name: map['name'] ?? '',
      dosage: map['dosage'],
      frequency: map['frequency'],
      status: map['status'] ?? 'pending', 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'status': status, 
    };
  }
}