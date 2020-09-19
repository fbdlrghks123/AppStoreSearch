//
//  DetailTopViewCellReactor.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/18.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class DetailTopViewCellReactor: Reactor {
  typealias Action = NoAction
  
  struct State {
    var app: App
  }
  
  var initialState: State
  
  init(app: App) {
    self.initialState = State(app: app)
  }
}
