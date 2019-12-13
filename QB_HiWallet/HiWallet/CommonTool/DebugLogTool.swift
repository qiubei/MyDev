//
//  DebugLogTool.swift
//  HiWallet
//
//  Created by Jax on 2019/9/23.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation

//封装的日志输出功能（T表示不指定日志信息参数类型）
func DLog<T>(_ message:T, file:String = #file, function:String = #function,
           line:Int = #line) {
    #if DEBUG
        //获取文件名
        let fileName = (file as NSString).lastPathComponent
        //打印日志内容
        print("\n\(fileName): \(line) Line \(function)  \n \(message)\n")    #endif
}
