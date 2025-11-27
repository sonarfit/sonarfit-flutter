#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint sonarfit_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'sonarfit_flutter'
  s.version          = '1.0.0'
  s.summary          = 'Flutter plugin for SonarFit SDK'
  s.description      = <<-DESC
Flutter plugin for SonarFit SDK - AI-powered strength training with real-time rep detection.
                       DESC
  s.homepage         = 'https://sonarfit.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'SonarFit' => 'support@sonarfit.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '17.0'
  s.swift_version = '5.9'

  # Pod installation will fail without this
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }

  # Add SonarFitKit dependency
  # Option 1: Use Swift Package Manager (recommended for v2.0+)
  # s.dependency 'SonarFitKit', '~> 2.0'

  # Option 2: Use local XCFrameworks (for development)
  # Using vendored frameworks for local development
  s.vendored_frameworks = [
    'SonarFitKit.xcframework',
    'SonarFitCore.xcframework',
    'SonarFitUI.xcframework',
    'SonarFitConnectivity.xcframework'
  ]
end
