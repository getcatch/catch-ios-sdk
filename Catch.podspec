Pod::Spec.new do |s|
  s.name                    = 'Catch'
  s.version                 = '0.1.0'
  s.summary                 = 'Integrate Catch into your iOS app'
  s.homepage                = 'https://github.com/getcatch/catch-ios-sdk'
  s.license                 = { :type => 'MIT', :file => 'LICENSE' }
  s.author                  = 'Catch'
  s.source                  = { :git => 'https://github.com/getcatch/catch-ios-sdk.git', :tag => s.version.to_s }
  s.ios.deployment_target   = '12.0'
  s.swift_version           = '5.0.23'
  s.resource_bundles        = {
                                'Catch_Catch' => [ # Match the name SPM Generates
                                  'Sources/Catch/Resources/*'
                                 ]
                               }
  s.source_files            = 'Sources/Catch/**/*.{plist,swift}'
  s.exclude_files           = 'Example/*'
  s.framework               = 'UIKit'
end
