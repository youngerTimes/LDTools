#
# Be sure to run `pod lib lint LDTools-Swift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LDTools-Swift'
  s.version          = '0.1.0'
  s.summary          = '喜望软件：iOS集合开发包(Swift)'
  s.swift_versions   = '5.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'http://www.sinata.cn'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'younger_times' => '841720330@qq.com' }
  s.source           = { :git => 'http://yangk@sinata.cn:10101/gitblit/r/ios/SwiftFrame.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'LDTools-Swift/Classes/**/*'
  s.resource_bundles = {
    'SwiftFrameRes' => ['LDTools-Swift/Assets/*']
  }

  s.dependency 'SnapKit'
  s.dependency 'QMUIKit'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
  s.dependency 'RxDataSources'
  s.dependency 'EmptyDataSet-Swift'
  s.dependency 'MJRefresh'
  s.dependency 'HandyJSON'
  s.dependency 'XCGLogger'
  s.dependency 'VTMagic'
  s.dependency 'UserDefaultsStore'
  s.dependency 'SVProgressHUD'
  s.dependency 'IQKeyboardManagerSwift'
  s.dependency 'TZImagePickerController'
  s.dependency 'SDWebImage'
  
  # s.resource_bundles = {
  #   'LDTools-Swift' => ['LDTools-Swift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
