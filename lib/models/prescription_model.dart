import 'medicine_model.dart';

class PrescriptionModel {

  final String id;
  final String patientName;
  final String date;
  final String imageUrl;
  final String status;

  final List<MedicineModel> medicines;

  PrescriptionModel({
    required this.id,
    required this.patientName,
    required this.date,
    required this.imageUrl,
    required this.status,
    required this.medicines,
  });

  factory PrescriptionModel.fromFirestore(
    Map<String, dynamic> data,
    String id,
  ) {

    return PrescriptionModel(

      id: id,

      patientName:
          data['patientName'] ?? '',

      date:
          data['date'] ?? '',

      imageUrl:
          data['imageUrl'] ?? '',

      status:
          data['status'] ?? 'Pending',

      medicines:
          (data['medicines']
                  as List<dynamic>? ??
              [])
              .map(
                (e) => MedicineModel.fromMap(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toMap() {

    return {

      'patientName': patientName,

      'date': date,

      'imageUrl': imageUrl,

      'status': status,

      'medicines':
          medicines
              .map((e) => e.toMap())
              .toList(),
    };
  }
}