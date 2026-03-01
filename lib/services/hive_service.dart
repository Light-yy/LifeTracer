import 'package:hive_flutter/hive_flutter.dart';

import '../models/nutrition_entry.dart';
import '../models/sleep_entry.dart';
import '../models/task_item.dart';
import '../models/weight_entry.dart';
import '../models/workout_entry.dart';

class HiveService {
  static const String taskBoxName = 'tasks';
  static const String weightBoxName = 'weight';
  static const String sleepBoxName = 'sleep';
  static const String workoutBoxName = 'workout';
  static const String nutritionBoxName = 'nutrition';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive
      ..registerAdapter(TaskItemAdapter())
      ..registerAdapter(WeightEntryAdapter())
      ..registerAdapter(SleepEntryAdapter())
      ..registerAdapter(WorkoutEntryAdapter())
      ..registerAdapter(NutritionEntryAdapter());

    await Future.wait([
      Hive.openBox<TaskItem>(taskBoxName),
      Hive.openBox<WeightEntry>(weightBoxName),
      Hive.openBox<SleepEntry>(sleepBoxName),
      Hive.openBox<WorkoutEntry>(workoutBoxName),
      Hive.openBox<NutritionEntry>(nutritionBoxName),
    ]);
  }
}
