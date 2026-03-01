import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../core/date_utils.dart';
import '../models/task_item.dart';
import '../services/hive_service.dart';

class TaskProvider extends ChangeNotifier {
  final Box<TaskItem> _box = Hive.box<TaskItem>(HiveService.taskBoxName);
  List<TaskItem> _tasks = [];

  List<TaskItem> get tasks => _tasks;
  List<TaskItem> get todayTasks =>
      _tasks.where((task) => AppDateUtils.isSameDay(task.date, DateTime.now())).toList();

  void loadTasks() {
    _tasks = _box.values.toList()..sort((a, b) => a.time.compareTo(b.time));
    _autoResetTasks();
    notifyListeners();
  }

  Future<void> addTask({required String title, required String time}) async {
    final task = TaskItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      time: time,
      isCompleted: false,
      date: AppDateUtils.dateOnly(DateTime.now()),
    );
    await _box.put(task.id, task);
    loadTasks();
  }

  Future<void> toggleTask(TaskItem task) async {
    await _box.put(
      task.id,
      task.copyWith(isCompleted: !task.isCompleted),
    );
    loadTasks();
  }

  Future<void> deleteTask(String id) async {
    await _box.delete(id);
    loadTasks();
  }

  double get completionPercent {
    final today = todayTasks;
    if (today.isEmpty) return 0;
    final done = today.where((task) => task.isCompleted).length;
    return done / today.length;
  }

  double weeklyCompletionPercent() {
    final start = AppDateUtils.dateOnly(DateTime.now().subtract(const Duration(days: 6)));
    final weekTasks = _tasks.where((task) => !task.date.isBefore(start)).toList();
    if (weekTasks.isEmpty) return 0;
    final done = weekTasks.where((task) => task.isCompleted).length;
    return done / weekTasks.length;
  }

  List<double> last7DaysCompletionSeries() {
    return List.generate(7, (index) {
      final date = AppDateUtils.dateOnly(DateTime.now().subtract(Duration(days: 6 - index)));
      final dayTasks = _tasks.where((task) => AppDateUtils.isSameDay(task.date, date)).toList();
      if (dayTasks.isEmpty) return 0;
      final done = dayTasks.where((task) => task.isCompleted).length;
      return done / dayTasks.length;
    });
  }

  void _autoResetTasks() {
    final today = AppDateUtils.dateOnly(DateTime.now());
    final bool hasTodayTask = _tasks.any((task) => AppDateUtils.isSameDay(task.date, today));
    if (hasTodayTask) return;

    final latestDate = _tasks.map((task) => task.date).fold<DateTime?>(
      null,
      (prev, date) => prev == null || date.isAfter(prev) ? date : prev,
    );
    if (latestDate == null) return;

    final latestTasks = _tasks.where((task) => AppDateUtils.isSameDay(task.date, latestDate)).toList();
    for (final task in latestTasks) {
      final reset = task.copyWith(
        id: '${task.id}-r-${today.millisecondsSinceEpoch}',
        isCompleted: false,
        date: today,
      );
      _box.put(reset.id, reset);
    }
    _tasks = _box.values.toList();
  }
}
