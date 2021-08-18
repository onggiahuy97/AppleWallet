//
//  UIColorExtensions.swift
//  UIColorExtensions
//
//  Created by Huy Ong on 7/21/21.
//

import UIKit

extension UIColor {
    class func color(data: Data) -> UIColor? {
        return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor
    }
    
    func encode() -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }
}
