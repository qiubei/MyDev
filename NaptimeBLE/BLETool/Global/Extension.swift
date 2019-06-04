//
//  Extension.swift
//  NaptimeBLE
//
//  Created by NyanCat on 27/10/2017.
//  Copyright © 2017 EnterTech. All rights reserved.
//

import Foundation
import RxBluetoothKit
import NaptimeBLE

extension Data {
    var hexString: String {
        return self.enumerated().map({ (offset, element) -> String in
            String(format: "0x%02X ", element)
        }).joined()
    }
}

protocol Displayable {
    var displayName: String { get }
}

extension Peripheral: Displayable {
    var displayName: String {
        return self.name ?? "Null"
    }
}

extension BLEService: Displayable {
    var displayName: String {
        if let type = (self as? ServiceTypable)?.serviceType {
            switch type {
            case .connect:
                return "Connection Service"
            case .command:
                return "Command Service"
            case .battery:
                return "Battery Service"
            case .eeg:
                return "EEG Service"
            case .dfu:
                return "DFU Service"
            case .deviceInfo:
                return "Device Service"
            }
        }
        return "Unknown"
    }
}

extension BLEService: UUIDType {
    public var uuid: String {
        if let type = (self as? ServiceTypable)?.serviceType {
            return type.rawValue
        }
        return "Unknown"
    }
}

//extension NaptimeBLE.Characteristic.DeviceInfo: Displayable {
//    var displayName: String {
//        switch self {
//        case .mac:
//            return "MAC 地址"
//        case .serial:
//            return "序列号"
//        case .firmwareRevision:
//            return "固件版本"
//        case .hardwareRevision:
//            return "硬件版本"
//        case .manufacturer:
//            return "制造商"
//        }
//    }
//}

//extension NaptimeBLE.Characteristic.Battery: Displayable {
//    var displayName: String {
//        switch self {
//        case .battery:
//            return "电池电量"
//        }
//    }
//}

extension RxBluetoothKit.Characteristic: Displayable {
    var displayName: String {
        switch self.uuid.uuidString {
        case NaptimeBLE.Characteristic.DeviceInfo.mac.rawValue:
            return "MAC Address"
        case NaptimeBLE.Characteristic.DeviceInfo.serial.rawValue:
            return "Serial No."
        case NaptimeBLE.Characteristic.DeviceInfo.firmwareRevision.rawValue:
            return "Firmware Version"
        case NaptimeBLE.Characteristic.DeviceInfo.hardwareRevision.rawValue:
            return "Hardware Version"
        case NaptimeBLE.Characteristic.DeviceInfo.manufacturer.rawValue:
            return "Manufacturer"
        case NaptimeBLE.Characteristic.Battery.battery.rawValue:
            return "Battery"
        default:
            return "Any"
        }
    }
}
