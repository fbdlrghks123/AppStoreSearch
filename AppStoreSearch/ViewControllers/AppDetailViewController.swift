//
//  AppDetailViewController.swift
//  AppStoreSearch
//
//  Created by RIH on 2020/09/17.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class AppDetailViewController: BaseViewController, View {
  
  // MARK: Constants

  fileprivate struct Reusable {
    static let detailTopViewCell = ReuseCell<DetailTopViewCell>()
    static let detailWhatsNewCell = ReuseCell<DetailWhatsNewCell>()
    static let detailPreviewCell = ReuseCell<DetailPreviewCell>()
    static let detailDescCell = ReuseCell<DetailDescCell>()
    static let detailExpandCell = ReuseCell<DetailExpandCell>()
  }
  
  
  // MARK: UI
  
  private let tableView = UITableView().then {
    $0.register(Reusable.detailTopViewCell)
    $0.register(Reusable.detailWhatsNewCell)
    $0.register(Reusable.detailPreviewCell)
    $0.register(Reusable.detailDescCell)
    $0.register(Reusable.detailExpandCell)
  }
  
  
  // MARK: Property
  private var dataSource: RxTableViewSectionedAnimatedDataSource<AppDetailSectionType> {
    return RxTableViewSectionedAnimatedDataSource<AppDetailSectionType>(
      animationConfiguration: .init(insertAnimation: .none, reloadAnimation: .fade, deleteAnimation: .right),
      decideViewTransition: { (_, _, item) in return .animated },
      configureCell: { (ds, tableView, index, item) in
        switch item {
        case .topView(_, let reactor):
          let cell = tableView.dequeue(Reusable.detailTopViewCell, for: index)
          cell.reactor = reactor
          return cell
        case .whatsNew(_, let reactor):
          let cell = tableView.dequeue(Reusable.detailWhatsNewCell, for: index).then {
            $0.settingReleaseNoteLine(readMore: reactor.currentState.readMore)
          }
          cell.reactor = reactor
          return cell
        case .preview(_, let reactor):
           let cell = tableView.dequeue(Reusable.detailPreviewCell, for: index)
           cell.reactor = reactor
           return cell
        case .desc(_, let reactor):
          let cell = tableView.dequeue(Reusable.detailDescCell, for: index).then {
            $0.settingReleaseNoteLine(readMore: reactor.currentState.readMore)
          }
          cell.reactor = reactor
          return cell
        case .expand(_, let reactor):
          let cell = tableView.dequeue(Reusable.detailExpandCell, for: index)
          cell.reactor = reactor
          return cell
        }
      }
    )
  }
  
  override func setupConstraints() {
    view.addSubview(tableView)
    
    self.tableView.separatorStyle = .none
    self.tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  func bind(reactor: AppDetailViewReactor) {
    // Input
    self.rx.viewDidLoad
      .map { Reactor.Action.requestDetail }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // Action
    self.tableView.rx.modelSelected(AppDetailItem<String>.self)
      .map(Reactor.Action.updateSection)
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    self.tableView.rx.didScroll
      .compactMap { reactor.currentState.model?.icon }
      .subscribe(onNext: { [weak self] url in
        guard let self = self else { return }
        let posY: CGFloat = 44.0
        let offsetY = self.tableView.contentOffset.y
        
        if offsetY > posY { self.setNavigationItems(url: url) }
        else { self.clearNavigationItem() }
      })
      .disposed(by: disposeBag)
    
    // State
    reactor.state
      .map { $0.section }
      .bind(to: tableView.rx.items(dataSource: self.dataSource))
      .disposed(by: disposeBag)
  }
}
