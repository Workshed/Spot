#
# Be sure to run `pod lib lint Spot.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Spot'
  s.version          = '0.1.2'
  s.summary          = 'A super simple pod for reporting UI issues.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Workshed/Spot'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Daniel Leivers' => 'dan@sofaracing.com' }
  s.source           = { :git => 'https://github.com/Workshed/Spot.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/sofaracing'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Spot/*.swift', '.swift-version'
  
  s.resource_bundles = {
    'Spot' => ['Spot/Spot.storyboard']
  }

  s.frameworks = 'UIKit', 'MessageUI'
end
