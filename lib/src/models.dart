/// Workout types supported by SonarFit SDK
enum WorkoutType {
  squat('squat'),
  deadlift('deadlift'),
  benchpress('benchpress');

  const WorkoutType(this.value);
  final String value;

  static WorkoutType fromString(String value) {
    return WorkoutType.values.firstWhere((e) => e.value == value.toLowerCase());
  }
}

/// Device types for motion tracking
enum DeviceType {
  none('none'),
  watch('watch'),
  airpods('airpods');

  const DeviceType(this.value);
  final String value;

  static DeviceType fromString(String value) {
    return DeviceType.values.firstWhere(
      (e) => e.value == value.toLowerCase(),
      orElse: () => DeviceType.none,
    );
  }
}

/// Workout configuration
class WorkoutConfig {
  final WorkoutType workoutType;
  final int sets;
  final int reps;
  final int restTime;
  final int countdownDuration;
  final bool autoReLift;
  final DeviceType deviceType;

  const WorkoutConfig({
    required this.workoutType,
    required this.sets,
    required this.reps,
    this.restTime = 60,
    this.countdownDuration = 3,
    this.autoReLift = true,
    this.deviceType = DeviceType.none,
  });

  Map<String, dynamic> toMap() {
    return {
      'workoutType': workoutType.value,
      'sets': sets,
      'reps': reps,
      'restTime': restTime,
      'countdownDuration': countdownDuration,
      'autoReLift': autoReLift,
      'deviceType': deviceType.value,
    };
  }
}

/// Completed set information
class WorkoutSet {
  final int setNumber;
  final int repsCompleted;

  const WorkoutSet({
    required this.setNumber,
    required this.repsCompleted,
  });

  factory WorkoutSet.fromMap(Map<dynamic, dynamic> map) {
    return WorkoutSet(
      setNumber: map['setNumber'] as int,
      repsCompleted: map['repsCompleted'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'setNumber': setNumber,
      'repsCompleted': repsCompleted,
    };
  }
}

/// Workout completion result
class WorkoutResult {
  final bool completed;
  final bool cancelled;
  final WorkoutType? workoutType;
  final DeviceType? deviceType;
  final DateTime? startTime;
  final DateTime? endTime;
  final double? totalDuration;
  final double completionPercentage;
  final int? targetSets;
  final int? targetRepsPerSet;
  final int totalRepsCompleted;
  final int? totalTargetReps;
  final List<WorkoutSet> sets;

  const WorkoutResult({
    required this.completed,
    this.cancelled = false,
    this.workoutType,
    this.deviceType,
    this.startTime,
    this.endTime,
    this.totalDuration,
    this.completionPercentage = 0.0,
    this.targetSets,
    this.targetRepsPerSet,
    this.totalRepsCompleted = 0,
    this.totalTargetReps,
    this.sets = const [],
  });

  factory WorkoutResult.fromMap(Map<dynamic, dynamic> map) {
    return WorkoutResult(
      completed: map['completed'] as bool? ?? false,
      cancelled: map['cancelled'] as bool? ?? false,
      workoutType: map['workoutType'] != null
          ? WorkoutType.fromString(map['workoutType'] as String)
          : null,
      deviceType: map['deviceType'] != null
          ? DeviceType.fromString(map['deviceType'] as String)
          : null,
      startTime: map['startTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              ((map['startTime'] as num) * 1000).toInt())
          : null,
      endTime: map['endTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              ((map['endTime'] as num) * 1000).toInt())
          : null,
      totalDuration: map['totalDuration'] as double?,
      completionPercentage: (map['completionPercentage'] as num?)?.toDouble() ?? 0.0,
      targetSets: map['targetSets'] as int?,
      targetRepsPerSet: map['targetRepsPerSet'] as int?,
      totalRepsCompleted: map['totalRepsCompleted'] as int? ?? 0,
      totalTargetReps: map['totalTargetReps'] as int?,
      sets: (map['sets'] as List<dynamic>?)
              ?.map((e) => WorkoutSet.fromMap(e as Map<dynamic, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'completed': completed,
      'cancelled': cancelled,
      if (workoutType != null) 'workoutType': workoutType!.value,
      if (deviceType != null) 'deviceType': deviceType!.value,
      if (startTime != null) 'startTime': startTime!.millisecondsSinceEpoch / 1000,
      if (endTime != null) 'endTime': endTime!.millisecondsSinceEpoch / 1000,
      if (totalDuration != null) 'totalDuration': totalDuration,
      'completionPercentage': completionPercentage,
      if (targetSets != null) 'targetSets': targetSets,
      if (targetRepsPerSet != null) 'targetRepsPerSet': targetRepsPerSet,
      'totalRepsCompleted': totalRepsCompleted,
      if (totalTargetReps != null) 'totalTargetReps': totalTargetReps,
      'sets': sets.map((s) => s.toMap()).toList(),
    };
  }

  @override
  String toString() {
    if (cancelled) return 'WorkoutResult(cancelled)';
    if (completed) {
      return 'WorkoutResult(completed: $totalRepsCompleted/$totalTargetReps reps, ${(completionPercentage * 100).toStringAsFixed(0)}%)';
    }
    return 'WorkoutResult(incomplete)';
  }
}

/// SonarFit SDK exceptions
class SonarFitException implements Exception {
  final String code;
  final String message;
  final dynamic details;

  const SonarFitException({
    required this.code,
    required this.message,
    this.details,
  });

  @override
  String toString() => 'SonarFitException($code): $message';
}
