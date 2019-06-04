Pod::Spec.new do |s|
    s.name = 'InnerpeaceSDK'
    s.version = '0.2.1'
    s.summary = 'Innerpeace SDK'
    s.description = <<-DESC
    易休软硬件服务基础 SDK。
    DESC
    s.homepage = 'https://github.com/HyanCat'
    s.authors = {
    'HyanCat' => 'hyancat@live.cn'
    }
    s.license = { :type => 'Copyright', :text => 'Copyright HyanCat All Right Reserved.' }
    s.source = { :git => 'https://github.com/HyanCat/Innerpeace-BLE-SDK.git' }
    s.platform = :ios, '8.0'
    s.swift_version = '4.2'

    s.dependency 'RxBluetoothKit', '~> 5.0.2'
    # s.dependency 'PromiseKit', '6.4.0'
    s.dependency 'Zip'

    s.default_subspec = 'BLE'

    s.subspec 'BLE' do |ble|
        ble.vendored_frameworks = 'frameworks/*.framework'
    end

    s.subspec 'Concentration' do |concentration|
        concentration.dependency 'InnerpeaceSDK/BLE'
        concentration.user_target_xcconfig = { "SWIFT_ACTIVE_COMPILATION_CONDITIONS"  => "CONCENTRATION" }
    end

    s.subspec 'Nap' do |nap|
        nap.dependency 'InnerpeaceSDK/BLE'
        nap.user_target_xcconfig = { "SWIFT_ACTIVE_COMPILATION_CONDITIONS"  => "NAP" }
    end

end
