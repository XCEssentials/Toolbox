projName = 'Toolbox'
projSummary = 'Set of helpers for writing apps faster.'
companyPrefix = 'XCE'
companyName = 'XCEssentials'
companyGitHubAccount = 'https://github.com/' + companyName
companyGitHubPage = 'https://' + companyName + '.github.io'

#===

Pod::Spec.new do |s|

  s.name                      = companyPrefix + projName
  s.summary                   = projSummary
  s.version                   = '1.19.0'
  s.homepage                  = companyGitHubPage + '/' + projName

  s.source                    = { :git => companyGitHubAccount + '/' + projName + '.git', :tag => s.version }

  s.requires_arc              = true

  s.license                   = { :type => 'MIT', :file => 'LICENSE' }
  s.author                    = { 'Maxim Khatskevich' => 'maxim@khatskevi.ch' }

  # === All platforms

  s.source_files              = 'Sources/Common/**/*.swift'
  s.resource_bundle           = { s.name + '_CommonTemplates' => 'Templates/Sourcery/Common/**/*.stencil' }

  s.dependency                  'Kingfisher', '~> 4.7.0'
  s.dependency                  'PromiseKit', '~> 6.2.0'

  # === iOS

  s.ios.deployment_target     = '10.0'

  s.ios.source_files          = 'Sources/iOS/**/*.swift'
  s.ios.resource_bundle       = { s.name + '_iOSTemplates' => ['Templates/Sourcery/iOS/**/*.stencil', 'Templates/SwiftGen/iOS/**/*.stencil'] }

  s.ios.framework             = 'UIKit'

  s.ios.dependency              'SwiftGen', '~> 5.3.0'
  s.ios.dependency              'RandomColorSwift', '~> 1.0.0'
  s.ios.dependency              'Mortar/Core_NoCreatable', '~> 1.4.0'
  s.ios.dependency              'Mortar/MortarVFL_NoCreatable'

  s.ios.dependency              'XCEArrayExt', '~> 1.1.0'
  s.ios.dependency              'XCEUniFlow', '~> 4.10.0'
  s.ios.dependency              'XCEViewExt', '~> 1.0.0'
  s.ios.dependency              'XCEModelDependable', '~> 1.1.0'
  s.ios.dependency              'XCEViewEvents', '~> 1.1.0'
  s.ios.dependency              'XCEStream', '~> 1.1.0'
  s.ios.dependency              'XCEFunctionalState', '~> 4.0.0'
  s.ios.dependency              'XCEReusableView', '~> 1.1.0'
  s.ios.dependency              'XCEValidatableValue', '~> 3.9.0'

  # === macOS

  # s.osx.deployment_target   = '10.11'

  # s.osx.dependency              'Mortar/Core_NoCreatable', '~> 1.4.0'
  # s.osx.dependency              'Mortar/MortarVFL_NoCreatable'

  # === tvOS

  # s.tvos.dependency              'Mortar/Core_NoCreatable', '~> 1.4.0'
  # s.tvos.dependency              'Mortar/MortarVFL_NoCreatable'

  # === watchOS

  # no Mortart! Check latest version, try to adopt or use SnapKit instead?

end
