//
//  AudioDataPool.swift
//  BLESDK
//
//  Created by Anonymous on 2019/1/3.
//  Copyright © 2019 EnterTech. All rights reserved.
//

import Foundation

extension DispatchQueue {
    static let audio_queue = DispatchQueue(label: "cn.entertech.audio.record.pool")
}

class AudioDataPool {
    private var _data = Data()

    var count: Int {
        return _data.count
    }

    var isEmpty: Bool {
        return _data.count == 0
    }

    var isAvailable: Bool {
        return _data.count > 0
    }

    func push(data: Data) {
        DispatchQueue.audio_queue.sync {
            _data.append(data)
        }
    }

    func pop(length: Int) -> Data {
        var subData = Data()
        DispatchQueue.audio_queue.sync {
            let _min = min(length, _data.count)
            let _max = max(length, _data.count)
            subData = _data.subdata(in: 0..<_min)
            _data = _data.subdata(in: _min..<_max)
        }
        return subData
    }

    func dry() {
        DispatchQueue.audio_queue.sync {
            _data.removeAll()
        }
    }
}
