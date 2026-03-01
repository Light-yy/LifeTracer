import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../models/sleep_entry.dart';
import '../services/hive_service.dart';

class SleepProvider extends ChangeNotifier {
  final Box<SleepEntry> _box = Hive.box<SleepEntry>(HiveService.sleepBoxName);
  List<SleepEntry> _entries = [];

  List<SleepEntry> get entries => _entries;

  void load() {
    _entries = _box.values.toList()..sort((a, b) => a.date.compareTo(b.date));
    notifyListeners();
  }

  Future<void> add(double hours) async {
    final entry = SleepEntry(hours: hours, date: DateTime.now());
    await _box.put(entry.date.toIso8601String(), entry);
    load();
  }

  double weeklyAverage() {
    final start = DateTime.now().subtract(const Duration(days: 6));
    final week = _entries.where((e) => !e.date.isBefore(start)).toList();
    if (week.isEmpty) return 0;
    return week.fold<double>(0, (sum, e) => sum + e.hours) / week.length;
  }

  bool averageBelow7() => weeklyAverage() < 7 && entries.isNotEmpty;

  bool below6For3Days() {
    final last3 = _entries.reversed.take(3).toList();
    return last3.length == 3 && last3.every((e) => e.hours < 6);
  }
}
