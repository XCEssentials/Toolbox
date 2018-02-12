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
  s.version                   = '1.2.0'
  s.homepage                  = companyGitHubPage + '/' + projName
  
  s.source                    = { :git => companyGitHubAccount + '/' + projName + '.git', :tag => s.version }
  
  s.requires_arc              = true
  
  s.license                   = { :type => 'MIT', :file => 'LICENSE' }
  s.author                    = { 'Maxim Khatskevich' => 'maxim@khatskevi.ch' }

  # === All platforms

  s.source_files              = 'Sources/Common/**/*.swift'
  s.resource_bundle           = { s.name + '_CommonTemplates' => 'Templates/Common/**/*.stencil' }

  s.dependency                  'SnapKit', '~> 4.0.0'

  # === iOS

  s.ios.deployment_target     = '10.0'

  s.ios.source_files          = 'Sources/iOS/**/*.swift'
  s.ios.resource_bundle       = { s.name + '_iOSTemplates' => 'Templates/iOS/**/*.stencil' }

  s.framework                 = 'UIKit'

  s.ios.dependency              'XCEUniFlow', '~> 4.10.0'
  s.ios.dependency              'XCEOperationFlow', '~> 4.1.0'
  s.ios.dependency              'XCEFunctionalState', '~> 3.1.0'

  # === macOS

  # s.osx.deployment_target   = '10.11'

end
