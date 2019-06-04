//
//  ConnectTipViewController.swift
//  InnerpeaceSDK-Example
//
//  Created by Anonymous on 2018/6/8.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

import UIKit
import Lottie
import SnapKit
import AVFoundation

class ConnectTipViewController: UIViewController {

    @IBOutlet weak var imageview: UIImageView!
    private var lottieAnimationView: LOTAnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.layout()
    }

    private func setupViews() {
        self.lottieAnimationView = LOTAnimationView(name: "配对演示")
        lottieAnimationView.loopAnimation = true
        self.view.addSubview(lottieAnimationView)
        lottieAnimationView.play()
    }

    private func layout() {
        lottieAnimationView.snp.makeConstraints {
            $0.edges.equalTo(self.imageview)
        }
    }

    private let testRadioPath = Bundle.main.path(forResource: "five", ofType: "mp3")!
    var player: AVAudioPlayer?
    private func test() {
        player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: self.testRadioPath))
        player!.prepareToPlay()
        sleep(2)
        player!.play()
    }
}
