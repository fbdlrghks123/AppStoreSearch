//
//  UIColor+Extension.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/17.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

extension UIColor {
  static func fromRed(_ red:Int, green:Int, blue:Int, alpha:CGFloat = 1.0) -> UIColor {
    let r = CGFloat(red) / 255.0
    let g = CGFloat(green) / 255.0
    let b = CGFloat(blue) / 255.0
    return UIColor(red: r, green: g, blue: b, alpha: alpha)
  }
}
