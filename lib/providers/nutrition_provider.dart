import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../models/nutrition_entry.dart';
import '../services/hive_service.dart';

class NutritionProvider extends ChangeNotifier {
  final Box<NutritionEntry> _box = Hive.box<NutritionEntry>(HiveService.nutritionBoxName);
  List<NutritionEntry> _entries = [];

  List<NutritionEntry> get entries => _entries;

  void load() {
    _entries = _box.values.toList()..sort((a, b) => a.date.compareTo(b.date));
    notifyListeners();
  }

  Future<void> add({required int calories, required int protein}) async {
    final entry = NutritionEntry(calories: calories, protein: protein, date: DateTime.now());
    await _box.put(entry.date.toIso8601String(), entry);
    load();
  }

  double dailyAverageCalories() {
    if (_entries.isEmpty) return 0;
    final latestDay = DateTime(_entries.last.date.year, _entries.last.date.month, _entries.last.date.day);
    final sameDay = _entries.where((e) {
      final d = DateTime(e.date.year, e.date.month, e.date.day);
      return d == latestDay;
    }).toList();
    if (sameDay.isEmpty) return 0;
    return sameDay.fold<int>(0, (sum, e) => sum + e.calories) / sameDay.length;
  }

  double weeklyAverageCalories() {
    final start = DateTime.now().subtract(const Duration(days: 6));
    final week = _entries.where((e) => !e.date.isBefore(start)).toList();
    if (week.isEmpty) return 0;
    return week.fold<int>(0, (sum, e) => sum + e.calories) / week.length;
  }

  bool caloriesTooLowForGain() => weeklyAverageCalories() > 0 && weeklyAverageCalories() < 2600;
}
