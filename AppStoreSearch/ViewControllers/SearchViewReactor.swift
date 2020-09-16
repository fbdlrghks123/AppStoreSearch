//
//  SearchViewReactor.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/16.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class SearchViewReactor: Reactor {
  enum Action {
    case searchWord(String)
    case recentSearchWord(String?)
    case togglePresented(Bool)
  }
  
  enum Mutation {
    case togglePresented(Bool)
    case recentSearchWord(String?)
  }
  
  struct State {
    var sections: [RecentSearchSection] = []
    
    var presented: Bool = false
  }
  
  var initialState = State()
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .searchWord(let text):
      return searchWord(text: text)
      
    case .recentSearchWord(let text):
      return .just(.recentSearchWord(text))
      
    case .togglePresented(let flag):
      return .just(.togglePresented(flag))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case .togglePresented(let flag):
      newState.presented = flag
      newState.sections = flag ? [] : loadRecentList()
      
    case .recentSearchWord(let text):
      newState.sections = loadRecentList(searchWord: text)
    }
    
    return newState
  }
}

extension SearchViewReactor {
  private func searchWord(text: String) -> Observable<Mutation> {
    var recentSearchList = UserDefaults.standard.stringArray(forKey: "recentSearchList") ?? []
    recentSearchList.append(text)
    
    UserDefaults.standard.set(recentSearchList, forKey: "recentSearchList")
    // 최근 검색 결과 내에서 리스팅해야함
    return .empty()
  }
  
  private func loadRecentList(searchWord: String? = nil) -> [RecentSearchSection] {
    var section: [RecentSearchSection] = []
    var items: [RecentSearchItem] = []
    
    if !currentState.presented {
      items.append(.header)
    }
    
    if let recentSearchList = UserDefaults.standard.stringArray(forKey: "recentSearchList") {
      if let searchWord = searchWord, currentState.presented {
        recentSearchList
          .filter { $0.lowercased().contains(searchWord.lowercased()) }
          .forEach {
            let reactor = RecentSearchCellReactor(model: RecentSearchModel(text: $0), isRecentSearch: true)
            items.append(.item(reactor))
        }
      } else if !currentState.presented {
        recentSearchList
          .reversed()
          .forEach {
            let reactor = RecentSearchCellReactor(model: RecentSearchModel(text: $0))
            items.append(.item(reactor))
        }
      }
    }
    
    section.append(.section(items))
    
    return section
  }
}
