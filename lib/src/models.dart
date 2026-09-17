/// Workout types supported by SonarFit SDK
enum WorkoutType {
  squat('squat'),
  deadlift('deadlift'),
  benchpress('benchpress'),
  shoulderPress('shoulder_press'),
  bicepCurl('bicep_curl');

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

/// Workout completion status
enum WorkoutStatus {
  completed('completed'),       // All target sets finished
  stoppedEarly('stoppedEarly'); // User ended before completion

  const WorkoutStatus(this.value);
  final String value;

  static WorkoutStatus fromString(String value) {
    return WorkoutStatus.values.firstWhere(
      (e) => e.value == value.toLowerCase(),
      orElse: () => WorkoutStatus.stoppedEarly,
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
    required this.deviceType,
    this.restTime = 60,
    this.countdownDuration = 3,
    this.autoReLift = true,
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
  final WorkoutType workoutType;
  final DeviceType deviceType;
  final DateTime startTime;
  final DateTime endTime;
  final double totalDuration;
  final WorkoutStatus status;
  final double completionPercentage;
  final List<WorkoutSet> sets;
  final int targetSets;
  final int targetRepsPerSet;
  final int totalRepsCompleted;
  final int totalTargetReps;

  const WorkoutResult({
    required this.workoutType,
    required this.deviceType,
    required this.startTime,
    required this.endTime,
    required this.totalDuration,
    required this.status,
    required this.completionPercentage,
    required this.sets,
    required this.targetSets,
    required this.targetRepsPerSet,
    required this.totalRepsCompleted,
    required this.totalTargetReps,
  });

  factory WorkoutResult.fromMap(Map<dynamic, dynamic> map) {
    return WorkoutResult(
      workoutType: WorkoutType.fromString(map['workoutType'] as String),
      deviceType: DeviceType.fromString(map['deviceType'] as String),
      startTime: DateTime.fromMillisecondsSinceEpoch(
          ((map['startTime'] as num) * 1000).toInt()),
      endTime: DateTime.fromMillisecondsSinceEpoch(
          ((map['endTime'] as num) * 1000).toInt()),
      totalDuration: (map['totalDuration'] as num).toDouble(),
      status: WorkoutStatus.fromString(map['status'] as String),
      completionPercentage: (map['completionPercentage'] as num).toDouble(),
      sets: (map['sets'] as List<dynamic>)
          .map((e) => WorkoutSet.fromMap(e as Map<dynamic, dynamic>))
          .toList(),
      targetSets: map['targetSets'] as int,
      targetRepsPerSet: map['targetRepsPerSet'] as int,
      totalRepsCompleted: map['totalRepsCompleted'] as int,
      totalTargetReps: map['totalTargetReps'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'workoutType': workoutType.value,
      'deviceType': deviceType.value,
      'startTime': startTime.millisecondsSinceEpoch / 1000,
      'endTime': endTime.millisecondsSinceEpoch / 1000,
      'totalDuration': totalDuration,
      'status': status.value,
      'completionPercentage': completionPercentage,
      'sets': sets.map((s) => s.toMap()).toList(),
      'targetSets': targetSets,
      'targetRepsPerSet': targetRepsPerSet,
      'totalRepsCompleted': totalRepsCompleted,
      'totalTargetReps': totalTargetReps,
    };
  }

  @override
  String toString() {
    return 'WorkoutResult(status: $status, reps: $totalRepsCompleted/$totalTargetReps, ${(completionPercentage * 100).toStringAsFixed(0)}%)';
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


/// One event from the watch's headless rep detection (a native Watch app counting reps
/// inside its own UI). The phone receives these once the SDK is initialised; subscribe with
/// [SonarFit.headlessEvents]. Types: workoutStarted, setStarted, rep, setEnded, setCancelled,
/// workoutEnded.
class HeadlessEvent {
  final String type;
  final int? setIndex;
  /// setStarted / setEnded: the exercise ('squat', 'deadlift', 'benchpress', 'shoulder_press', 'bicep_curl').
  final String? exercise;
  /// setStarted / setEnded: the set's target.
  final int? targetReps;
  /// rep: the running count, cumulative.
  final int? count;
  /// setEnded: the set's rep count and duration in seconds.
  final int? reps;
  final double? duration;
  /// workoutEnded: how many sets were counted in the workout.
  final int? setsCounted;

  const HeadlessEvent({
    required this.type,
    this.setIndex,
    this.exercise,
    this.targetReps,
    this.count,
    this.reps,
    this.duration,
    this.setsCounted,
  });

  factory HeadlessEvent.fromMap(Map<dynamic, dynamic> m) => HeadlessEvent(
        type: m['type'] as String,
        setIndex: m['setIndex'] as int?,
        exercise: m['exercise'] as String?,
        targetReps: m['targetReps'] as int?,
        count: m['count'] as int?,
        reps: m['reps'] as int?,
        duration: (m['duration'] as num?)?.toDouble(),
        setsCounted: m['setsCounted'] as int?,
      );

  @override
  String toString() => 'HeadlessEvent($type, set: $setIndex, exercise: $exercise, count: $count, reps: $reps)';
}
