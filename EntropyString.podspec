# coding: utf-8

Pod::Spec.new do |s|
  s.name         = "EntropyString"
  s.version      = "2.3.0"
  s.summary      = "Efficiently generate cryptographically strong random strings of specified entropy from various character sets."

  s.description = <<-DESC
Efficiently generate cryptographically strong and secure random strings of specified entropy from various character sets for use when probabilisticly unique string identifiers are needed. Entropy is calculated from a total number of strings and acceptable risk of a repeat.
                   DESC

  s.homepage = "https://github.com/EntropyString/EntropyString-Swift"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.authors = { "knoxen" => "paul@knoxen.com", "dingo sky" => "paul@dingosky.com" }
  s.social_media_url = "http://twitter.com/knoxen"

  s.ios.deployment_target = "9.0"
  s.osx.deployment_target = "10.11"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.source = { :git => "https://github.com/EntropyString/EntropyString-Swift.git", :tag => "#{s.version}" }

  s.source_files = "Sources/*.swift"
#   s.public_header_files = "#{s.name}/{s.name}.h"

end
