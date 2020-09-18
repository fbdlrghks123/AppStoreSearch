//
//  AppDetailViewReactor.swift
//  AppStoreSearch
//
//  Created by RIH on 2020/09/17.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class AppDetailViewReactor: Reactor {
  enum Action {
    case requestDetail
    case updateWhatsAppCell
  }
  
  enum Mutation {
    case responseDetail(ApiResult<AppResponse, Error>)
    case updateSection
  }
  
  struct State {
    var bundleId: String
    var section: [AppDetailSection] = []
    
    var error: Error?
  }
  
  var initialState: State
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .requestDetail:
      return AppStoreApi.lookUp(bundleId: currentState.bundleId)
        .request(type: AppResponse.self)
        .map(Mutation.responseDetail)
    case .updateWhatsAppCell:
      return .just(.updateSection)
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case .responseDetail(let response):
      newState.section = getSection(app: response.success?.results.first)
      newState.error = response.fail
    case .updateSection:
      if let currentSections = newState.section.first, let app = currentSections.items[safe: 1]?.model {
        var items = currentSections.items
        let reactor = DetailWhatsNewCellReactor(app: app, readMore: true)
        items.remove(at: 1)
        items.insert(.whatsNew(reactor), at: 1)
        newState.section = [.section(items)]
      }
    }
    
    return newState
  }
  
  init(bundleId: String) {
    self.initialState = State(bundleId: bundleId)
  }
}

extension AppDetailViewReactor {
  private func getSection(app: App?) -> [AppDetailSection] {
    guard let app = app else { return [] }
    var sectionItems: [AppDetailItem] = []
    
    sectionItems.append(.topView(DetailTopViewCellReactor(app: app)))
    sectionItems.append(.whatsNew(DetailWhatsNewCellReactor(app: app)))
    sectionItems.append(.preview(DetailPreviewCellReactor(app: app)))
    
    return [.section(sectionItems)]
  }
}
