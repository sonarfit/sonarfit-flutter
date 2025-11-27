# Changelog

All notable changes to the SonarFit Flutter plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
