//
//  SearchViewReactor.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/16.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class SearchViewReactor: Reactor {
  enum Action {
    case saveWord(String)
  }
  
  enum Mutation {
    case loadRecentList
  }
  
  struct State {
    var sections: [RecentSearchSection]
  }
  
  var initialState: State
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .saveWord(let text):
      return saveWord(text: text)
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case .loadRecentList:
      newState.sections = SearchViewReactor.loadRecentList()
    }
    
    return newState
  }
  
  init() {
    let recentSearchList = SearchViewReactor.loadRecentList()
    initialState = State(sections: recentSearchList)
  }
}

extension SearchViewReactor {
  private func saveWord(text: String) -> Observable<Mutation> {
    var recentSearchList = UserDefaults.standard.stringArray(forKey: "recentList") ?? []
    recentSearchList.append(text)
    UserDefaults.standard.set(recentSearchList, forKey: "recentList")
    
    return .just(.loadRecentList)
  }
  
  private class func loadRecentList() -> [RecentSearchSection] {
    var section: [RecentSearchSection] = []
    var items: [RecentSearchItem] = [.header]
    
    if let recentSearchList = UserDefaults.standard.stringArray(forKey: "recentList") {
      recentSearchList.reversed().forEach {
        let reactor = RecentSearchCellReactor(model: RecentSearchModel(text: $0))
        items.append(.item(reactor))
      }
    }
    
    section.append(.section(items))
    
    return section
  }
}
