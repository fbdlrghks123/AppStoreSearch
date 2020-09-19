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
  }
  
  
  // MARK: UI
  
  private let tableView = UITableView().then {
    $0.register(Reusable.detailTopViewCell)
    $0.register(Reusable.detailWhatsNewCell)
    $0.register(Reusable.detailPreviewCell)
    $0.register(Reusable.detailDescCell)
  }
  
  
  // MARK: Property
  private var dataSource: RxTableViewSectionedAnimatedDataSource<AppDetailSectionType> {
    return RxTableViewSectionedAnimatedDataSource<AppDetailSectionType>(
      animationConfiguration: .init(insertAnimation: .fade, reloadAnimation: .none, deleteAnimation: .none),
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
        }
      }
    )
  }
  
  private func setupConstraints() {
    view.addSubview(tableView)
    
    self.tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  func bind(reactor: AppDetailViewReactor) {
    // Action
    tableView.rx.modelSelected(AppDetailItem<String>.self)
      .map(Reactor.Action.updateSection)
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // Input
    self.rx.viewDidLoad
      .do(onNext: { [weak self] in
        self?.tableView.separatorStyle = .none
        self?.setupConstraints()
      })
      .map { Reactor.Action.requestDetail }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // State
    reactor.state
      .map { $0.section }
      .bind(to: tableView.rx.items(dataSource: self.dataSource))
      .disposed(by: disposeBag)
  }
}
