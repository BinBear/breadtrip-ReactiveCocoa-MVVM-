source 'https://cdn.cocoapods.org/'

install! 'cocoapods',
         :generate_multiple_pod_projects => true

deployment_target = '11.0'
platform :ios, deployment_target

inhibit_all_warnings!
use_frameworks!


def hearttrip_services
  # 基础组件
  pod 'VinBaseComponents', :git => 'https://github.com/BinBear/VinBaseComponents.git'
  pod 'FoldingTabBar', :git => 'https://github.com/BinBear/FoldingTabBar.iOS.git'
end


target 'HeartTrip' do

  # 服务组件
  hearttrip_services
  
  # 三方组件
  pod 'QMUIKit'
  pod 'KafkaRefresh'
  pod 'Masonry'
  pod 'IQKeyboardManager'
  pod 'SDWebImage'
  pod 'iCarousel'
  pod 'lottie-ios'
  pod 'Texture'
  pod 'YYModel'
  pod 'YYCategories'
  pod 'LBXPermission'
  pod 'Bugly'
  pod 'FluentDarkModeKit'
  pod 'LookinServer', :configurations => ['Debug']
  pod 'DoraemonKit/Core', :configurations => ['Debug']

end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
            end
        end
        project.build_configurations.each do |bc|
            bc.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
        end
    end
end
