//
//  DFU.swift
//  BLESDK
//
//  Created by HyanCat on 2018/5/23.
//  Copyright © 2018 EnterTech. All rights reserved.
//

import Foundation
import CoreBluetooth
import iOSDFULibrary

class DFU: DFUServiceDelegate, DFUProgressDelegate {

    var fileURL: URL!

    private let peripheral: CBPeripheral
    private let manager: CBCentralManager

    init(peripheral: CBPeripheral, manager: CBCentralManager) {
        self.peripheral = peripheral
        self.manager = manager
    }

    private (set) var state: DFUState = .none {
        didSet {
            NotificationName.dfuStateChanged.emit([.dfuStateKey: state])
        }
    }

    func fire() {
        let initiator = DFUServiceInitiator(centralManager: manager, target: peripheral)
        initiator.delegate = self
        initiator.progressDelegate = self
        initiator.enableUnsafeExperimentalButtonlessServiceInSecureDfu = true
        let firmware = DFUFirmware(urlToZipFile: fileURL, type: DFUFirmwareType.application)

        _ = initiator.with(firmware: firmware!).start()
    }

    func dfuStateDidChange(to state: iOSDFULibrary.DFUState) {
        print("dfu state: \(state.description())")
        switch state {
        case .connecting:
            self.state = .prepared
        case .starting:
            self.state = .prepared
        case .enablingDfuMode:
            self.state = .prepared
        case .uploading:
            self.state = .prepared
        case .validating:
            self.state = .prepared
        case .disconnecting:
            break
        case .completed:
            self.state = .succeeded
        case .aborted:
            self.state = .failed
        }
    }

    func dfuError(_ error: DFUError, didOccurWithMessage message: String) {
        self.state = .failed
    }

    func dfuProgressDidChange(for part: Int, outOf totalParts: Int, to progress: Int, currentSpeedBytesPerSecond: Double, avgSpeedBytesPerSecond: Double) {
        self.state = .upgrading(progress: UInt8(progress))
    }
}
