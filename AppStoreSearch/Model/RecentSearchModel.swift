//
//  RecentSearchModel.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/16.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

struct RecentSearchModel: Decodable, Equatable {
  var text: String
  
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.text == rhs.text
  }
}
