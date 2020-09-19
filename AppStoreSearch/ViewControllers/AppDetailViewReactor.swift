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
      guard var currentSectionItem = currentState.section.first?.items,
        let index = currentSectionItem.firstIndex(of: selectedItem),
        let model = currentSectionItem[safe: index]?.model else { return newState }
      
      currentSectionItem.remove(at: index)
      
      switch selectedItem {
      case .whatsNew:
        let newReactor = DetailWhatsNewCellReactor(app: model, readMore: true)
        currentSectionItem.insert(.whatsNew(UUID.string, newReactor), at: index)
      case .desc:
        let newReactor = DetailDescCellReactor(app: model, readMore: true)
        currentSectionItem.insert(.desc(UUID.string, newReactor), at: index)
      default:
        break
      }
      newState.section = [.section(0, currentSectionItem)]
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
