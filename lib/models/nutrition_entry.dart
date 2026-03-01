import 'package:hive/hive.dart';

class NutritionEntry {
  NutritionEntry({
    required this.calories,
    required this.protein,
    required this.date,
  });

  final int calories;
  final int protein;
  final DateTime date;
}

class NutritionEntryAdapter extends TypeAdapter<NutritionEntry> {
  @override
  final typeId = 4;

  @override
  NutritionEntry read(BinaryReader reader) {
    final map = Map<String, dynamic>.from(reader.readMap());
    return NutritionEntry(
      calories: map['calories'] as int,
      protein: map['protein'] as int,
      date: DateTime.parse(map['date'] as String),
    );
  }

  @override
  void write(BinaryWriter writer, NutritionEntry obj) {
    writer.writeMap({
      'calories': obj.calories,
      'protein': obj.protein,
      'date': obj.date.toIso8601String(),
    });
  }
}
