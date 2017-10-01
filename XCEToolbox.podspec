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

  # ===

  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|

    core.osx.deployment_target   = '10.11'
    core.ios.deployment_target   = '9.0'

    core.source_files            = 'Sources/Core/**/*.swift'

  end

  # ===

  s.subspec 'Models' do |mds|

    mds.osx.deployment_target    = '10.11'
    mds.ios.deployment_target    = '9.0'

    mds.dependency                 s.name + '/Core'

    mds.dependency                 'XCEUniFlow/MVVM', '~> 4.8'
  
    # ===

    mds.subspec 'ServiceProvider' do |sp|
    
      sp.source_files            = 'Sources/Models/ServiceProvider/**/*.swift'

    end

  end

end
