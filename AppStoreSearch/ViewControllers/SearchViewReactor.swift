//
//  SearchViewReactor.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/16.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class SearchViewReactor: Reactor {
  enum Action {
    case searchApp(String)
    case recentSearchWord(String?)
    case togglePresented(Bool)
  }
  
  enum Mutation {
    case togglePresented(Bool)
    case recentSearchWord(String?)
  }
  
  struct State {
    var sections: [RecentSearchSection] = []
  }
  
  var initialState = State()
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .searchApp(let text):
      return searchApp(text: text)
      
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
      newState.sections = flag ? [] : loadRecentList(presneted: false)
      
    case .recentSearchWord(let text):
      newState.sections = loadRecentList(presneted: true, searchWord: text)
    }
    
    return newState
  }
}

extension SearchViewReactor {
  private func searchApp(text: String) -> Observable<Mutation> {
    var recentSearchList = UserDefaults.standard.stringArray(forKey: "recentSearchList") ?? []
    recentSearchList.append(text)
    UserDefaults.standard.set(recentSearchList, forKey: "recentSearchList")
    AppStoreApi.search(str: text).request(type: AppModel.self)
      .onResponse({ model in
        
      }, onError: { error in
        print(error)
      })

    return .empty()
  }
  
  private func loadRecentList(presneted: Bool = false, searchWord: String? = nil) -> [RecentSearchSection] {
    var section: [RecentSearchSection] = []
    var items: [RecentSearchItem] = []
    
    if !presneted {
      items.append(.header)
    }
    if let recentSearchList = UserDefaults.standard.stringArray(forKey: "recentSearchList") {
      if let searchWord = searchWord, presneted {
        recentSearchList
          .filter { $0.lowercased().contains(searchWord.lowercased()) }
          .forEach {
            let reactor = RecentSearchCellReactor(model: RecentSearchModel(text: $0), isRecentSearch: true)
            items.append(.item(reactor))
        }
      } else if !presneted {
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
