class PharmacyResponseModel {
  final String pharmacyName;
  final String status;
  final String? message;

  PharmacyResponseModel({
    required this.pharmacyName,
    required this.status,
    this.message,
  });
}