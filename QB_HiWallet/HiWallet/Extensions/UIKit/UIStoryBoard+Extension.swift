//
//  UIStoryBoard+Extension.swift
//  HiWallet
//
//  Created by apple on 2019/5/28.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    enum Name: String {
        case webBrowser
        case touchIDOpen
        case hotCoinController
        case authentication

        var capitalized: String {
            let capital = String(rawValue.prefix(1)).uppercased()
            return capital + rawValue.dropFirst()
        }
    }

    class func main(name: String? = "Main", bundle: Bundle? = Bundle.main) -> UIStoryboard {
        return .init(name: name ?? "Main", bundle: bundle)
    }

    func initViewController(name: Name) -> UIViewController? {
        DLog(name.capitalized)
        return instantiateViewController(withIdentifier: name.capitalized)
    }

    convenience init(name: Name, bundle storyboardBundleOrNil: Bundle? = nil) {
        self.init(name: name.capitalized, bundle: nil)
    }

    func instantiateViewController<VC: UIViewController>() -> VC {
        guard let controller = instantiateViewController(withIdentifier: VC.storyboardIdentifier) as? VC else {
            fatalError("Error - \(#function): \(VC.storyboardIdentifier)")
        }
        return controller
    }
}

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: classForCoder())
    }
}

extension UIViewController: StoryboardIdentifiable {}
