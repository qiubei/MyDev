//
//  MnemonicVerifyViewModel.swift
//  HiWallet
//
//  Created by Anonymous on 2019/11/19.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import TOPCore

typealias MnemonicVerifyAction = (_ pickedlist: [Int: String], _ remainedList: [String]) -> Void
fileprivate typealias Question = (target: Int, answer: Int?)

enum MnenonicVerifyReslut {
    case success
    case failure(_ error: MnemonicVerifyError)
}

enum MnemonicVerifyError {
    case empty
    case mismatch
}

class MnemonicVerifyViewModel {
    var randomList: [String] = []
    let wordlist: [String]
    private var questions: [Question] = []
    private let verifyNum: Int
    init(mnemonic: String, verifyNumber: Int = 3) {
        verifyNum = verifyNumber
        wordlist = mnemonic.split(separator: " ").map { String($0) }
        random()
    }

    private func random() {
        for item in wordlist {
            let randomIndex = Int(arc4random_uniform(UInt32(randomList.count)))
            randomList.insert(item, at: randomIndex)
        }

        while questions.count < verifyNum {
            let randomIndex = Int(arc4random_uniform(UInt32(wordlist.count)))
            if questions.contains(where: { $0.target == randomIndex}) {
                continue
            }
            let q: Question = (randomIndex, nil)
            questions.append(q)
        }
        
        // sorted by target
        questions = questions.sorted { $0.target < $1.target }
    }

    func loadRandomData(block: MnemonicVerifyAction) {
        var pickedList: [Int: String] = [:]
        var remainedList: [String] = randomList
        for q in questions {
            if let index = q.answer {
                let item = wordlist[index]
                pickedList[q.target] = item
                remainedList = remainedList.filter { $0 != item}
            } else {
                pickedList[q.target] = ""
            }
        }
        
        
        block(pickedList, remainedList)
    }

    func didSelect(selectedItem: String, completion: MnemonicVerifyAction) {
                if let selectedIndex = wordlist.firstIndex(of: selectedItem) {
            for (index, value) in questions.enumerated() {
                if value.answer == nil {
                    questions[index].answer = selectedIndex
                    break
                }
            }
        }

        loadRandomData(block: completion)
    }

    func deselected(deselectedItem: String, completion: MnemonicVerifyAction) {
        if let deselectedIndex = wordlist.firstIndex(of: deselectedItem) {
            for (index, value) in questions.enumerated() {
                if value.answer == deselectedIndex {
                    questions[index].answer = nil
                    break
                }
            }
        }
        
        loadRandomData(block: completion)
    }

    func verifyMnemonic(completion: (MnenonicVerifyReslut) -> ()) {
        if questions.filter({ $0.answer != nil }).count == 0 {
            completion(MnenonicVerifyReslut.failure(.empty))
            return
        }
        for q in questions {
            if q.target != q.answer {
                completion(MnenonicVerifyReslut.failure(.mismatch))
                return
            }
        }
        completion(MnenonicVerifyReslut.success)
    }
}
