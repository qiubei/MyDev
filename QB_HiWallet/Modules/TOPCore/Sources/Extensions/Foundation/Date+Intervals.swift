//
//  Date+Intervals.swift
//  TOP
//
//  Created by Jax on 10/26/18.
//  Copyright © 2018 TOP. All rights reserved.
//

import Foundation

public enum DateIntervalInSeconds {
    public static var minute: TimeInterval = 60
    public static var hour: TimeInterval = minute * 60
    public static var day: TimeInterval = hour * 24
}

public extension Date {
    /// get string with specific formate
    /// - Parameter dateFormatter: date formate like "yyyy-MM-dd HH:mm"
    /// - Parameter timezone: the defalut timezone is Beijing
    func string(custom dateFormatter: String, timezone: TimeZone = TimeZone.init(secondsFromGMT: 28800)!)-> String {
        let format = DateFormatter()
        format.dateFormat = dateFormatter
        format.timeZone = timezone
        return format.string(from: self)
    }
}

public extension String {
    /// convert current date string  to Date with the string format
    /// return nil if it's inconsistent between data string format and the parameter format.
    /// - Parameter format: date format
    func date(format: String, timezone: TimeZone = TimeZone.init(secondsFromGMT: 28800)!) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timezone
        return formatter.date(from: self)
    }
}

extension String {
    
    /// url encoding
    func urlEncode() -> String {
        var str = ""
        for (_, character) in self.enumerated() {
            
            // 注意字符串内 \ 是转义字符
            if "!#$%&’()*+,-./:;<=>?@[]^_`{|}~\\".contains(character) {
                let sub = "\(character)".toHexString()
                str += "%" + sub.uppercased()
                continue
            }
            str += "\(character)"
        }
        
        return str
    }
}
