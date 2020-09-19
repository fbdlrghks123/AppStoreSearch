//
//  DetailPreviewCollectionViewCellReactor.swift
//  AppStoreSearch
//
//  Created by RIH on 2020/09/18.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class DetailPreviewCollectionViewCellReactor: Reactor {
  typealias Action = NoAction
  
  struct State {
    var url: String
  }
  
  var initialState: State
  
  init(url: String) {
    self.initialState = State(url: url)
  }
}
