import 'package:hive/hive.dart';

class WeightEntry {
  WeightEntry({required this.weightKg, required this.date});

  final double weightKg;
  final DateTime date;
}

class WeightEntryAdapter extends TypeAdapter<WeightEntry> {
  @override
  final typeId = 1;

  @override
  WeightEntry read(BinaryReader reader) {
    final map = Map<String, dynamic>.from(reader.readMap());
    return WeightEntry(
      weightKg: (map['weightKg'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
    );
  }

  @override
  void write(BinaryWriter writer, WeightEntry obj) {
    writer.writeMap({
      'weightKg': obj.weightKg,
      'date': obj.date.toIso8601String(),
    });
  }
}
