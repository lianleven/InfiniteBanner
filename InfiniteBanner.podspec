Pod::Spec.new do |s|
  s.name         = 'InfiniteBanner'
  s.version      = '1.0.4'
  s.summary      = 'Infinite banner by UICollectionView'
  s.homepage     = 'https://github.com/lianleven/'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors       = { 'lianleven' => 'lianleven@163.com' }
  s.source       = { :git => 'https://github.com/lianleven/InfiniteBanner.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.platform     = :ios, '10.0'
  s.source_files  = ["InfiniteBanner/*.swift", "InfiniteBanner/InfiniteBanner.h"]
  s.public_header_files = ["InfiniteBanner/InfiniteBanner.h"]
  s.dependency "Kingfisher"
  s.swift_versions = '5.0'
  s.requires_arc = true
end


