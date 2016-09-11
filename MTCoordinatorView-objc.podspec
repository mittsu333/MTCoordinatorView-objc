Pod::Spec.new do |s|
  s.name             = 'MTCoordinatorView-objc'
  s.version          = '0.8.0'
  s.summary          = 'The view coordinate arranged to the scrolling is adjusted.'
  s.homepage         = 'https://github.com/mittsuu/MTCoordinatorView-objc'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mittsu' => 'mittsu553@gmail.com' }
  s.source           = { :git => 'https://github.com/mittsuu/MTCoordinatorView-objc.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'MTCoordinatorView-objc/Classes/**/*'
end
