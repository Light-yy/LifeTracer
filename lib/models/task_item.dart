import 'package:hive/hive.dart';

class TaskItem {
  TaskItem({
    required this.id,
    required this.title,
    required this.time,
    required this.isCompleted,
    required this.date,
  });

  final String id;
  final String title;
  final String time;
  final bool isCompleted;
  final DateTime date;

  TaskItem copyWith({
    String? id,
    String? title,
    String? time,
    bool? isCompleted,
    DateTime? date,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
    );
  }
}

class TaskItemAdapter extends TypeAdapter<TaskItem> {
  @override
  final typeId = 0;

  @override
  TaskItem read(BinaryReader reader) {
    final map = Map<String, dynamic>.from(reader.readMap());
    return TaskItem(
      id: map['id'] as String,
      title: map['title'] as String,
      time: map['time'] as String,
      isCompleted: map['isCompleted'] as bool,
      date: DateTime.parse(map['date'] as String),
    );
  }

  @override
  void write(BinaryWriter writer, TaskItem obj) {
    writer.writeMap({
      'id': obj.id,
      'title': obj.title,
      'time': obj.time,
      'isCompleted': obj.isCompleted,
      'date': obj.date.toIso8601String(),
    });
  }
}
