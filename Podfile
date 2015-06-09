source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '6.0'

xcodeproj 'Candygirl'

pod 'ASIHTTPRequest', '~> 1.8.2' #, :inhibit_warnings => true

post_install do |installer_representation|
  installer_representation.project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
    end
  end
end
