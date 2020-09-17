//
//  AppListCellReactor.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/17.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class AppListCellReactor: Reactor {
  typealias Action = NoAction
  
  struct State {
    var app: App
  }
  
  var initialState: State
  
  init(app: App) {
    initialState = State(app: app)
  }
}
