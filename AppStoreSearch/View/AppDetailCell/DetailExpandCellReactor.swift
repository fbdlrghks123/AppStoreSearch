//
//  DetailExpandCellReactor.swift
//  AppStoreSearch
//
//  Created by RIH on 2020/09/20.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class DetailExpandCellReactor: Reactor {
  typealias Action = NoAction
  
  struct State {
    var type: InfomationType
    var subTitle: String?
    var content: String?
    var isFolding: Bool
  }
  
  var initialState: State
  
  init(
    type: InfomationType,
    subTitle: String?,
    content: String? = nil,
    isFolding: Bool = true
  ) {
    self.initialState = State(
      type: type,
      subTitle: subTitle,
      content: content,
      isFolding: isFolding
    )
  }
}
