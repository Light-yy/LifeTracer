import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/dashboard_provider.dart';
import '../../providers/sleep_provider.dart';
import '../../providers/task_provider.dart';
import '../../providers/weight_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final weightProvider = context.watch<WeightProvider>();
    final sleepProvider = context.watch<SleepProvider>();
    final dashboard = context.watch<DashboardProvider>();
    final feedback = dashboard.smartFeedback();

    return SafeArea(
      child: ListView(
        key: const ValueKey('dashboard'),
        padding: const EdgeInsets.all(16),
        children: [
          Text('Life Discipline Tracker', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Today Summary'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    children: [
                      _metric('Tasks', '${(taskProvider.completionPercent * 100).toStringAsFixed(0)}%'),
                      _metric('Weight', weightProvider.latest?.weightKg.toStringAsFixed(1) ?? '--'),
                      _metric('Avg Sleep', '${sleepProvider.weeklyAverage().toStringAsFixed(1)} h'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Weekly Task Progress'),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 180,
                    child: LineChart(
                      LineChartData(
                        minY: 0,
                        maxY: 1,
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            spots: taskProvider
                                .last7DaysCompletionSeries()
                                .asMap()
                                .entries
                                .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                                .toList(),
                            color: Theme.of(context).colorScheme.primary,
                            dotData: const FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (feedback.isNotEmpty)
            ...feedback.map(
              (msg) => Card(
                color: Colors.orange.withOpacity(0.12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(msg),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _metric(String label, String value) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        ],
      ),
    );
  }
}
