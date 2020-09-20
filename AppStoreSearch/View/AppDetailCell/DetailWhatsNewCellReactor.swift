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
    case calculationHeight(size: CGSize?)
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
    case .calculationHeight(let size):
      guard let size = size else { return .empty()}
      guard let releaseNotes = currentState.app.releaseNotes else { return .empty() }
      let textHeight = releaseNotes.height(withConstrainedWidth: size.width,
                                         font: UIFont.systemFont(ofSize: 14.0))
      if textHeight < size.height {
        return .just(.toggleReadMore)
      }
      return .empty()
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
    self.initialState = State(app: app, readMore: readMore)
  }
}
