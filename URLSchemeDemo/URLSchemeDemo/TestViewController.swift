//
//  TestViewController.swift
//  URLSchemeDemo
//
//  Created by Anonymous on 2019/12/11.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit


class TestViewController: UIViewController {
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func startAnimation(offset1: CGFloat, offset2: CGFloat, offset3: CGFloat) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.button1.transform = CGAffineTransform(translationX: 0, y: offset1)
            self.button2.transform = CGAffineTransform(translationX: 0, y: offset2)
            self.button3.transform = CGAffineTransform(translationX: 0, y: offset3)
        }, completion: nil)
    }
    
    func resumeAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.button1.transform = CGAffineTransform(translationX: 0, y: 0)
            self.button2.transform = CGAffineTransform(translationX: 0, y: 0)
            self.button3.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
    }
    
    private var isSelected = false
    @IBAction func buttonAction(_ sender: UIButton) {
        isSelected = !isSelected
        didSelected(index: sender.tag)
    }
    
    func didSelected(index: Int) {
        if isSelected {
            var offset1: CGFloat = 0
            var offset2: CGFloat = 0
            var offset3: CGFloat = 0
            switch index {
            case 1:
                offset1 = 80 - button1.frame.origin.y
                offset2 = UIScreen.main.bounds.height - button2.frame.height - button2.frame.origin.y
                offset3 = UIScreen.main.bounds.height - button3.frame.height * 0.64 - button3.frame.origin.y
            case 2:
                offset1 = UIScreen.main.bounds.height - button1.frame.height - button1.frame.origin.y
                offset2 = 80 - button2.frame.origin.y
                offset3 = UIScreen.main.bounds.height - button3.frame.height * 0.64 - button3.frame.origin.y
            case 3:
                offset1 = UIScreen.main.bounds.height - button1.frame.height - button1.frame.origin.y
                offset2 = UIScreen.main.bounds.height - button2.frame.height * 0.64 - button2.frame.origin.y
                offset3 = 80 - button3.frame.origin.y
            default: break
            }
            startAnimation(offset1: offset1, offset2: offset2, offset3: offset3)
        } else {
            resumeAnimation()
        }
    }
}

