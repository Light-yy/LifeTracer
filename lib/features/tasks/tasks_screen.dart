import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/task_provider.dart';
import '../../services/notification_service.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Daily Tasks')),
        body: ListView(
          key: const ValueKey('tasks'),
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Completion: ${(provider.completionPercent * 100).toStringAsFixed(0)}%',
                ),
              ),
            ),
            ...provider.todayTasks.map(
              (task) => Card(
                child: ListTile(
                  title: Text(task.title),
                  subtitle: Text('Time: ${task.time}'),
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) => provider.toggleTask(task),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => provider.deleteTask(task.id),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => _addTaskDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Task'),
            ),
            const SizedBox(height: 16),
            const Text('Reminders'),
            Wrap(
              spacing: 8,
              children: [
                _reminderButton(context, id: 1, label: 'Workout', body: 'Time to train and build discipline.'),
                _reminderButton(context, id: 2, label: 'Sleep', body: 'Start winding down for sleep recovery.'),
                _reminderButton(context, id: 3, label: 'Eating', body: 'Eat enough calories and protein today.'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _reminderButton(
    BuildContext context, {
    required int id,
    required String label,
    required String body,
  }) {
    return ActionChip(
      label: Text('$label Time'),
      onPressed: () async {
        final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
        if (time == null || !context.mounted) return;
        await NotificationService.instance.scheduleDailyReminder(
          id: id,
          title: '$label Reminder',
          body: body,
          time: time,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label reminder set at ${time.format(context)}')),
        );
      },
    );
  }

  Future<void> _addTaskDialog(BuildContext context) async {
    final titleController = TextEditingController();
    TimeOfDay? picked;

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Daily Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Task title'),
            ),
            const SizedBox(height: 8),
            StatefulBuilder(
              builder: (_, setState) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(picked == null ? 'Pick time' : DateFormat('hh:mm a').format(
                    DateTime(0, 1, 1, picked!.hour, picked!.minute))),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final result = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                  if (result != null) {
                    setState(() => picked = result);
                  }
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              if (titleController.text.trim().isEmpty || picked == null) return;
              await context.read<TaskProvider>().addTask(
                    title: titleController.text.trim(),
                    time: DateFormat('hh:mm a').format(
                      DateTime(0, 1, 1, picked!.hour, picked!.minute),
                    ),
                  );
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
