import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../models/weight_entry.dart';
import '../services/hive_service.dart';

class WeightProvider extends ChangeNotifier {
  final Box<WeightEntry> _box = Hive.box<WeightEntry>(HiveService.weightBoxName);
  List<WeightEntry> _entries = [];

  List<WeightEntry> get entries => _entries;
  WeightEntry? get latest => _entries.isEmpty ? null : _entries.last;

  void load() {
    _entries = _box.values.toList()..sort((a, b) => a.date.compareTo(b.date));
    notifyListeners();
  }

  Future<void> add(double weightKg) async {
    final entry = WeightEntry(weightKg: weightKg, date: DateTime.now());
    await _box.put(entry.date.toIso8601String(), entry);
    load();
  }

  double weeklyAverage() {
    final start = DateTime.now().subtract(const Duration(days: 6));
    final week = _entries.where((e) => !e.date.isBefore(start)).toList();
    if (week.isEmpty) return 0;
    return week.fold<double>(0, (sum, e) => sum + e.weightKg) / week.length;
  }

  bool isStagnant14Days() {
    final start = DateTime.now().subtract(const Duration(days: 14));
    final range = _entries.where((e) => !e.date.isBefore(start)).toList();
    if (range.length < 2) return false;
    final minW = range.map((e) => e.weightKg).reduce((a, b) => a < b ? a : b);
    final maxW = range.map((e) => e.weightKg).reduce((a, b) => a > b ? a : b);
    return (maxW - minW) < 0.3;
  }
}
