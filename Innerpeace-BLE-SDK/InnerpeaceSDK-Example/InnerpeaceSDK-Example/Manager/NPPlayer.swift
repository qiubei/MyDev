//
//  NPPlayer.swift
//  InnerpeaceSDK-Example
//
//  Created by Anonymous on 2018/12/19.
//  Copyright © 2018 EnterTech. All rights reserved.
//

import Foundation
import AVFoundation


class NPPlayer {

    private var player: AVAudioPlayer?
    init(url: URL) {
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("create player error \(error)")
            self.player = nil
        }
    }

    func play() {
        self.player!.prepareToPlay()
        player?.numberOfLoops = -1
        player?.volume = 1.0
        self.player!.play()
    }

    func stop() {
        self.player?.stop()
        self.player = nil
    }

    func pause() {
        self.player!.pause()
    }
}


