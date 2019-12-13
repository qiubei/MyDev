//
//  ImportWalletController.swift
//  HiWallet
//
//  Created by apple on 2019/5/29.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import UIKit
import TOPCore

class ImportWalletController: BaseViewController,TabbedButtonsViewDelegate {
    var textView: RSKPlaceholderTextView! = RSKPlaceholderTextView()
    @IBOutlet weak var trickTextview: UIView!
    @IBOutlet weak var tabbedButtonView: TabbedButtonsView!
    @IBOutlet weak var pasteButton: UIButton!
    @IBOutlet weak var importTipLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    var selectIndex = 0
    
    var currentIndex = 0 {
        didSet {
            tabbedButtonView.selectedIndex = currentIndex
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tabbedButtonView.delegate = self
        textView.textColor = App.Color.cellTitle
        textView.font = UIFont.systemFont(ofSize: 14)
    }
    
    override func localizedString() {
        super.localizedString()
        title = "导入钱包_title".localized()
        importTipLabel.text = "导入助记词".localized()
        textView.placeholder = "输入助记词，用空格分隔".localized() as NSString
        pasteButton.setTitle("粘贴".localized(), for: .normal)
        nextButton.setTitle("下一步".localized(), for: .normal)
    }
    
    override func layout() {
        self.trickTextview.addSubview(textView)
        textView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @IBAction func pasteButtonClick(_ sender: Any) {
        textView.text = UIPasteboard.general.string
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if selectIndex == 0 {
            let mnemonicStr = textView.text.trimmingCharacters(in: CharacterSet.whitespaces)
            if self.isValid(mnemonic: mnemonicStr){
                let controller: AuthenticationViewController = UIStoryboard(name: .authentication).instantiateViewController()
                controller.handleType = .setPassword
                controller.importMnemonic = mnemonicStr
                controller.modalPresentationStyle = .fullScreen
                present(controller, animated: true, completion: nil)
            } else {
                Toast.showToast(text: "助记词不正确".localized())
            }
        }
    }
    
    func isValid(mnemonic:String) -> Bool {
        
        let mnemonicWordCountNeeded = 12
        let mnemonicWords = mnemonic.components(separatedBy: " ")
        let allowedWords = Set<String>(WordList.english.words)
        let enteredMnemonicAllowedWords = mnemonicWords.map { return allowedWords.contains($0) }.filter{ return $0 == true}
        let isAllowed12Words = enteredMnemonicAllowedWords.count == mnemonicWordCountNeeded
        if isAllowed12Words && mnemonicWords.count == mnemonicWordCountNeeded{
            return true
        } else {
            return false
        }
    }
}

extension ImportWalletController {
    
    func tabbedButtonsView(_ view: TabbedButtonsView, didSelectButtonAt index: Int) {
        
        selectIndex = index
        textView.text = ""
        if index == 0 {
            textView.placeholder = "请输入助记词！".localized() as NSString
            pasteButton.isHidden = true
        } else {
            textView.placeholder = "请输入私钥".localized() as NSString
            pasteButton.isHidden = false
        }
    }
}
