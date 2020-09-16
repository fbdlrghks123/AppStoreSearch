//
//  RecentSearchSection.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/16.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

enum RecentSearchSection {
  case section([RecentSearchItem])
}

extension RecentSearchSection: SectionModelType {
  var items: [RecentSearchItem] {
    switch self {
    case .section(let items): return items
    }
  }
  
  init(original: RecentSearchSection, items: [RecentSearchItem]) {
    switch original {
    case .section: self = .section(items)
    }
  }
}

enum RecentSearchItem {
  case header
  case item(RecentSearchCellReactor)
}

