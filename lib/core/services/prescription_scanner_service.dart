import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../../models/medicine_model.dart';

class PrescriptionScannerService {

  static Future<List<MedicineModel>> scanPrescription(
      File imageFile) async {

    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer();

    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    await textRecognizer.close();

    final lines = recognizedText.text.split('\n');

    List<MedicineModel> medicines = [];

    for (var line in lines) {
      if (line.trim().isEmpty) continue;

      if (_looksLikeMedicine(line)) {
        medicines.add(
          MedicineModel(
            name: line.trim(),
            dosage: _extractDosage(line),
          ),
        );
      }
    }

    return medicines;
  }

  static bool _looksLikeMedicine(String text) {
    final keywords = ["mg", "tablet", "cap", "ml"];
    return keywords.any(
      (k) => text.toLowerCase().contains(k),
    );
  }

  static String _extractDosage(String text) {
    final regex = RegExp(r'\d+\s?(mg|ml)');
    final match = regex.firstMatch(text);
    return match?.group(0) ?? "";
  }
}