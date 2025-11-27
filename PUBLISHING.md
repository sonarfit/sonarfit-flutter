# Publishing Guide for SonarFit Flutter Plugin

This guide explains how to publish the SonarFit Flutter plugin to pub.dev.

## Prerequisites

1. **Flutter SDK** installed (3.3.0+)
2. **Dart SDK** installed (3.0.0+)
3. **pub.dev account** - create at [https://pub.dev](https://pub.dev)
4. **Google account** for authentication

## Pre-Publishing Checklist

### 1. Verify Package Structure

```bash
cd sonarfit-flutter
flutter pub get
flutter analyze
```

Ensure no errors or warnings.

### 2. Test the Example App

```bash
cd example
flutter pub get
cd ios && pod install && cd ..
flutter run
```

### 3. Verify iOS Build

```bash
cd ios
pod lib lint sonarfit_flutter.podspec
```

### 4. Update Version Number

Ensure `pubspec.yaml` has the correct version:

```yaml
version: 1.0.0
```

Use semantic versioning: `MAJOR.MINOR.PATCH`

### 5. Update Documentation

- **README.md** - Up to date with latest features
- **CHANGELOG.md** - Document all changes for this version
- **Example app** - Working and demonstrates key features

## Publishing Steps

### 1. Dry Run

Test the publish command without actually publishing:

```bash
cd sonarfit-flutter
flutter pub publish --dry-run
```

Fix any issues reported.

### 2. Publish to pub.dev

```bash
flutter pub publish
```

You'll be prompted to:
1. Authenticate with Google account
2. Grant pub.dev access
3. Confirm publication

### 3. Verify Publication

Visit your package page:
```
https://pub.dev/packages/sonarfit_flutter
```

## Post-Publishing

### 1. Tag the Release

```bash
git tag v1.0.0
git push origin v1.0.0
```

### 2. Create GitHub Release

```bash
gh release create v1.0.0 \
  --title "SonarFit Flutter Plugin v1.0.0" \
  --notes-file CHANGELOG.md
```

### 3. Update README Badges

Add pub.dev version badge to README.md:

```markdown
[![pub package](https://img.shields.io/pub/v/sonarfit_flutter.svg)](https://pub.dev/packages/sonarfit_flutter)
```

## Updating the Package

### For Patch Releases (1.0.0 → 1.0.1)

Bug fixes, no API changes:

```bash
# Update version in pubspec.yaml
version: 1.0.1

# Update CHANGELOG.md
## [1.0.1] - 2025-XX-XX
### Fixed
- Bug fix description

# Publish
flutter pub publish
git tag v1.0.1
git push origin v1.0.1
```

### For Minor Releases (1.0.0 → 1.1.0)

New features, backward compatible:

```bash
# Update version in pubspec.yaml
version: 1.1.0

# Update CHANGELOG.md
## [1.1.0] - 2025-XX-XX
### Added
- New feature description

# Publish
flutter pub publish
git tag v1.1.0
git push origin v1.1.0
```

### For Major Releases (1.0.0 → 2.0.0)

Breaking changes:

```bash
# Update version in pubspec.yaml
version: 2.0.0

# Update CHANGELOG.md with migration guide
## [2.0.0] - 2025-XX-XX
### Breaking Changes
- Breaking change description
- Migration instructions

# Publish
flutter pub publish
git tag v2.0.0
git push origin v2.0.0
```

## Testing Before Publishing

### Local Testing

Test the plugin locally before publishing:

1. **In example app** - use local path dependency:
   ```yaml
   dependencies:
     sonarfit_flutter:
       path: ../
   ```

2. **In external test app** - use local path:
   ```yaml
   dependencies:
     sonarfit_flutter:
       path: /path/to/sonarfit-flutter
   ```

### Integration Testing

Create integration tests in `test/` directory:

```dart
// test/sonarfit_flutter_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sonarfit_flutter/sonarfit_flutter.dart';

void main() {
  test('WorkoutConfig creates valid configuration', () {
    final config = WorkoutConfig(
      workoutType: WorkoutType.squat,
      sets: 3,
      reps: 10,
    );

    expect(config.workoutType, WorkoutType.squat);
    expect(config.sets, 3);
    expect(config.reps, 10);
    expect(config.restTime, 60); // default value
  });
}
```

Run tests:
```bash
flutter test
```

## Common Publishing Issues

### Issue: "Package validation failed"

**Solution:** Run `flutter pub publish --dry-run` and fix all reported issues.

### Issue: "Version already exists"

**Solution:** Increment version number in `pubspec.yaml`.

### Issue: "Missing required fields"

**Solution:** Ensure `pubspec.yaml` has:
- `name`
- `description`
- `version`
- `homepage` or `repository`

### Issue: "iOS compilation errors"

**Solution:**
1. Update `ios/sonarfit_flutter.podspec`
2. Ensure SonarFitKit dependency is correct
3. Test with `pod lib lint sonarfit_flutter.podspec`

## Maintenance

### Regular Updates

- **Monthly**: Check for Flutter SDK updates
- **Quarterly**: Update dependencies
- **As needed**: Sync with iOS SDK updates

### Monitoring

- **pub.dev analytics**: Track download stats
- **GitHub issues**: Respond to user issues
- **Email**: Monitor support@sonarfit.com

## Support Channels

- **Documentation**: Update README.md with new features
- **Examples**: Add new example code for common use cases
- **GitHub Issues**: Create issue templates
- **Discord/Slack**: Community support channel

## Checklist Before Each Release

- [ ] All tests passing
- [ ] Example app builds and runs
- [ ] iOS pod lint passes
- [ ] CHANGELOG.md updated
- [ ] README.md updated
- [ ] Version number incremented
- [ ] No deprecation warnings
- [ ] All breaking changes documented
- [ ] Migration guide provided (for major versions)

## Additional Resources

- [pub.dev Publishing Guide](https://dart.dev/tools/pub/publishing)
- [Flutter Plugin Development](https://flutter.dev/docs/development/packages-and-plugins/developing-packages)
- [Semantic Versioning](https://semver.org/)
- [pub.dev Policy](https://pub.dev/policy)
