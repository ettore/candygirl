source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '4.3'

xcodeproj 'Candygirl'

def common_pods
  pod 'ASIHTTPRequest', :inhibit_warnings => true
end

target "Candygirl" do
  common_pods
end

target "CandygirlTests" do
  common_pods
end

post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
    end
  end
end
