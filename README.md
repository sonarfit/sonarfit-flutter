# SonarFit Flutter Plugin

Official Flutter plugin for the SonarFit SDK - AI-powered strength training with real-time rep detection using Apple Watch or AirPods Pro motion sensors.

[![pub package](https://img.shields.io/pub/v/sonarfit_flutter.svg)](https://pub.dev/packages/sonarfit_flutter)
[![Platform](https://img.shields.io/badge/platform-iOS-blue.svg)](https://www.apple.com/ios/)

## Features

- **Real-time Rep Detection**: AI-powered motion analysis counts reps automatically
- **Multiple Exercise Support**: Squats, deadlifts, bench press, and more
- **Device Flexibility**: Works with Apple Watch or AirPods Pro
- **Built-in UI**: Beautiful, ready-to-use workout interface
- **Progress Tracking**: Automatic set/rep tracking with rest timers
- **Permission Handling**: Automatic motion permission requests

## Platform Support

| Platform | Support |
|----------|---------|
| iOS      | ✅ 17.0+ |
| Android  | ❌ Not supported |

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  sonarfit_flutter: ^1.0.0
```

Then run:

```bash
flutter pub get
```

### iOS Configuration

1. **Update iOS deployment target** in `ios/Podfile`:

```ruby
platform :ios, '17.0'
```

2. **Add required permissions** to `ios/Runner/Info.plist`:

```xml
<key>NSMotionUsageDescription</key>
<string>SonarFit needs motion sensor access to count your reps during workouts</string>

<key>NSHealthUpdateUsageDescription</key>
<string>SonarFit needs HealthKit access to save your workout data</string>

<key>NSHealthShareUsageDescription</key>
<string>SonarFit needs HealthKit access to read your workout history</string>
```

3. **Install CocoaPods dependencies**:

```bash
cd ios && pod install && cd ..
```

## Quick Start

### 1. Initialize the SDK

Get your API key from [https://sonarfit.com/get-started](https://sonarfit.com/get-started)

```dart
import 'package:sonarfit_flutter/sonarfit_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SonarFit SDK
  await SonarFit.initialize('your-api-key-here');

  runApp(MyApp());
}
```

### 2. Present a Workout

```dart
import 'package:flutter/material.dart';
import 'package:sonarfit_flutter/sonarfit_flutter.dart';

class WorkoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SonarFit Workout')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              final result = await SonarFit.presentWorkout(
                WorkoutConfig(
                  workoutType: WorkoutType.squat,
                  sets: 3,
                  reps: 10,
                  deviceType: DeviceType.watch,
                  restTime: 60,
                ),
              );

              if (result.status == WorkoutStatus.completed) {
                print('Workout completed!');
                print('Reps: ${result.totalRepsCompleted}/${result.totalTargetReps}');
              } else {
                print('Workout stopped early');
                print('Reps: ${result.totalRepsCompleted}/${result.totalTargetReps}');
              }
            } on SonarFitException catch (e) {
              print('Error: ${e.message}');
            }
          },
          child: Text('Start Workout'),
        ),
      ),
    );
  }
}
```

## API Reference

### SonarFit

Main entry point for the SDK.

#### Methods

##### `initialize(String apiKey)`

Initialize the SDK with your API key. Must be called before using any other methods.

```dart
await SonarFit.initialize('your-api-key');
```

**Throws:** `SonarFitException` if initialization fails.

---

##### `presentWorkout(WorkoutConfig config)`

Present SonarFit's built-in workout UI.

```dart
final result = await SonarFit.presentWorkout(
  WorkoutConfig(
    workoutType: WorkoutType.squat,
    sets: 3,
    reps: 10,
    deviceType: DeviceType.watch,
    restTime: 60,
    countdownDuration: 3,
    autoReLift: true,
  ),
);
```

**Returns:** `WorkoutResult` when workout completes (either fully or stopped early).

**Throws:** `SonarFitException` if workout fails to start, permission is denied, or user cancels before starting.

---

### WorkoutConfig

Configuration for a workout session.

#### Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `workoutType` | `WorkoutType` | Yes | Type of exercise |
| `sets` | `int` | Yes | Number of sets |
| `reps` | `int` | Yes | Target reps per set |
| `deviceType` | `DeviceType` | Yes | Motion tracking device (`.watch` or `.airpods`) |
| `restTime` | `int` | No | Rest duration in seconds |
| `countdownDuration` | `int` | No | Countdown before each set |
| `autoReLift` | `bool` | No | Auto-detect reps |

#### Example

```dart
final config = WorkoutConfig(
  workoutType: WorkoutType.deadlift,
  sets: 5,
  reps: 5,
  deviceType: DeviceType.watch,
  restTime: 90,
  countdownDuration: 5,
  autoReLift: true,
);
```

---

### WorkoutType

Supported exercise types.

```dart
enum WorkoutType {
  squat,
  deadlift,
  benchpress,
}
```

---

### DeviceType

Motion tracking devices.

```dart
enum DeviceType {
  watch,    // Apple Watch
  airpods,  // AirPods Pro/Max with motion sensors
}
```

**Note:** `DeviceType.none` exists for internal SDK use only. Clients must explicitly select either `.watch` or `.airpods`.

---

### WorkoutStatus

Workout completion status.

```dart
enum WorkoutStatus {
  completed,      // All target sets finished
  stoppedEarly,   // User ended before completion
}
```

---

### WorkoutResult

Result of a completed workout.

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `workoutType` | `WorkoutType` | Exercise type |
| `deviceType` | `DeviceType` | Device used for tracking |
| `startTime` | `DateTime` | Workout start time |
| `endTime` | `DateTime` | Workout end time |
| `totalDuration` | `double` | Total duration in seconds |
| `status` | `WorkoutStatus` | Workout completion status |
| `completionPercentage` | `double` | Completion percentage (0.0-1.0) |
| `targetSets` | `int` | Target number of sets |
| `targetRepsPerSet` | `int` | Target reps per set |
| `totalRepsCompleted` | `int` | Total reps completed |
| `totalTargetReps` | `int` | Total target reps |
| `sets` | `List<WorkoutSet>` | Per-set details |

#### Example

```dart
print('Completed ${result.totalRepsCompleted}/${result.totalTargetReps} reps');
print('${(result.completionPercentage * 100).toStringAsFixed(0)}% complete');
print('Status: ${result.status}');

for (var set in result.sets) {
  print('Set ${set.setNumber}: ${set.repsCompleted} reps');
}
```

---

### SonarFitException

Exception thrown by SDK operations.

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `code` | `String` | Error code |
| `message` | `String` | Human-readable error message |
| `details` | `dynamic` | Additional error details |

#### Common Error Codes

| Code | Description |
|------|-------------|
| `E_INIT_FAILED` | SDK initialization failed |
| `E_PERMISSION` | Motion permission denied |
| `E_INVALID_CONFIG` | Invalid workout configuration |
| `E_NO_ROOT_VC` | Cannot find root view controller |
| `E_CANCELLED` | Workout was cancelled by user |
| `E_NO_RESULT` | Workout completed but no result was returned |

---

## Examples

### Complete Workout Flow

```dart
import 'package:flutter/material.dart';
import 'package:sonarfit_flutter/sonarfit_flutter.dart';

class WorkoutExampleScreen extends StatefulWidget {
  @override
  _WorkoutExampleScreenState createState() => _WorkoutExampleScreenState();
}

class _WorkoutExampleScreenState extends State<WorkoutExampleScreen> {
  WorkoutResult? _lastResult;
  bool _isLoading = false;

  Future<void> _startWorkout() async {
    setState(() => _isLoading = true);

    try {
      final result = await SonarFit.presentWorkout(
        WorkoutConfig(
          workoutType: WorkoutType.squat,
          sets: 3,
          reps: 10,
          deviceType: DeviceType.watch,
          restTime: 60,
        ),
      );

      setState(() {
        _lastResult = result;
        _isLoading = false;
      });

      _showCompletionDialog(result);
    } on SonarFitException catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog(e);
    }
  }

  void _showCompletionDialog(WorkoutResult result) {
    final title = result.status == WorkoutStatus.completed
        ? 'Workout Complete!'
        : 'Workout Stopped';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reps: ${result.totalRepsCompleted}/${result.totalTargetReps}'),
            Text('Completion: ${(result.completionPercentage * 100).toStringAsFixed(0)}%'),
            SizedBox(height: 16),
            Text('Sets:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...result.sets.map((set) =>
              Text('Set ${set.setNumber}: ${set.repsCompleted} reps')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(SonarFitException error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(error.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SonarFit Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _startWorkout,
                child: Text('Start Workout'),
              ),
            if (_lastResult != null) ...[
              SizedBox(height: 32),
              Text(
                'Last Workout',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 8),
              Text('${_lastResult!.totalRepsCompleted} reps completed'),
              Text('${(_lastResult!.completionPercentage * 100).toStringAsFixed(0)}% complete'),
            ],
          ],
        ),
      ),
    );
  }
}
```

### Multiple Workout Types

```dart
class WorkoutTypeSelector extends StatelessWidget {
  final List<WorkoutType> workouts = [
    WorkoutType.squat,
    WorkoutType.deadlift,
    WorkoutType.benchpress,
  ];

  Future<void> _startWorkout(BuildContext context, WorkoutType type) async {
    try {
      final result = await SonarFit.presentWorkout(
        WorkoutConfig(
          workoutType: type,
          sets: 3,
          reps: 10,
          deviceType: DeviceType.watch,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${result.totalRepsCompleted} reps completed (${result.status.name})')),
      );
    } on SonarFitException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final workout = workouts[index];
        return ListTile(
          title: Text(_getWorkoutName(workout)),
          trailing: Icon(Icons.arrow_forward),
          onTap: () => _startWorkout(context, workout),
        );
      },
    );
  }

  String _getWorkoutName(WorkoutType type) {
    switch (type) {
      case WorkoutType.squat:
        return 'Squat';
      case WorkoutType.deadlift:
        return 'Deadlift';
      case WorkoutType.benchpress:
        return 'Bench Press';
    }
  }
}
```

## Pricing

SonarFit uses MAU-based pricing (Monthly Active Users). A user counts as active when they complete at least one workout in a calendar month.

| Tier | Price | Included MAUs | Overage |
|------|-------|---------------|---------|
| Developer | Free | 500 (hard cap) | N/A |
| Startup | £129/mo | 2,000 | £0.08/MAU |
| Growth | £599/mo | 10,000 | £0.07/MAU |
| Enterprise | Custom | Negotiated | Custom |

Get started at [https://sonarfit.com/pricing](https://sonarfit.com/pricing)

## Requirements

- **Flutter**: 3.3.0 or higher
- **Dart**: 3.0.0 or higher
- **iOS**: 17.0 or higher
- **Xcode**: 16.0 or higher
- **CocoaPods**: 1.11.0 or higher

## Troubleshooting

### Build Errors

**Error:** "Platform version is lower than 17.0"

**Solution:** Update `ios/Podfile`:
```ruby
platform :ios, '17.0'
```

---

**Error:** "No such module 'SonarFitKit'"

**Solution:** Run:
```bash
cd ios && pod install && cd ..
flutter clean
flutter pub get
```

---

### Runtime Errors

**Error:** "Motion permission denied"

**Solution:** Add `NSMotionUsageDescription` to `Info.plist` and ensure user grants permission when prompted.

---

**Error:** "SDK not initialized"

**Solution:** Call `SonarFit.initialize()` before using any other methods.

---

## Support

- **Documentation**: [https://sonarfit.com/docs](https://sonarfit.com/docs)
- **Email**: support@sonarfit.com
- **GitHub Issues**: [https://github.com/sonarfit/sonarfit-flutter/issues](https://github.com/sonarfit/sonarfit-flutter/issues)

## License

MIT License - see LICENSE file for details

## About SonarFit

SonarFit provides AI-powered workout execution intelligence for fitness apps. Our SDK handles real-time rep counting, form analysis, and workout progression so you can focus on building great user experiences.

Learn more at [https://sonarfit.com](https://sonarfit.com)
