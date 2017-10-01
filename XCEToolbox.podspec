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
  s.version                   = '0.0.1'
  s.homepage                  = companyGitHubPage + '/' + projName
  
  s.source                    = { :git => companyGitHubAccount + '/' + projName + '.git', :tag => s.version }
  
  s.osx.deployment_target     = '10.11'
  s.ios.deployment_target     = '9.0'
  s.requires_arc              = true
  
  s.license                   = { :type => 'MIT', :file => 'LICENSE' }
  s.author                    = { 'Maxim Khatskevich' => 'maxim@khatskevi.ch' }

  s.default_subspec = 'Core'

  s.subspec 'Core' do |ss|

    ss.osx.deployment_target  = '10.11'
    ss.ios.deployment_target  = '9.0'

    ss.source_files           = 'Sources/Core/**/*.swift'

  end

  # s.subspec 'UIKit' do |ss|

  #   ss.ios.deployment_target  = '9.0'

  #   ss.framework              = 'UIKit'
  #   ss.dependency               s.name + '/Core'
  
  #   ss.source_files           = 'Sources/UIKit/**/*.swift'

  # end

end
