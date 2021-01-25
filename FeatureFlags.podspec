#
# Be sure to run `pod lib lint FeatureFlags.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FeatureFlags'
  s.version          = '1.0.0'
  s.summary          = 'FeatureFlags library for Takeout Central.'

  s.description      = <<-DESC
FeatureFlags library for Takeout Central
                       DESC

  s.homepage         = 'https://github.com/TakeoutCentral/FeatureFlags-iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mgray88' => 'mgray88@gmail.com' }
  s.source           = { :git => 'https://github.com/TakeoutCentral/FeatureFlags-iOS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'

  s.source_files = 'FeatureFlags/Classes/**/*'

  # s.resource_bundles = {
  #   'FeatureFlags' => ['FeatureFlags/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Reusable', '~> 4.1'
  s.dependency 'GenericJSON', '~> 2.0'
end
