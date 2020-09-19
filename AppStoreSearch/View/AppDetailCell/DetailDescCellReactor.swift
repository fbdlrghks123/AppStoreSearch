//
//  DetailDescCellReactor.swift
//  AppStoreSearch
//
//  Created by RIH on 2020/09/19.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class DetailDescCellReactor: Reactor {
  typealias Action = NoAction
  
  struct State {
    var app: App
    var readMore: Bool
  }
  
  var initialState: State
  
  init(app: App, readMore: Bool = false) {
    self.initialState = State(app: app, readMore: readMore)
  }
}
