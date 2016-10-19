platform :ios, '9.0'
use_frameworks!

target 'DribbbleApp' do
    pod 'FontAwesome.swift', git: 'https://github.com/thii/FontAwesome.swift.git', branch: 'master', submodules: true
#   platform :ios, '8.0'      # or platform :osx, '10.9'
    pod 'p2.OAuth2', :git => 'https://github.com/p2/OAuth2', :submodules => true
#   pod 'OAuthSwift', :git => 'https://github.com/OAuthSwift/OAuthSwift.git', :branch => 'swift3.0'
#   pod 'OAuthSwift', '~> 0.5.0'
    pod 'Alamofire', '~> 4.0'
    pod 'AlamofireImage', '~> 3.0'
    pod 'MBProgressHUD', '~> 1.0.0'
    pod 'SDWebImage', '~>3.8'
    pod 'Realm', '= 1.1.0' # git: 'git@github.com:realm/realm-cocoa.git', branch: 'master', submodules: true
    pod 'RealmSwift', '~> 1.1' #, :git => 'https://github.com/realm/realm-cocoa.git', :branch => 'master', submodules: true
#    pod 'ReactiveCocoa'

#    pod 'RxSwift'
#    pod 'RxCocoa'
    pod 'RxSwift',    '~> 3.0.0-beta.1'
    pod 'RxCocoa',    '~> 3.0.0-beta.1'
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'
                config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.10'
            end
        end
    end
    pod "RxRealm", git: 'https://github.com/RxSwiftCommunity/RxRealm.git', branch: 'master', submodules: true
    #
    #pod "PagingMenuController"


end
