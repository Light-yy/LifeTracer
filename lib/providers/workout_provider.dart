import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../models/workout_entry.dart';
import '../services/hive_service.dart';

class WorkoutProvider extends ChangeNotifier {
  final Box<WorkoutEntry> _box = Hive.box<WorkoutEntry>(HiveService.workoutBoxName);
  List<WorkoutEntry> _entries = [];

  List<WorkoutEntry> get entries => _entries;

  void load() {
    _entries = _box.values.toList()..sort((a, b) => a.date.compareTo(b.date));
    notifyListeners();
  }

  Future<void> add({required String name, required int sets, required int reps}) async {
    final entry = WorkoutEntry(
      exerciseName: name,
      sets: sets,
      reps: reps,
      date: DateTime.now(),
    );
    await _box.put(entry.date.toIso8601String(), entry);
    load();
  }

  int weeklyTotal() {
    final start = DateTime.now().subtract(const Duration(days: 6));
    return _entries.where((e) => !e.date.isBefore(start)).length;
  }

  bool noWorkoutFor3Days() {
    if (_entries.isEmpty) return true;
    final last = _entries.last.date;
    return DateTime.now().difference(last).inDays >= 3;
  }
}
