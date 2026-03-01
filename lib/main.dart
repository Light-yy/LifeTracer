import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_theme.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/nutrition/nutrition_screen.dart';
import 'features/sleep/sleep_screen.dart';
import 'features/tasks/tasks_screen.dart';
import 'features/weight/weight_screen.dart';
import 'features/workout/workout_screen.dart';
import 'providers/dashboard_provider.dart';
import 'providers/nutrition_provider.dart';
import 'providers/sleep_provider.dart';
import 'providers/task_provider.dart';
import 'providers/weight_provider.dart';
import 'providers/workout_provider.dart';
import 'services/hive_service.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  await NotificationService.instance.init();

  runApp(const LifeDisciplineTrackerApp());
}

class LifeDisciplineTrackerApp extends StatelessWidget {
  const LifeDisciplineTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()..loadTasks()),
        ChangeNotifierProvider(create: (_) => WeightProvider()..load()),
        ChangeNotifierProvider(create: (_) => SleepProvider()..load()),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()..load()),
        ChangeNotifierProvider(create: (_) => NutritionProvider()..load()),
        ProxyProvider5<TaskProvider, WeightProvider, SleepProvider, WorkoutProvider,
            NutritionProvider, DashboardProvider>(
          update: (_, t, w, s, wo, n, __) => DashboardProvider(
            tasks: t,
            weight: w,
            sleep: s,
            workout: wo,
            nutrition: n,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Life Discipline Tracker',
        theme: AppTheme.darkTheme,
        home: const MainShell(),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  final pages = const [
    DashboardScreen(),
    TasksScreen(),
    WeightScreen(),
    SleepScreen(),
    WorkoutScreen(),
    NutritionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        child: pages[index],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.check_circle_outline), label: 'Tasks'),
          NavigationDestination(icon: Icon(Icons.monitor_weight_outlined), label: 'Weight'),
          NavigationDestination(icon: Icon(Icons.bedtime_outlined), label: 'Sleep'),
          NavigationDestination(icon: Icon(Icons.fitness_center_outlined), label: 'Workout'),
          NavigationDestination(icon: Icon(Icons.restaurant_outlined), label: 'Nutrition'),
        ],
      ),
    );
  }
}
