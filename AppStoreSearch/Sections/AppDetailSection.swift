//
//  AppDetailSection.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/18.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

typealias AppDetailSectionType = AppDetailSection<Int, String>

enum AppDetailSection<T: Hashable, R: Hashable> {
  case section(T, [AppDetailItem<R>])
}

extension AppDetailSection: AnimatableSectionModelType, IdentifiableType {
  typealias Identity = T
  
  var identity: Identity {
    switch self {
    case .section(let identity, _): return identity
    }
  }
  
  var items: [AppDetailItem<R>] {
    switch self {
    case .section(_, let items): return items
    }
  }
  
  init(original: AppDetailSection, items: [AppDetailItem<R>]) {
    switch original {
    case .section(let identity, _): self = .section(identity, items)
    }
  }
  
  static func == (lhs: AppDetailSection<T, R>, rhs: AppDetailSection<T, R>) -> Bool {
      return lhs.identity == rhs.identity
  }
}

enum AppDetailItem<R: Hashable> {
  case topView(R, DetailTopViewCellReactor)
  case whatsNew(R, DetailWhatsNewCellReactor)
  case preview(R, DetailPreviewCellReactor)
  case desc(R, DetailDescCellReactor)
  case expand(R, DetailExpandCellReactor)
}

extension AppDetailItem: Equatable, IdentifiableType {
  typealias Identity = R
  
  static func == (lhs: AppDetailItem<R>, rhs: AppDetailItem<R>) -> Bool {
    return lhs.identity == rhs.identity && lhs.isUnfold == rhs.isUnfold
  }

  var identity: R {
    switch self {
    case .topView(let identiry, _),
         .whatsNew(let identiry, _),
         .preview(let identiry, _),
         .desc(let identiry, _),
         .expand(let identiry, _):
      return identiry
    }
  }
  
  var model: App? {
    switch self {
    case .topView(_, let reactor):
      return reactor.currentState.app
    case .whatsNew(_, let reactor):
      return reactor.currentState.app
    case .desc(_, let reactor):
      return reactor.currentState.app
    case .preview, .expand:
      return nil
    }
  }
  
  var expandState: DetailExpandCellReactor.State {
    switch self {
      case .expand(_, let reactor):
      return reactor.currentState
    default:
      fatalError()
    }
  }
  
  var isUnfold: Bool {
    switch self {
    case .whatsNew(_, let reactor):
      return reactor.currentState.readMore
    case .desc(_, let reactor):
      return reactor.currentState.readMore
    case .expand(_, let reactor):
      let type = reactor.currentState.type
      if !type.isFoldingView { return true }
      return !reactor.currentState.isFolding
    default:
      break
    }
    return true
  }
}
