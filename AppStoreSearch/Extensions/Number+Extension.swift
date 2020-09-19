//
//  Int+Extension.swift
//  AppStoreSearch
//
//  Created by RIH on 2020/09/17.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

extension Int {
  var ratingString: String {
    if (self / 10000) >= 1 {
      let tensThousands: Float = (Float(self) / 10000.0)
      return String(format: "%0.1f만", tensThousands)
    }
    
    if (self / 1000) >= 1 {
      let thousands: Float = (Float(self) / 1000.0)
      return String(format: "%0.1f만", thousands)
    }
    
    return "\(self)"
  }
}

extension NSNumber {
  var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}
