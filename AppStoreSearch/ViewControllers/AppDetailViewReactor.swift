//
//  AppDetailViewReactor.swift
//  AppStoreSearch
//
//  Created by RIH on 2020/09/17.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class AppDetailViewReactor: Reactor {
  typealias Action = NoAction
  
  struct State {
    var app: App
  }
  
  var initialState: State
  
  init(app: App) {
    self.initialState = State(app: app)
  }
}
