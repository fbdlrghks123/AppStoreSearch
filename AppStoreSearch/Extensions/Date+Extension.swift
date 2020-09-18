//
//  Date+Extension.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/18.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

extension Date {
  
  static func appleStringToDate(_ dateString: String?) -> Date? {
    guard let dateString = dateString else { return nil}
    
    if dateString.isEmpty { return nil }
    return stringToDate(dateString, dateFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
  }
  
  static func stringToDate(_ dateString: String, dateFormat: String) -> Date? {
    let dateFormatter = DateFormatter().then {
      $0.dateFormat = dateFormat
      $0.timeZone = .current
    }
    return dateFormatter.date(from: dateString)
  }
  
  static func timeAgoSince(_ date: Date?) -> String {
    guard let date = date else { return "" }
    
    let calendar = Calendar.current
    let now = Date()
    let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
    let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
    
    if let year = components.year, year >= 1 {
      return "\(year)\(NSLocalizedString("년 전", comment: ""))"
    }
    
    if let month = components.month, month >= 1 {
      return "\(month)\(NSLocalizedString("개월 전", comment: ""))"
    }
    
    if let week = components.weekOfYear, week >= 1 {
      return "\(week)\(NSLocalizedString("주 전", comment: ""))"
    }
    
    if let day = components.day, day >= 1 {
      return "\(day)\(NSLocalizedString("일 전", comment: ""))"
    }
    
    if let hour = components.hour, hour >= 1 {
      return "\(hour)\(NSLocalizedString("시간 전", comment: ""))"
    }
    
    if let minute = components.minute, minute >= 1 {
      return "\(minute)\(NSLocalizedString("분 전", comment: ""))"
    }
    
    if let second = components.second, second >= 3 {
      return "\(second)\(NSLocalizedString("초 전", comment: ""))"
    }
    
    return NSLocalizedString("지금", comment: "")
  }
}
