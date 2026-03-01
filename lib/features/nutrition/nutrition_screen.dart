import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/nutrition_provider.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NutritionProvider>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Nutrition Tracker')),
        body: ListView(
          key: const ValueKey('nutrition'),
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: ListTile(
                title: const Text('Daily avg calories'),
                subtitle: Text(provider.dailyAverageCalories().toStringAsFixed(0)),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Weekly avg calories'),
                subtitle: Text(provider.weeklyAverageCalories().toStringAsFixed(0)),
              ),
            ),
            if (provider.caloriesTooLowForGain())
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Suggestion: Calories are low for weight gain. Increase intake.'),
                ),
              ),
            ...provider.entries.reversed.take(20).map(
                  (e) => Card(
                    child: ListTile(
                      title: Text('${e.calories} kcal'),
                      subtitle: Text('Protein: ${e.protein} g'),
                    ),
                  ),
                ),
            FilledButton.icon(
              onPressed: () => _addNutrition(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Nutrition'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addNutrition(BuildContext context) async {
    final calC = TextEditingController();
    final proteinC = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Nutrition'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: calC, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Calories')),
            const SizedBox(height: 8),
            TextField(controller: proteinC, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Protein (g)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              final calories = int.tryParse(calC.text);
              final protein = int.tryParse(proteinC.text);
              if (calories == null || protein == null) return;
              await context.read<NutritionProvider>().add(calories: calories, protein: protein);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
