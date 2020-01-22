platform :ios, '11.0'
inhibit_all_warnings!
use_frameworks!

ENV['COCOAPODS_DISABLE_STATS'] = "true"

workspace 'HiWallet.xcworkspace'

source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'


def pod_database
  pod 'RealmSwift'
  pod 'KeychainAccess'

end


def pod_Tool
  pod 'Then'
  pod 'BlocksKit'
  pod 'SwiftyUserDefaults'
  pod 'SnapKit'
  pod 'SDWebImage'
  pod 'EFQRCode'
  pod 'IQKeyboardManagerSwift'
end

def pod_UI
  pod 'BulletinBoard'
  pod 'Toast-Swift'
  pod 'SVProgressHUD'
  pod 'ESPullToRefresh'
  pod 'LYEmptyView'
end

def pod_core
  pod 'essentia-bridges-api-ios'
  pod 'essentia-network-core-ios'
  pod 'Moya'
  pod 'SwiftyJSON'
  pod 'CryptoSwift'
  pod 'secp256k1.swift'
  pod 'HandyJSON'

end


def pod_Analytics
  pod 'Firebase/Analytics'
  pod 'Crashlytics'
end


target 'TOPCore' do
  project 'Modules/TOPCore/TOPCore.xcodeproj'
  use_frameworks!
  pod_core
  pod_database

end

target 'HiWallet' do

  use_frameworks!
  pod_database
  pod_core
  pod_UI
  pod_Analytics
  pod_Tool
  # Pods for HiWallet

end


post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED'] = 'YES'
  end
end