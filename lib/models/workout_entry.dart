import 'package:hive/hive.dart';

class WorkoutEntry {
  WorkoutEntry({
    required this.exerciseName,
    required this.sets,
    required this.reps,
    required this.date,
  });

  final String exerciseName;
  final int sets;
  final int reps;
  final DateTime date;
}

class WorkoutEntryAdapter extends TypeAdapter<WorkoutEntry> {
  @override
  final typeId = 3;

  @override
  WorkoutEntry read(BinaryReader reader) {
    final map = Map<String, dynamic>.from(reader.readMap());
    return WorkoutEntry(
      exerciseName: map['exerciseName'] as String,
      sets: map['sets'] as int,
      reps: map['reps'] as int,
      date: DateTime.parse(map['date'] as String),
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutEntry obj) {
    writer.writeMap({
      'exerciseName': obj.exerciseName,
      'sets': obj.sets,
      'reps': obj.reps,
      'date': obj.date.toIso8601String(),
    });
  }
}
