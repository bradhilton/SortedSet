Pod::Spec.new do |s|
  s.name         = "SortedSet"
  s.version      = "3.0.0"
  s.summary      = "Native Swift Ordered Set"
  s.description  = <<-DESC
                    A native Swift implementation of a sorted set. Requires element to conform to `Comparable`.
                   DESC
  s.homepage     = "https://github.com/bradhilton/SortedSet"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Brad Hilton" => "brad@skyvive.com" }
  s.source       = { :git => "https://github.com/bradhilton/SortedSet.git", :tag => "3.0.0" }

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"

  s.source_files  = "Sources", "Sources/**/*.{swift,h,m}"
  s.requires_arc = true
end
