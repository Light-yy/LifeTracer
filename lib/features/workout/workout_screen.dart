import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/workout_provider.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkoutProvider>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Workout Tracker')),
        body: ListView(
          key: const ValueKey('workout'),
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: ListTile(
                title: const Text('Weekly total workouts'),
                subtitle: Text('${provider.weeklyTotal()} sessions'),
              ),
            ),
            ...provider.entries.reversed.take(20).map(
                  (e) => Card(
                    child: ListTile(
                      title: Text(e.exerciseName),
                      subtitle: Text('${e.sets} sets × ${e.reps} reps'),
                    ),
                  ),
                ),
            FilledButton.icon(
              onPressed: () => _addWorkout(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Workout'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addWorkout(BuildContext context) async {
    final nameC = TextEditingController();
    final setsC = TextEditingController();
    final repsC = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Exercise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameC, decoration: const InputDecoration(labelText: 'Exercise name')),
            const SizedBox(height: 8),
            TextField(controller: setsC, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Sets')),
            const SizedBox(height: 8),
            TextField(controller: repsC, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Reps')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              final sets = int.tryParse(setsC.text);
              final reps = int.tryParse(repsC.text);
              if (nameC.text.trim().isEmpty || sets == null || reps == null) return;
              await context.read<WorkoutProvider>().add(name: nameC.text.trim(), sets: sets, reps: reps);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
