//
//  AppDetailSection.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/18.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

enum AppDetailSection {
  case section([AppDetailItem])
}

extension AppDetailSection: SectionModelType {
  var items: [AppDetailItem] {
    switch self {
    case .section(let items): return items
    }
  }
  
  init(original: AppDetailSection, items: [AppDetailItem]) {
    switch original {
    case .section: self = .section(items)
    }
  }
}

enum AppDetailItem {
  case topView(DetailTopViewCellReactor)
  case whatsNew(DetailWhatsNewCellReactor)
  case preview(DetailPreviewCellReactor)
}

extension AppDetailItem {
  var model: App {
    switch self {
    case .topView(let reactor):
      return reactor.currentState.app
    case .whatsNew(let reactor):
      return reactor.currentState.app
    case .preview:
      fatalError()
    }
  }
}
