import Flutter
import UIKit
import SonarFitKit

public class SonarFitFlutterPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "sonarfit_flutter",
            binaryMessenger: registrar.messenger()
        )
        let instance = SonarFitFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            handleInitialize(call, result: result)
        case "presentWorkout":
            handlePresentWorkout(call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Initialize

    private func handleInitialize(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let apiKey = args["apiKey"] as? String else {
            result(FlutterError(
                code: "E_INVALID_ARGS",
                message: "Missing apiKey",
                details: nil
            ))
            return
        }

        SonarFitSDK.initialize(apiKey: apiKey) { success, error in
            if success {
                result(nil)
            } else {
                result(FlutterError(
                    code: "E_INIT_FAILED",
                    message: error?.localizedDescription ?? "Failed to initialize SonarFit SDK",
                    details: nil
                ))
            }
        }
    }

    // MARK: - Present Workout

    private func handlePresentWorkout(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            result(FlutterError(
                code: "E_INVALID_ARGS",
                message: "Invalid arguments",
                details: nil
            ))
            return
        }

        guard let config = parseWorkoutConfig(from: args) else {
            result(FlutterError(
                code: "E_INVALID_CONFIG",
                message: "Invalid workout configuration",
                details: nil
            ))
            return
        }

        DispatchQueue.main.async {
            guard let rootViewController = self.getRootViewController() else {
                result(FlutterError(
                    code: "E_NO_ROOT_VC",
                    message: "Cannot find root view controller",
                    details: nil
                ))
                return
            }

            SonarFit.startWorkout(
                config: config,
                from: rootViewController,
                onCompletion: { workoutResult in
                    // Dismiss the view controller first
                    rootViewController.dismiss(animated: true) {
                        if let workoutResult = workoutResult {
                            result(self.workoutResultToMap(workoutResult))
                        } else {
                            // This should not happen - the SDK should always return a WorkoutResult
                            result(FlutterError(
                                code: "E_NO_RESULT",
                                message: "Workout completed but no result was returned",
                                details: nil
                            ))
                        }
                    }
                },
                onPermissionError: { error in
                    result(FlutterError(
                        code: "E_PERMISSION",
                        message: error.localizedDescription,
                        details: nil
                    ))
                },
                onDismissRequest: {
                    // User pressed X button to dismiss before starting workout
                    rootViewController.dismiss(animated: true) {
                        result(FlutterError(
                            code: "E_CANCELLED",
                            message: "Workout was cancelled by user",
                            details: nil
                        ))
                    }
                }
            )
        }
    }

    // MARK: - Helpers

    private func parseWorkoutConfig(from args: [String: Any]) -> WorkoutConfig? {
        guard let workoutTypeString = args["workoutType"] as? String else {
            return nil
        }

        let workoutType: WorkoutType
        switch workoutTypeString.lowercased() {
        case "squat":
            workoutType = .squat
        case "deadlift":
            workoutType = .deadlift
        case "benchpress":
            workoutType = .benchpress
        default:
            return nil
        }

        guard let sets = args["sets"] as? Int,
              let reps = args["reps"] as? Int else {
            return nil
        }

        let restTime = args["restTime"] as? Int ?? 60
        let countdownDuration = args["countdownDuration"] as? Int ?? 3
        let autoReLift = args["autoReLift"] as? Bool ?? true

        let deviceType: DeviceType
        if let deviceTypeString = args["deviceType"] as? String {
            switch deviceTypeString.lowercased() {
            case "watch":
                deviceType = .watch
            case "airpods":
                deviceType = .airpods
            default:
                deviceType = .none
            }
        } else {
            deviceType = .none
        }

        return WorkoutConfig(
            workoutType: workoutType,
            sets: sets,
            reps: reps,
            restTime: restTime,
            countdownDuration: countdownDuration,
            autoReLift: autoReLift,
            deviceType: deviceType
        )
    }

    private func workoutResultToMap(_ result: WorkoutResult) -> [String: Any] {
        // Convert deviceType to Flutter-compatible format
        let deviceTypeString: String
        switch result.deviceType {
        case .none:
            deviceTypeString = "none"
        case .watch:
            deviceTypeString = "watch"
        case .airpods:
            deviceTypeString = "airpods"
        @unknown default:
            deviceTypeString = "none"
        }

        return [
            "workoutType": result.workoutType.rawValue,
            "deviceType": deviceTypeString,
            "startTime": result.startTime.timeIntervalSince1970,
            "endTime": result.endTime.timeIntervalSince1970,
            "totalDuration": result.totalDuration,
            "status": result.status == .completed ? "completed" : "stoppedEarly",
            "completionPercentage": result.completionPercentage,
            "targetSets": result.targetSets,
            "targetRepsPerSet": result.targetRepsPerSet,
            "totalRepsCompleted": result.totalRepsCompleted,
            "totalTargetReps": result.totalTargetReps,
            "sets": result.sets.map { set in
                return [
                    "setNumber": set.setNumber,
                    "repsCompleted": set.repsCompleted
                ]
            }
        ]
    }

    private func getRootViewController() -> UIViewController? {
        var rootVC: UIViewController?

        if #available(iOS 13.0, *) {
            rootVC = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }?
                .rootViewController
        } else {
            rootVC = UIApplication.shared.keyWindow?.rootViewController
        }

        // Get the topmost presented view controller
        while let presentedVC = rootVC?.presentedViewController {
            rootVC = presentedVC
        }

        return rootVC
    }
}
