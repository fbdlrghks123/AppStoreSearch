//
//  DetailWhatsNewCellReactor.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/18.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class DetailWhatsNewCellReactor: Reactor {
  enum Action {
    case toggleReadMore
  }
  
  enum Mutation {
    case toggleReadMore
  }
  
  struct State {
    var app: App
    var readMore: Bool = false
  }
  
  var initialState: State
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .toggleReadMore:
      return .just(.toggleReadMore)
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case .toggleReadMore:
      newState.readMore = true
    }
    
    return newState
  }
  
  init(app: App, readMore: Bool = false) {
    initialState = State(app: app, readMore: readMore)
  }
}
