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
    
    var model: App?
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
      return checkNeedUpdate(item: selectedItem)
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case .responseDetail(let response):
      newState.section = getSection(app: response.success?.results.first)
      newState.model = response.success?.results.first
      newState.error = response.fail
    
    case .updateSection(let selectedItem):
      guard var currentSectionItem = currentState.section.first?.items,
        let index = currentSectionItem.firstIndex(of: selectedItem) else { return newState }
      
      switch selectedItem {
      case .whatsNew(let uuid, _):
        guard let model = currentSectionItem[safe: index]?.model else { return newState }
        let newReactor = DetailWhatsNewCellReactor(app: model, readMore: true)
        currentSectionItem[index] = .whatsNew(uuid, newReactor)
        
      case .desc(let uuid, _):
        guard let model = currentSectionItem[safe: index]?.model else { return newState }
        let newReactor = DetailDescCellReactor(app: model, readMore: true)
        currentSectionItem[index] = .desc(uuid, newReactor)
        
      case .expand(let uuid, let reactor):
        let currentState = reactor.currentState
        
        switch currentState.type {
        case .compatibility, .language, .age:
          let newReactor = DetailExpandCellReactor(
            type: currentState.type,
            subTitle: currentState.subTitle,
            content: currentState.content,
            isFolding: false
          )
          currentSectionItem[index] = .expand(uuid, newReactor)
        default:
          break
        }
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
  private func checkNeedUpdate(item: AppDetailItem<String>) -> Observable<Mutation> {
    if item.isUnfold { return .empty() }
    return .just(.updateSection(item))
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
    
    sectionItems += infoItems(app: app)
    
    return [.section(0, sectionItems)]
  }
  
  private func infoItems(app: App?) -> [AppDetailItem<String>] {
    guard let app = app else { return [] }
    var sectionItems: [AppDetailItem<String>] = []
    
    let sellerReactor = DetailExpandCellReactor(type: .seller, subTitle: app.sellerName)
    sectionItems.append(.expand(UUID.string, sellerReactor))
    
    let appSizeReactor = DetailExpandCellReactor(type: .appSize, subTitle: app.fileSizeBytes?.convertMB)
    sectionItems.append(.expand(UUID.string, appSizeReactor))
    
    let categoryReactor = DetailExpandCellReactor(type: .category, subTitle: app.genres?.first)
    sectionItems.append(.expand(UUID.string, categoryReactor))
    
    let minimumOSMessage = "iOS \(app.minimumOsVersion) 버전 이상 필요"
    let compatibilityReactor = DetailExpandCellReactor(type: .compatibility,
                                                       subTitle: "이 iPhone와(과) 호환",
                                                       content: minimumOSMessage)
    sectionItems.append(.expand(UUID.string, compatibilityReactor))
    
    if let languages = app.languageCodesISO2A {
      let convertLanguage = languages.converLanguage()
      let compatibilityReactor = DetailExpandCellReactor(type: .language,
                                                         subTitle: convertLanguage.subTitle,
                                                         content: convertLanguage.content)
      sectionItems.append(.expand(UUID.string, compatibilityReactor))
    }
    
    let ageContent = "\(app.trackContentRating ?? "")\n" + (app.advisories ?? []).joined(separator: "\n")
    let ageReactor = DetailExpandCellReactor(type: .age, subTitle: app.trackContentRating, content: ageContent)
    sectionItems.append(.expand(UUID.string, ageReactor))
    
    let copyrightReactor = DetailExpandCellReactor(type: .copyright, subTitle: app.sellerName)
    sectionItems.append(.expand(UUID.string, copyrightReactor))
    
    return sectionItems
  }
}
