//
//  RecentSearchSection.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/16.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

struct RecentSearchSection {
  var header: String
  var items: [Item]
}

extension RecentSearchSection: AnimatableSectionModelType {
  typealias Item = RecentSearchModel
  
  var identity: String {
    return header
  }
  
  init(original: RecentSearchSection, items: [Item]) {
    self = original
    self.items = items
  }
}
