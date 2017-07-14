# coding: utf-8

Pod::Spec.new do |s|
  s.name         = "EntropyString"
  s.version      = "0.5.1"
  s.summary      = "Efficiently generate cryptographically strong random strings of specified entropy from various character sets."

  s.description  = <<-DESC
Efficiently generate cryptographically strong and secure random strings of specified entropy from various character sets for use when probabilisticly unique string identifiers are needed. Entropy is calculated from a total number of strings and acceptable risk of a repeat.
                   DESC

  s.homepage = "https://github.com/#{s.name}/#{s.name}-Swift"
  s.license  = { :type => "MIT", :file => "LICENSE" }
  s.authors   = { "knoxen" => "paul@knoxen.com", "dingo sky" => "paul@dingosky.com" }
  # s.social_media_url   = "http://twitter.com/knoxen"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # s.platform     = :ios
  # s.platform     = :ios, "5.0"

  #  When using multiple platforms
  s.ios.deployment_target = "9.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source = { :git => "https://github.com/EntropyString/EntropyString-Swift.git", :tag => "#{s.version}" }

  s.source_files  = "Sources/**/*.swift"
#   s.public_header_files = "#{s.name}/{s.name}.h"

end
