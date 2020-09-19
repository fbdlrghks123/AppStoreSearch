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
    
    let nowDate = Date()
    let calendar = Calendar.current
    let units: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
    let components = (calendar as NSCalendar)
      .components(units, from: date, to: nowDate, options: [])
    
    if let year = components.year, year >= 1 {
      return "\(year)년 전"
    }
    
    if let month = components.month, month >= 1 {
      return "\(month)개월 전"
    }
    
    if let week = components.weekOfYear, week >= 1 {
      return "\(week)주 전"
    }
    
    if let day = components.day, day >= 1 {
      return "\(day)일 전"
    }
    
    if let hour = components.hour, hour >= 1 {
      return "\(hour)시간 전"
    }
    
    if let minute = components.minute, minute >= 1 {
      return "\(minute)분 전"
    }
    
    if let second = components.second, second >= 3 {
      return "\(second)초 전"
    }
    
    return "방금 전"
  }
}
