# ML Models Directory

Place your Core ML model files (.mlmodelc) in this directory.

## Expected Model Files:

### Watch Models:
- `gym20_model.mlmodelc` - Squat detection for Apple Watch
- `gym20_deadlift.mlmodelc` - Deadlift detection for Apple Watch
- `gym20_benchpress.mlmodelc` - Bench press detection for Apple Watch

### Headphone Models:
- `gym_headphone02.mlmodelc` - Squat detection for Headphones
- `gym_headphone_deadlift.mlmodelc` - Deadlift detection for Headphones

## How to Add Models:

1. Copy your `.mlmodelc` files to this directory
2. Uncomment the model extensions in `GymModelProtocol.swift`
3. The models will be automatically loaded from the bundle resources

## File Structure:
```
Sources/SonarFitCore/Resources/MLModels/
├── gym20_model.mlmodelc
├── gym20_deadlift.mlmodelc
├── gym20_benchpress.mlmodelc
├── gym_headphone02.mlmodelc
├── gym_headphone_deadlift.mlmodelc
└── README.md (this file)
```