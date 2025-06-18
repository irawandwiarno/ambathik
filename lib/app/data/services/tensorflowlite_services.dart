import 'dart:typed_data';
import 'package:ambathik/app/data/services/preference_service.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper_plus/tflite_flutter_helper_plus.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math' as math;

class TensorflowLiteServices {
  // Singleton: private static instance
  static final TensorflowLiteServices _instance =
      TensorflowLiteServices._internal();

  // Private constructor
  TensorflowLiteServices._internal();

  // Factory constructor
  factory TensorflowLiteServices() => _instance;

  Interpreter? _interpreter;
  late List<String> _labels;
  String? _currentModel;
  String? modelName;

  static const List<String> defaultLabels = [
    'gajah oling',
    'gastro rinonce',
    'jagung miji emas',
    'koi',
    'lengko',
    'lokcan',
    'pace',
    'pring sedapur',
    'sekar jati',
    'serat kayu',
    'tumpal'
  ];

  Future<bool> loadModel(String modelPath,
      {List<String>? labels, String? modelName}) async {
    try {
      // Release previous model if any
      _interpreter?.close();
      _interpreter = await Interpreter.fromAsset(modelPath);
      _labels = labels ?? defaultLabels;
      _currentModel = modelPath;
      this.modelName = modelName;
      print('berhasil $modelPath');
      return true; // Berhasil load
    } catch (e) {
      print('Error loading model: $e');
      _interpreter = null;
      return false; // Gagal load
    }
  }

  Future<List<Map<String, dynamic>>> runOnImage(XFile imageFile) async {
    if (_interpreter == null) throw Exception('Model not loaded');

    // Ambil model info
    final savedModelInfo = await PreferenceService.getModelInfo();
    final modelLabel = savedModelInfo?.label;

    // Decode image
    final bytes = await imageFile.readAsBytes();
    final oriImg = img.decodeImage(bytes);
    if (oriImg == null) throw Exception('Image cannot be decoded');

    const inputSize = 512;
    final resized = img.copyResize(oriImg, width: inputSize, height: inputSize);

    // Preprocessing sesuai model
    final inputList = (modelLabel == 'InceptionV3')
        ? _preprocessInceptionV3(resized, inputSize)
        : _preprocessDefault(resized, inputSize);

    // Output buffer
    final outputList = Float32List(_labels.length);

    // Run inference
    _interpreter!
        .run(inputList.buffer.asUint8List(), outputList.buffer.asUint8List());

    // Postprocessing predictions
    final probsSoftmax = _softmax(outputList.toList());
    final List<Map<String, dynamic>> predictions = List.generate(
      probsSoftmax.length,
      (i) => {
        'labelIndex': i,
        'label': _labels[i],
        'confidence': probsSoftmax[i],
      },
    );

    predictions.sort(
      (a, b) => ((b['confidence'] ?? 0) as double)
          .compareTo((a['confidence'] ?? 0) as double),
    );

    return predictions;
  }

// Preprocessing untuk InceptionV3 (tanpa grayscale, tanpa mean/std, hanya scaling [0,1])
  Float32List _preprocessInceptionV3(img.Image resized, int inputSize) {
    final inputList = Float32List(1 * 3 * inputSize * inputSize);
    int idx = 0;
    for (int c = 0; c < 3; c++) {
      for (int y = 0; y < inputSize; y++) {
        for (int x = 0; x < inputSize; x++) {
          final pixel = resized.getPixel(x, y);
          double val = 0.0;
          if (c == 0) val = img.getRed(pixel).toDouble();
          if (c == 1) val = img.getGreen(pixel).toDouble();
          if (c == 2) val = img.getBlue(pixel).toDouble();
          inputList[idx++] = val / 255.0; // scale to [0,1]
        }
      }
    }
    return inputList;
  }

// Preprocessing default: grayscale + mean/std normalisasi (ala ImageNet)
  Float32List _preprocessDefault(img.Image resized, int inputSize) {
    final bwImg = img.grayscale(resized);
    final inputList = Float32List(1 * 3 * inputSize * inputSize);
    final mean = [0.485, 0.456, 0.406];
    final std = [0.229, 0.224, 0.225];
    int idx = 0;
    for (int c = 0; c < 3; c++) {
      for (int y = 0; y < inputSize; y++) {
        for (int x = 0; x < inputSize; x++) {
          final gray = img.getRed(bwImg.getPixel(x, y));
          inputList[idx++] = ((gray / 255.0) - mean[c]) / std[c];
        }
      }
    }
    return inputList;
  }

  List<double> _softmax(List<double> x) {
    final max = x.reduce((a, b) => a > b ? a : b);
    final exp = x.map((xi) => math.exp(xi - max)).toList();
    final sumExp = exp.reduce((a, b) => a + b);
    return exp.map((e) => e / sumExp).toList();
  }

  void dispose() {
    _interpreter?.close();
  }
}
