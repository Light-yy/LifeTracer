import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/weight_provider.dart';

class WeightScreen extends StatelessWidget {
  const WeightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeightProvider>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Weight Tracker')),
        body: ListView(
          key: const ValueKey('weight'),
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: ListTile(
                title: const Text('Weekly average'),
                subtitle: Text('${provider.weeklyAverage().toStringAsFixed(1)} kg'),
                trailing: provider.isStagnant14Days()
                    ? const Icon(Icons.warning_amber_rounded, color: Colors.orange)
                    : null,
              ),
            ),
            Card(
              child: SizedBox(
                height: 220,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          isCurved: true,
                          color: Theme.of(context).colorScheme.secondary,
                          spots: provider.entries
                              .asMap()
                              .entries
                              .map((e) => FlSpot(e.key.toDouble(), e.value.weightKg))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            FilledButton.icon(
              onPressed: () => _addWeight(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Weight'),
            ),
            if (provider.isStagnant14Days())
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text('Alert: Weight did not increase in 14 days. Increase calories.'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _addWeight(BuildContext context) async {
    final c = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Weight (kg)'),
        content: TextField(controller: c, keyboardType: TextInputType.number),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              final value = double.tryParse(c.text);
              if (value == null) return;
              await context.read<WeightProvider>().add(value);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
