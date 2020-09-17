//
//  SearchSection.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/16.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

enum SearchSection {
  case section([SearchItem])
}

extension SearchSection: SectionModelType {
  var items: [SearchItem] {
    switch self {
    case .section(let items): return items
    }
  }
  
  init(original: SearchSection, items: [SearchItem]) {
    switch original {
    case .section: self = .section(items)
    }
  }
}

enum SearchItem {
  case header
  case item(RecentSearchCellReactor)
  case app(AppListCellReactor)
}

