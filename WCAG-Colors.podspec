Pod::Spec.new do |s|
  s.name             = 'WCAG-Colors'
  s.version          = '1.0.0'
  s.summary          = 'A Swift library for calculating high contrast colors, contrast ratios, and WCAG 2.1 conformance levels.'

  s.description      = <<-DESC
  The *Web Content Accessibility Guidelines* (WCAG) define minimum contrast ratios for a text and its background. The WCAG-Colors framework extends `UIColor` and `NSColor` with functionality to calculate high contrast colors, contrast ratios, and WCAG 2.1 conformance levels. Using these APIs within your apps will help people with visual disabilities to perceive content.
                       DESC

  s.homepage         = 'https://github.com/chrs1885/WCAG-Colors'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chrs1885' => 'chrs1885@gmail.com' }
  s.source           = { :git => 'https://github.com/chrs1885/WCAG-Colors.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/chr_wendt'

  s.ios.deployment_target = '12.0'

  s.source_files = 'WCAG-Colors/Classes/**/*'
  
  s.swift_version = '5.0'

  s.framework = 'Foundation'
  s.ios.framework = s.tvos.framework = s.watchos.framework = 'UIKit'
  s.osx.framework = 'AppKit'

  s.ios.deployment_target = '12.0'
  s.tvos.deployment_target = '12.0'
  s.watchos.deployment_target = '5.0'
  s.osx.deployment_target = '10.14'
end
