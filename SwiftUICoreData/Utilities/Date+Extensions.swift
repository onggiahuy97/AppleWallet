//
//  Date+Extensions.swift
//  Date+Extensions
//
//  Created by Huy Ong on 7/24/21.
//

import Foundation

extension Date {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
}
