import 'dart:convert';

import 'package:ambathik/app/data/models/save_model_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static const _modelKey = 'saved_model';

  static Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> saveModelInfo(SavedModelInfo model) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(model.toJson());
    await prefs.setString(_modelKey, jsonString);
  }

  static Future<SavedModelInfo?> getModelInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_modelKey);
    if (jsonString == null) return null;

    final jsonMap = jsonDecode(jsonString);
    return SavedModelInfo.fromJson(jsonMap);
  }

  static Future<void> clearModelInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_modelKey);
  }
}
