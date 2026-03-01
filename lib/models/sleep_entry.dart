import 'package:hive/hive.dart';

class SleepEntry {
  SleepEntry({required this.hours, required this.date});

  final double hours;
  final DateTime date;
}

class SleepEntryAdapter extends TypeAdapter<SleepEntry> {
  @override
  final typeId = 2;

  @override
  SleepEntry read(BinaryReader reader) {
    final map = Map<String, dynamic>.from(reader.readMap());
    return SleepEntry(
      hours: (map['hours'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
    );
  }

  @override
  void write(BinaryWriter writer, SleepEntry obj) {
    writer.writeMap({
      'hours': obj.hours,
      'date': obj.date.toIso8601String(),
    });
  }
}
