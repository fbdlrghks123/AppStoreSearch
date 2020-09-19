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
    case calculationHeight(height: CGFloat?)
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
    case .calculationHeight(let height):
      guard let height = height else { return .empty()}
      guard let releaseNotes = currentState.app.releaseNotes else { return .empty() }
      let textHeight = releaseNotes.height(withConstrainedWidth: height,
                                         font: UIFont.systemFont(ofSize: 14.0))
      if textHeight < height {
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
