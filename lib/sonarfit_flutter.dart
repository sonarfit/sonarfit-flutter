library sonarfit_flutter;

import 'dart:async';
import 'package:flutter/services.dart';
import 'src/models.dart';

export 'src/models.dart';

/// SonarFit SDK for Flutter
///
/// Provides AI-powered strength training with real-time rep detection
/// using Apple Watch or AirPods Pro motion sensors.
class SonarFit {
  static const MethodChannel _channel = MethodChannel('sonarfit_flutter');

  /// Initialize SonarFit SDK with your API key
  ///
  /// Must be called before using any other SDK methods.
  /// Get your API key from https://sonarfit.com/get-started
  ///
  /// Example:
  /// ```dart
  /// await SonarFit.initialize('your-api-key-here');
  /// ```
  ///
  /// Throws [SonarFitException] if initialization fails.
  static Future<void> initialize(String apiKey) async {
    try {
      await _channel.invokeMethod('initialize', {'apiKey': apiKey});
    } on PlatformException catch (e) {
      throw SonarFitException(
        code: e.code,
        message: e.message ?? 'Failed to initialize SonarFit SDK',
        details: e.details,
      );
    }
  }

  /// Present SonarFit's built-in workout UI
  ///
  /// Shows a full-screen workout interface with:
  /// - Automatic rep counting
  /// - Set tracking
  /// - Rest timers
  /// - Progress indicators
  /// - Device selection
  ///
  /// Returns [WorkoutResult] when workout completes or user dismisses.
  ///
  /// Example:
  /// ```dart
  /// final result = await SonarFit.presentWorkout(
  ///   WorkoutConfig(
  ///     workoutType: WorkoutType.squat,
  ///     sets: 3,
  ///     reps: 10,
  ///     restTime: 60,
  ///   ),
  /// );
  ///
  /// if (result.completed) {
  ///   print('Completed ${result.totalRepsCompleted} reps!');
  /// }
  /// ```
  ///
  /// Throws [SonarFitException] if:
  /// - SDK not initialized
  /// - Motion permission denied
  /// - Invalid configuration
  static Future<WorkoutResult> presentWorkout(WorkoutConfig config) async {
    try {
      final result = await _channel.invokeMethod(
        'presentWorkout',
        config.toMap(),
      );

      return WorkoutResult.fromMap(result as Map<dynamic, dynamic>);
    } on PlatformException catch (e) {
      throw SonarFitException(
        code: e.code,
        message: e.message ?? 'Failed to present workout',
        details: e.details,
      );
    }
  }
}
