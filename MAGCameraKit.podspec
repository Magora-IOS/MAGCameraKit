#
# Be sure to run `pod lib lint MAGCameraKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MAGCameraKit'
  s.version          = '0.1.0'
  s.summary          = 'Developers kit to use camera for capturing and editing photo or video like Instagram.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'MAGCameraKit'

  s.homepage         = 'https://github.com/Magora-IOS/MAGCameraKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Stepanov Evgeniy' => 'stepanov@magora.systems' }
  s.source           = { :git => 'https://github.com/Magora-IOS/MAGCameraKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'MAGCameraKit/Classes/**/*'
  
  s.resource_bundles = {
    'MAGCameraKit' => ['MAGCameraKit/Assets/*.png', 'MAGCameraKit/*.storyboard', 'MAGCameraKit/*.xcassets']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'SCRecorder', :git => 'https://github.com/JoniStep/SCRecorder.git'
  s.dependency 'libextobjc', '~> 0.4.1'
  s.dependency 'JPSVolumeButtonHandler', '~> 1.0.4'
  s.dependency 'SVProgressHUD', '~> 1.1.3'
end
