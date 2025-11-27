import 'package:flutter/material.dart';
import 'package:sonarfit_flutter/sonarfit_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SonarFit SDK
  // IMPORTANT: Replace with your actual API key from https://sonarfit.com/get-started
  await SonarFit.initialize('your-api-key-here');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SonarFit Flutter Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WorkoutHomePage(),
    );
  }
}

class WorkoutHomePage extends StatefulWidget {
  const WorkoutHomePage({super.key});

  @override
  State<WorkoutHomePage> createState() => _WorkoutHomePageState();
}

class _WorkoutHomePageState extends State<WorkoutHomePage> {
  WorkoutResult? _lastResult;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _workouts = [
    {
      'name': 'Squat (Apple Watch)',
      'emoji': '⌚',
      'type': WorkoutType.squat,
      'device': DeviceType.watch,
    },
    {
      'name': 'Squat (AirPods)',
      'emoji': '🎧',
      'type': WorkoutType.squat,
      'device': DeviceType.airpods,
    },
  ];

  Future<void> _startWorkout(WorkoutType type, DeviceType device) async {
    setState(() => _isLoading = true);

    try {
      final result = await SonarFit.presentWorkout(
        WorkoutConfig(
          workoutType: type,
          sets: 3,
          reps: 10,
          restTime: 60,
          countdownDuration: 3,
          autoReLift: true,
          deviceType: device,
        ),
      );

      setState(() {
        _lastResult = result;
        _isLoading = false;
      });

      if (result.completed) {
        _showCompletionDialog(result);
      }
    } on SonarFitException catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog(e);
    }
  }

  void _showCompletionDialog(WorkoutResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Workout Complete! 🎉'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reps: ${result.totalRepsCompleted}/${result.totalTargetReps}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Completion: ${(result.completionPercentage * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Sets:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              ...result.sets.map(
                (set) => Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Text('Set ${set.setNumber}: ${set.repsCompleted} reps'),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(SonarFitException error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(error.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('SonarFit Flutter Example'),
      ),
      body: Column(
        children: [
          // Last workout result card
          if (_lastResult != null)
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Last Workout',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              '${_lastResult!.totalRepsCompleted}',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            const Text('Reps Completed'),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '${(_lastResult!.completionPercentage * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const Text('Complete'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // Workout selection list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _workouts.length,
              itemBuilder: (context, index) {
                final workout = _workouts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Text(
                      workout['emoji'] as String,
                      style: const TextStyle(fontSize: 32),
                    ),
                    title: Text(
                      workout['name'] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text('3 sets × 10 reps'),
                    trailing: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.arrow_forward_ios),
                    onTap: _isLoading
                        ? null
                        : () => _startWorkout(
                              workout['type'] as WorkoutType,
                              workout['device'] as DeviceType,
                            ),
                  ),
                );
              },
            ),
          ),

          // Footer info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Powered by SonarFit SDK v1.0.0',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
