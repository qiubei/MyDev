//
//  BrainDataHandle.swift
//  InnerpeaceSDK-Example
//
//  Created by Anonymous on 2018/8/28.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

import Foundation
import NaptimeFileProtocol

final class BrainDataHandle {
    let fileName: String
    private let _queue = DispatchQueue(label: "cn.entertech.v3.file")
    private let _filewriter: BrainwaveFileWriterV2<BrainwaveValue24> = {
        let _writer = BrainwaveFileWriterV2<BrainwaveValue24>()
        _writer.dataVersion = "3.0.0"
        return _writer
        }()

    // 分片定时器
    private var _fragmentTimer: DispatchSourceTimer?

    init(fileName: String) {
        self.fileName = fileName
        let url = FileManager.default.dataDirectory.appendingPathComponent("\(fileName).raw")
        _queue.async { [weak self] in
            guard let `self` = self else { return }
            do
                {
                    try self._filewriter.createFile(url)
            } catch {
                print("brain data file create error: \(error)")
            }
            self._fragmentTimer = DispatchSource.makeTimerSource(flags: .strict, queue: self._queue)
            self._fragmentTimer?.setEventHandler(handler: { [weak self] in
                guard let `self` = self else { return }
            })
        }
    }

//    func handleData(_ bytes: Data) {
//        bytes.copiedBytes.arraySplit(3)
//    }


}
