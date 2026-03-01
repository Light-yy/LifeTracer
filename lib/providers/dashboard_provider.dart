import 'package:flutter/foundation.dart';

import 'nutrition_provider.dart';
import 'sleep_provider.dart';
import 'task_provider.dart';
import 'weight_provider.dart';
import 'workout_provider.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardProvider({
    required this.tasks,
    required this.weight,
    required this.sleep,
    required this.workout,
    required this.nutrition,
  });

  final TaskProvider tasks;
  final WeightProvider weight;
  final SleepProvider sleep;
  final WorkoutProvider workout;
  final NutritionProvider nutrition;

  List<String> smartFeedback() {
    final feedback = <String>[];

    if (workout.noWorkoutFor3Days()) {
      feedback.add('Discipline Alert: No workout logged for 3 days.');
    }
    if (sleep.below6For3Days()) {
      feedback.add('Recovery Warning: Sleep below 6h for 3 days.');
    }
    if (weight.isStagnant14Days()) {
      feedback.add('Increase calories: Weight has stagnated for 14 days.');
    }
    if (tasks.weeklyCompletionPercent() < 0.7 && tasks.tasks.isNotEmpty) {
      feedback.add('Motivation: Weekly task completion is below 70%. Keep pushing.');
    }
    if (sleep.averageBelow7()) {
      feedback.add('Sleep Insight: Weekly sleep average is below 7h.');
    }
    if (nutrition.caloriesTooLowForGain()) {
      feedback.add('Nutrition Tip: Increase daily calories for lean mass gain.');
    }

    return feedback;
  }
}
