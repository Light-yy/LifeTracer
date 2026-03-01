import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/sleep_provider.dart';

class SleepScreen extends StatelessWidget {
  const SleepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SleepProvider>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Sleep Tracker')),
        body: ListView(
          key: const ValueKey('sleep'),
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: ListTile(
                title: const Text('Weekly average sleep'),
                subtitle: Text('${provider.weeklyAverage().toStringAsFixed(1)} hours'),
                trailing: provider.averageBelow7() ? const Icon(Icons.warning, color: Colors.orange) : null,
              ),
            ),
            if (provider.averageBelow7())
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Warning: Average sleep is below 7 hours this week.'),
                ),
              ),
            FilledButton.icon(
              onPressed: () => _addSleep(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Sleep Hours'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addSleep(BuildContext context) async {
    final c = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Sleep Hours'),
        content: TextField(controller: c, keyboardType: TextInputType.number),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              final value = double.tryParse(c.text);
              if (value == null) return;
              await context.read<SleepProvider>().add(value);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
