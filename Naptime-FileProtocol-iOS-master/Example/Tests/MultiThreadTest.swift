//
//  MultiThreadTest.swift
//  NaptimeFileProtocol
//
//  Created by HyanCat on 07/12/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

import Quick
import Nimble
import NaptimeFileProtocol

class MultiThreadSpec: QuickSpec {
    override func spec() {
        let documentURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileName = "test_multi_thread_\(Date().timeIntervalSince1970).test"
        let fileURL = documentURL.appendingPathComponent(fileName)

        describe("测试多线程写文件") {
            let fileWriter = DataFileWriter()
            try! fileWriter.createFile(fileURL)

            let str = "01234567890qwertyuiopasdfghjklzxcvbnm"
            let data = Data(bytes: str, count: str.lengthOfBytes(using: .utf8))
            let queue = DispatchQueue(label: "Test_File_Queue")

            it("多线程写入数据") {
                waitUntil(timeout: 30, action: { end in
                    queue.async {
                        try! fileWriter.writeData(data)
                        print("write in queue.")
                    }

                    try! fileWriter.writeData(data)
                    print("write in main.")

                    queue.async {
                        try! fileWriter.writeData(data)
                        print("write in queue.")
                    }

                    try! fileWriter.close()
                    print("close in main.")

                    queue.async {
                        try! fileWriter.writeData(data)
                        print("write in queue.")
                    }

                    try! fileWriter.writeData(data)
                    print("write in main.")

                    queue.async {
                        print("end in queue.")
                        end()
                    }
                })
            }
        }
        
        afterSuite {
            // 删除测试文件
            try! FileManager.default.removeItem(at: fileURL)
        }
    }
}
