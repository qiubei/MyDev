//
//  DateFormatter.swift
//  TOP
//
//  Created by Jax on 10/30/18.
//  Copyright © 2018 TOP. All rights reserved.
//

import Foundation


public class DateFormatterChanger {
    private let input: DateFormatter
    private let output: DateFormatter
    
    init(from: DateFormat, to: DateFormat) {
        input = DateFormatter(formate: from)
        output = DateFormatter(formate: to)
    }
    
    public func formate(date: String) -> String? {
        guard let inputDate = input.date(from: date) else { return nil }
        return output.string(from: inputDate)
    }
}
