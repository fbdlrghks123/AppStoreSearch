//
//  AppDetailPreviewSection.swift
//  AppStoreSearch
//
//  Created by RIH on 2020/09/18.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

enum AppDetailPreviewSection {
  case section([AppDetailPreviewItem])
}

extension AppDetailPreviewSection: SectionModelType {
  var items: [AppDetailPreviewItem] {
    switch self {
    case .section(let items): return items
    }
  }
  
  init(original: AppDetailPreviewSection, items: [AppDetailPreviewItem]) {
    switch original {
    case .section: self = .section(items)
    }
  }
}

enum AppDetailPreviewItem {
  case image(DetailPreviewCollectionViewCellReactor)
}
