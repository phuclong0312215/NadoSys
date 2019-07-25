# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!
target 'NadoSys' do
    pod 'PureLayout'
    pod 'Alamofire'
    pod 'SwiftyJSON'
    pod 'IQKeyboardManagerSwift'
    pod 'MagicalRecord'
    pod 'Swinject'
    pod 'SwinjectStoryboard'
    pod 'ObjectMapper'
    pod 'CropViewController'
    pod 'Toast-Swift'
end
post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
