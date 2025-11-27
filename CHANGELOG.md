# Changelog

All notable changes to the SonarFit Flutter plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2025-01-27

### Added
- `WorkoutStatus` enum for tracking completion status (`.completed` or `.stoppedEarly`)
- Error code `E_CANCELLED` thrown when user dismisses workout before starting
- Error code `E_NO_RESULT` for unexpected nil results from SDK

### Changed
- `deviceType` parameter in `WorkoutConfig` is now required (must specify `.watch` or `.airpods`)
- `WorkoutResult` now uses `status: WorkoutStatus` instead of boolean flags
- All `WorkoutResult` fields are now required (non-nullable)
- User cancellations now throw `SonarFitException` instead of returning partial results

### Platform Support
- iOS 17.0+
- Flutter 3.3.0+
- Dart 3.0.0+
- SonarFitKit iOS SDK 2.0.1

## [1.0.0] - 2025-01-25

### Added
- Initial release of SonarFit Flutter plugin
- Built-in workout UI with `SonarFit.presentWorkout()`
- Support for 3 workout types: Squat, Deadlift, Bench Press
- Automatic rep detection using Apple Watch or AirPods Pro
- Real-time progress tracking with set/rep counters
- Rest timer management with customizable durations
- Permission handling for motion sensors
- Complete Dart models: `WorkoutConfig`, `WorkoutResult`, `WorkoutSet`
- Comprehensive error handling with `SonarFitException`
- Example app demonstrating basic usage
- Full API documentation in README

### Platform Support
- iOS 17.0+

### Dependencies
- Flutter SDK: 3.3.0+
- Dart SDK: 3.0.0+
- SonarFitKit iOS SDK: 2.0.1
