#
#  Be sure to run `pod spec lint PopItUp.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "PopItUp"
  s.version      = "1.1.0"
  s.summary      = "A framework to display your view controllers like popup"

  s.description  = <<-DESC
                    PopItUp is a framework that allow you to present your view controllers as a popup.
                    The framework uses iOS 8 new UIModalPresentationStyle and a wrapper to present your view controller with a custom size that can be determined with autolayout or set manualy.
                   DESC

  s.homepage     = "https://github.com/fritzgerald/PopItUp"
  s.screenshots  = "https://raw.githubusercontent.com/fritzgerald/screenshots/master/PopItUp/Capture01.gif"

  s.license      = "MIT"
  s.author             = { "MUISEROUX Fritzgerald" => "f.muiseroux@gmail.com" }
  s.social_media_url   = "https://twitter.com/fitji911"
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/fritzgerald/PopItUp.git", :tag => "#{s.version}" }
  s.source_files  = "Source/*.swift"
  s.swift_version = '4.2'

end
