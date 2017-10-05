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

  # === SERVICES

  s.subspec 'Services' do |srv|

    srv.osx.deployment_target    = '10.11'
    srv.ios.deployment_target    = '9.0'

    srv.dependency                 s.name + '/Core'
  
    # ===

    srv.subspec 'BundleInfo' do |bi|
    
      bi.framework               = 'Foundation'

      bi.dependency                'PMJSON', '~> 2.0'
      bi.dependency                'XCERequirement', '~> 1.6'

      bi.source_files            = 'Sources/Services/BundleInfo.swift'

    end

  end

  # === MODELS

  s.subspec 'Models' do |mds|

    mds.osx.deployment_target    = '10.11'
    mds.ios.deployment_target    = '9.0'

    mds.dependency                 s.name + '/Core'

    mds.dependency                 'XCEUniFlow/MVVM', '~> 4.8'
  
    # ===

    mds.subspec 'ServiceProvider' do |sp|
    
      sp.source_files            = 'Sources/Models/ServiceProvider.swift'

    end
  
    # ===

    mds.subspec 'ConcurrentProcess' do |cp|
    
      cp.framework               = 'Foundation'

      cp.dependency                'XCEOperationFlow', '~> 4.1'

      cp.source_files            = 'Sources/Models/ConcurrentProcess.swift'

    end
  
  end

  # === VIEW MODELS

  s.subspec 'ViewModels' do |vms|

    vms.osx.deployment_target    = '10.11'
    vms.ios.deployment_target    = '9.0'

    vms.dependency                 s.name + '/Core'

    vms.dependency                 'XCEUniFlow/MVVM', '~> 4.8'
  
    # ===

    vms.subspec 'RunOnceWithBundleInfo' do |ro|
    
      ro.dependency                 s.name + '/Services/BundleInfo'

      ro.source_files            = 'Sources/ViewModels/RunOnceWithBundleInfo.swift'

    end
  
    # ===

    vms.subspec 'RunIndefinitely' do |ri|
    
      ri.source_files            = 'Sources/ViewModels/RunIndefinitely.swift'

    end
  end

end
