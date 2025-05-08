import 'dart:convert';

class History {
  final int? id;
  final String imagePath;
  final String modelName;
  final List<Map<String, dynamic>> prediction;
  String label;
  bool? isIdentified;

  History({
    this.id,
    required this.imagePath,
    required this.prediction,
    required this.modelName,
    this.label = "Unknown",
    this.isIdentified = false,
  });

  /// Buat dari Map (biasanya dari database)
  factory History.fromMap(Map<String, dynamic> map) {
    return History(
      id: map['id'],
      imagePath: map['image_path'],
      modelName: map['model_name'],
      prediction: List<Map<String, dynamic>>.from(
        jsonDecode(map['prediction']).map(
          (item) => Map<String, dynamic>.from(item),
        ),
      ),
      label: map['label'] ?? "Unknown",
      isIdentified: map['is_identified'] == 0 ? false : true,
    );
  }

  /// Simpan ke Map (untuk database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image_path': imagePath,
      'model_name': modelName,
      'prediction': jsonEncode(prediction),
      'label': label,
      'is_identified': isIdentified! ? 1 : 0,
    };
  }

  /// Buat dari output hasil klasifikasi
  static History fromPredictionOutput(
    String imagePath,
    String modelName,
    List<Map<String, dynamic>> predictionOutput, {
    String? label,
    bool? isIdentified,
  }) {
    final List<Map<String, dynamic>> predictionList = [];

    for (int i = 0; i < predictionOutput.length && i < 5; i++) {
      predictionList.add({
        'labelIndex': predictionOutput[i]['labelIndex'],
        'label': predictionOutput[i]['label'],
        'confidence': ((predictionOutput[i]['confidence'] as double) * 100)
            .toStringAsFixed(2),
      });
    }

    return History(
      imagePath: imagePath,
      modelName: modelName,
      prediction: predictionList,
      label: label ?? "Unknown",
      isIdentified: isIdentified ?? false
    );
  }
}
