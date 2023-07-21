Pod::Spec.new do |s|
  s.name             = 'WCAG-Colors'
  s.version          = '2.0.0'
  s.summary          = 'A Swift library for calculating high contrast colors, contrast ratios, and WCAG 2.1 conformance levels.'

  s.description      = <<-DESC
  The *Web Content Accessibility Guidelines* (WCAG) define minimum contrast ratios for a text and its background. The WCAG-Colors framework extends `UIColor` and `NSColor` with functionality to calculate high contrast colors, contrast ratios, and WCAG 2.1 conformance levels. Using these APIs within your apps will help people with visual disabilities to perceive content.
                       DESC
 
  s.homepage = 'https://github.com/chrs1885/WCAG-Colors'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'Christoph Wendt' => 'chrs1885@gmail.com' }
  s.social_media_url = 'https://twitter.com/chr_wendt'
  s.source = { :git => 'https://github.com/chrs1885/WCAG-Colors.git', :tag => s.version }
  s.documentation_url = 'https://github.com/chrs1885/WCAG-Colors/blob/develop/Documentation/Reference/README.md'
  s.swift_versions = ['5.0']
  s.source_files = 'Sources/WCAG-Colors/**/*'
  
  s.framework = 'Foundation'
  s.ios.framework = s.tvos.framework = s.watchos.framework = 'UIKit'
  s.osx.framework = 'AppKit'

  s.ios.deployment_target = '14.0'
  s.tvos.deployment_target = '14.0'
  s.watchos.deployment_target = '6.0'
  s.osx.deployment_target = '11.0'
end
