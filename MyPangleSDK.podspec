Pod::Spec.new do |s|
  s.name         = 'MyPangleSDK'
  s.version      = '1.0.0'
  s.summary      = 'Pangle SDK bridge for React Native'
  s.description  = 'Wraps Pangle iOS SDK initialization & ads for RN.'
  s.homepage     = 'https://your-homepage.com'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Your Name' => 'you@example.com' }
  s.platform     = :ios, '11.0'
  s.source       = { :path => '.' }
  s.source_files = 'Classes/**/*.{h,m}'
  s.dependency   'React-Core'
  s.dependency   'Ads-Global', '5.7.0.6'
end
