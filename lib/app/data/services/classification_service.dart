import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class TFLiteService {
  Interpreter? _interpreter;
  String? _currentModel;
  List<String>? _labels;

  /// Memuat model TFLite dari asset
  Future<void> loadModel(String modelPath) async {
    await _unloadModel();
    try {
      _interpreter = await Interpreter.fromAsset(modelPath);
      _currentModel = modelPath;
      print('✅ Model loaded: $_currentModel');
    } catch (e) {
      print('❌ Error loading model: $e');
      rethrow;
    }
  }

  /// Muat label dari file (optional)
  Future<void> loadLabels(String labelPath) async {
    try {
      final raw = await rootBundle.loadString(labelPath);
      _labels = raw.split('\n').map((e) => e.trim()).toList();
      print('✅ Labels loaded: ${_labels!.length}');
    } catch (e) {
      print('❌ Error loading labels: $e');
    }
  }
  /// Ganti model
  Future<void> changeModel(String newModelPath) async {
    if (_currentModel != newModelPath) {
      await loadModel(newModelPath);
    } else {
      print('ℹ️ Model already loaded.');
    }
  }

  /// Klasifikasi gambar dan ambil top-5 prediksi
  Future<List<Map<String, dynamic>>> classifyImage(Image image) async {
    if (_interpreter == null) {
      throw Exception('No model loaded. Please load a model first.');
    }

    final input = [_preprocessImageCHW(image)]; // [1, 3, 224, 224]

    final outputShape = _interpreter!.getOutputTensor(0).shape;
    final numClasses = outputShape.last;
    final output = List.generate(1, (_) => List.filled(numClasses, 0.0));

    print("Shape of input tensor: ${_interpreter!.getInputTensor(0).shape}");
    _interpreter!.run(input, output);

    return _postprocessOutput(output[0]);
  }

  /// Preprocessing gambar ke format [3, 224, 224] (CHW)
  List<List<List<double>>> _preprocessImageCHW(Image? image,
      {int targetSize = 224, bool zeroCenter = false}) {
    if (image == null) throw Exception('Image is null');

    final resized = copyResize(image, width: targetSize, height: targetSize);

    final channelR = List.generate(targetSize, (_) => List.filled(targetSize, 0.0));
    final channelG = List.generate(targetSize, (_) => List.filled(targetSize, 0.0));
    final channelB = List.generate(targetSize, (_) => List.filled(targetSize, 0.0));

    for (int y = 0; y < targetSize; y++) {
      for (int x = 0; x < targetSize; x++) {
        final pixel = resized.getPixelSafe(x, y);
        channelR[y][x] = _normalize(getRed(pixel), zeroCenter: zeroCenter);
        channelG[y][x] = _normalize(getGreen(pixel), zeroCenter: zeroCenter);
        channelB[y][x] = _normalize(getBlue(pixel), zeroCenter: zeroCenter);
      }
    }

    return [channelR, channelG, channelB]; // [3, 224, 224]
  }

  /// Normalisasi nilai pixel
  double _normalize(int value, {bool zeroCenter = false}) {
    return zeroCenter ? (value - 127.5) / 127.5 : value / 255.0;
  }

  /// Ambil 5 output dengan confidence tertinggi
  List<Map<String, dynamic>> _postprocessOutput(List<double> output) {
    final indexed = output.asMap().entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return indexed.take(5).map((e) {
      return {
        'labelIndex': e.key,
        'label': _labels != null ? _labels![e.key] : 'Index ${e.key}',
        'confidence': e.value,
      };
    }).toList();
  }

  /// Bersihkan model
  Future<void> _unloadModel() async {
    if (_interpreter != null) {
      _interpreter!.close();
      print('🔄 Model unloaded: $_currentModel');
      _interpreter = null;
      _currentModel = null;
    }
  }

  Future<void> dispose() async {
    await _unloadModel();
  }

  /// Ubah gambar jadi hitam putih (thresholding), optional dipakai sebelum classifyImage
  img.Image preprocessToBlackWhiteRGB(img.Image inputImage, {int threshold = 128}) {
    const int IMAGE_SIZE = 224;
    final resized = img.copyResize(inputImage, width: IMAGE_SIZE, height: IMAGE_SIZE);

    for (int y = 0; y < resized.height; y++) {
      for (int x = 0; x < resized.width; x++) {
        final pixel = resized.getPixel(x, y);
        final r = img.getRed(pixel);
        final g = img.getGreen(pixel);
        final b = img.getBlue(pixel);

        final luminance = (0.299 * r + 0.587 * g + 0.114 * b).round();
        final isWhite = luminance >= threshold;
        final bwColor = isWhite ? 255 : 0;

        resized.setPixel(x, y, img.getColor(bwColor, bwColor, bwColor));
      }
    }

    return resized;
  }
}
