import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task.dart';

class StorageService {
  static const String _counterKey = 'counter_value';
  static const String _tasksKey = 'tasks_list';

  SharedPreferences? _prefs;

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Counter methods
  Future<int> getCounter() async {
    if (_prefs == null) await init();
    return _prefs?.getInt(_counterKey) ?? 0;
  }

  Future<void> saveCounter(int value) async {
    if (_prefs == null) await init();
    await _prefs?.setInt(_counterKey, value);
  }

  // Tasks methods
  Future<List<Task>> getTasks() async {
    if (_prefs == null) await init();
    final String? tasksJson = _prefs?.getString(_tasksKey);
    if (tasksJson == null) return [];

    final List<dynamic> decodedList = json.decode(tasksJson);
    return decodedList.map((json) => Task.fromJson(json)).toList();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    if (_prefs == null) await init();
    final String tasksJson = json.encode(
        tasks.map((task) => task.toJson()).toList()
    );
    await _prefs?.setString(_tasksKey, tasksJson);
  }

  // Clear all data
  Future<void> clearAllData() async {
    if (_prefs == null) await init();
    await _prefs?.remove(_counterKey);
    await _prefs?.remove(_tasksKey);
  }
}