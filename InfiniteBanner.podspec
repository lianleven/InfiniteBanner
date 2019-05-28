Pod::Spec.new do |s|
  s.name         = 'InfiniteBanner'
  s.version      = '0.1'
  s.summary      = 'Infinite banner by UICollectionView'
  s.homepage     = 'https://github.com/lianleven/'
  #s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors       = { 'lianleven' => 'lianleven@163.com' }
  s.source       = { :git => 'https://github.com/lianleven/InfiniteBanner.git', :tag => s.version.to_s }
  s.ios.deployment_target = '7.0'
  s.platform     = :ios, '7.0'
  s.source_files = 'InfiniteBanner/**/*.{swift}'
  s.dependency "Kingfisher"
  s.requires_arc = true
end


