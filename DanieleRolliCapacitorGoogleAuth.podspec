
  Pod::Spec.new do |s|
    s.name = 'DanieleRolliCapacitorGoogleAuth'
    s.version = '0.0.1'
    s.summary = 'Google Auth plugin for capacitor.'
    s.license = 'MIT'
    s.homepage = 'https://github.com/Daniele-rolli/CapacitorGoogleAuth'
    s.author = { 'CodetrixStudio' => '', 'Daniele Rolli' => 'danielerolli@proton. me' }
    s.source = { :git => 'https://github.com/Daniele-rolli/CapacitorGoogleAuth', :tag => s.version.to_s }
    s.source_files = 'ios/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
    s.ios.deployment_target = '14.0'
    s.dependency 'Capacitor'
    s.dependency 'GoogleSignIn', '~> 7.0'
    s.static_framework = true
  end
