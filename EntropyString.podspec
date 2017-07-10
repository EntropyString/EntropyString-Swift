# coding: utf-8

Pod::Spec.new do |s|
  s.name         = "EntropyString"
  s.version      = "0.3.5"
  s.summary      = "Efficiently generate secure strings of specified entropy from various character sets."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
Efficiently generate secure strings of specified entropy from various character sets for use when probabilisticly unique string identifiers are needed. Entropy is specified by total number of strings and acceptable risk of a repeat.
                   DESC

  s.homepage = "https://github.com/#{s.name}/#{s.name}-Swift"
  s.license  = { :type => "MIT", :file => "LICENSE" }
  s.authors   = { "knoxen" => "paul@knoxen.com", "dingo sky" => "paul@dingosky.com" }
  # s.authors            = { "dingo sky" => "paul@dingosky.com" }
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


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source = { :git => "https://github.com/EntropyString/EntropyString-Swift.git", :tag => "#{s.version}" }

  s.source_files  = "Sources/**/*.swift"
#   s.public_header_files = "#{s.name}/{s.name}.h"

  # s.dependency "JSONKit", "~> 1.4"

end
