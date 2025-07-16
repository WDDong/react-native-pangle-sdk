Pod::Spec.new do |s|
  s.name         = 'MyPangleSDK'
  s.version      = '1.0.2'
  s.summary      = 'Pangle SDK bridge for React Native'
  s.description  = 'Wraps Pangle iOS SDK initialization & ads for RN.'
  s.homepage     = 'https://github.com/WDDong'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'WDDong' => 'meng0928dong@163.com' }
  s.platform     = :ios, '11.0'
  s.source       = { :path => '.' }
  s.source_files = 'Classes/**/*.{h,m}'
  s.dependency   'React-Core'
  s.dependency   'Ads-Global', '5.7.0.6'
end
