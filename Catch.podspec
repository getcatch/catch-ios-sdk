Pod::Spec.new do |s|
  s.name                    = 'Catch'
  s.version                 = '0.1.0'
  s.summary                 = 'Integrate Catch into your iOS app'
  s.homepage                = 'https://github.com/getcatch/catch-ios-sdk'
  s.license                 = { :type => 'MIT', :file => 'LICENSE' }
  s.author                  = 'Catch'
  s.source                  = { :git => 'https://github.com/getcatch/catch-ios-sdk.git', :tag => s.version.to_s }
  s.ios.deployment_target   = '9.0'
  s.swift_version           = '5.0.23'
  s.source_files            = 'Sources/Catch/**/*'
  s.framework               = 'UIKit'
end
