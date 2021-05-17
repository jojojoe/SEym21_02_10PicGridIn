#
# Be sure to run `pod lib lint GetRichEveryDay.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GetRichEveryDay'
  s.version          = '0.1.0'
  s.summary          = 'A short description of GetRichEveryDay.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://gitee.com/thunderline'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xcphantomxc' => '779661660@qq.com' }
  s.source           = { :git => 'https://gitee.com/thunderline/GetRichEveryDay.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.2'
  s.static_framework = true
  s.source_files = 'GetRichEveryDay/Classes/**/*'
  
  s.resource_bundles = {
    'GetRichEveryDay' => ['GetRichEveryDay/Assets/*']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'Kingfisher'
  s.dependency 'Alamofire'
  s.dependency 'SnapKit'
  s.dependency 'SwiftyJSON'
  s.dependency 'TTIGLoginProject'
  s.dependency 'Adjust'
  s.dependency 'SwifterSwift'
  s.dependency 'ZKProgressHUD'
  s.dependency 'SwiftyStoreKit'
  s.dependency 'DeviceKit'
  s.dependency 'Defaults'
  s.dependency 'GTMRefresh'
  s.dependency 'Alertift'
  s.dependency 'RxSwift', '~> 5'
  s.dependency 'RxCocoa', '~> 5'
  s.dependency 'MJRefresh'
end
