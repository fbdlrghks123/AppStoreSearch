//
//  DetailPreviewCellReactor.swift
//  AppStoreSearch
//
//  Created by RIH on 2020/09/18.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class DetailPreviewCellReactor: Reactor {
  typealias Action = NoAction
  
  struct State {
    var sections: [AppDetailPreviewSection]
  }
  
  var initialState: State
  
  init(app: App) {
    let items = app.screenshots.map { url -> AppDetailPreviewItem in
      let reactor = DetailPreviewCollectionViewCellReactor(url: url)
      return .image(reactor)
    }
    
    initialState = State(sections: [.section(items)])
  }
}
