//
//  UIColor+Extension.swift
//  NetworkPractice
//
//  Created by 김성민 on 6/5/24.
//

import UIKit

extension UIColor {
    static func random() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
