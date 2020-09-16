//
//  RecentSearchCellReactor.swift
//  AppStoreSearch
//
//  Created by RIH on 2020/09/16.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class RecentSearchCellReactor: Reactor {
  
  typealias Action = NoAction
  
  struct State {
    var title: String
  }
  
  var initialState: State
  
  init(model: RecentSearchModel) {
    initialState = State(title: model.text)
  }
}
