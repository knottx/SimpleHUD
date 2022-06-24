Pod::Spec.new do |spec|

  spec.name         = "SimpleHUD"
  spec.version      = "1.7.0"
  spec.summary      = "Simple HUD"

  spec.homepage     = "https://github.com/knottx/SimpleHUD"
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { "Visarut Tippun" => "knotto.vt@gmail.com" }
  spec.source       = { :git => "https://github.com/knottx/SimpleHUD.git", :tag => "#{spec.version}" }
  
  spec.swift_version   = "5.1"
  spec.ios.deployment_target = "10.0"
  spec.source_files  = "Sources/SimpleHUD/**/*.swift"
  spec.requires_arc  = true

end
