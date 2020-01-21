#
# Be sure to run `pod lib lint NAOSwiftProviderFramework.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NAOSwiftProviderFramework'
  s.version          = '0.1.0'
  s.swift_version    = '5.0'
  s.summary          = 'NAOSwiftProviderFramework is a bridge that allows uses to easly integrate NAOSDK into their Swift applications.'

  s.description      = <<-DESC
NAOSwiftProviderFramework allows users to easly integrate the NAOSDK into the Swift application.
It is a kind of bridge between the Swift application and the NAOSDK that is basically written in Objective-C.
LocationProvider exposes the callbacks and notifications that can be used to communicate with the NAOSDK.
                       DESC

  s.homepage         = 'https://github.com/bizagwira/NAOSwiftProviderFramework'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'bizagwira' => 'honore.bizagwira@polestar.eu' }
  s.source           = { :git => 'https://github.com/bizagwira/NAOSwiftProviderFramework.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'Services/*.swift'
  
  s.xcconfig = { 'SWIFT_INCLUDE_PATHS' => '/Users/polestar/ALL/MY_PROJECTS/NAOSwiftProviderFramework/Modules', 'LIBRARY_SEARCH_PATHS' => "/Users/polestar/ALL/MY_PROJECTS/NAOSwiftProviderFramework/Example/Pods/NAOSDK/" }
  
  s.static_framework = true
  s.libraries = "c++", "z", "NAOSDK"
  s.frameworks  = "CoreBluetooth", "CoreLocation", "CoreMotion", "SystemConfiguration"
  s.requires_arc = true
  
  s.frameworks = 'UIKit', 'CoreGraphics'
  s.dependency 'NAOSDK'
end
