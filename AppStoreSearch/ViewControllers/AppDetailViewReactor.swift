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
    case updateSection(AppDetailItem<String>)
  }
  
  enum Mutation {
    case responseDetail(ApiResult<AppResponse, Error>)
    case updateSection(AppDetailItem<String>)
  }
  
  struct State {
    var bundleId: String
    var section: [AppDetailSectionType] = []
    
    var error: Error?
  }
  
  var initialState: State
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .requestDetail:
      return AppStoreApi.lookUp(bundleId: currentState.bundleId)
        .request(type: AppResponse.self)
        .map(Mutation.responseDetail)
    
    case .updateSection(let selectedItem):
      return .just(.updateSection(selectedItem))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case .responseDetail(let response):
      newState.section = getSection(app: response.success?.results.first)
      newState.error = response.fail
    
    case .updateSection(let selectedItem):
      switch selectedItem {
      case .whatsNew(_, _):
        guard var currentSectionItem = currentState.section.first?.items else { fatalError() }
        guard let model = currentSectionItem[safe: 1]?.model else { fatalError() }
        let newReactor = DetailWhatsNewCellReactor(app: model, readMore: true)
        
        currentSectionItem.remove(at: 1)
        currentSectionItem.insert(AppDetailItem<String>.whatsNew(UUID.string, newReactor), at: 1)
        newState.section = [.section(0, currentSectionItem)]
//      if let currentSections = newState.section.first, let app = currentSections.items[safe: 1]?.model {
//        var items = currentSections.items
//        let reactor = DetailWhatsNewCellReactor(app: app, readMore: true)
//        items.remove(at: 1)
//        items.insert(.whatsNew("1", reactor), at: 1)
//        newState.section = [.section(0, items)]
      default:
        break
      }
    }
    
    return newState
  }
  
  init(bundleId: String) {
    self.initialState = State(bundleId: bundleId)
  }
}

extension AppDetailViewReactor {
  private func getSection(app: App?) -> [AppDetailSectionType] {
    guard let app = app else { return [] }
    var sectionItems: [AppDetailItem<String>] = []
    
    sectionItems.append(.topView(UUID.string, DetailTopViewCellReactor(app: app)))
    sectionItems.append(.whatsNew(UUID.string, DetailWhatsNewCellReactor(app: app)))
    sectionItems.append(.preview(UUID.string, DetailPreviewCellReactor(app: app)))
    sectionItems.append(.desc(UUID.string, DetailDescCellReactor(app: app)))
    
    return [.section(0, sectionItems)]
  }
}
