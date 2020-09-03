#
# Be sure to run `pod lib lint Spot.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Spot'
  s.version          = '0.1.9'
  s.summary          = 'A super simple pod for reporting UI issues.'

  s.description      = <<-DESC
A super simple pod for reporting UI issues.

When you spot something in your app that needs reporting just shake your phone/device. A screenshot of the current screen will popup, draw on it to highlight areas and then send it on in an email.
                       DESC

  s.homepage         = 'https://github.com/Workshed/Spot'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Daniel Leivers' => 'dan@sofaracing.com' }
  s.source           = { :git => 'https://github.com/Workshed/Spot.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/sofaracing'

  s.ios.deployment_target = '10.0'

  s.source_files = 'Spot/*.swift'
  
  s.resource_bundles = {
    'Spot' => ['Spot/Spot.storyboard']
  }

  s.swift_version = '5.0'
  s.frameworks = 'UIKit', 'MessageUI'
end
