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
  }
  
  
  // MARK: UI
  
  private let tableView = UITableView().then {
    $0.register(Reusable.detailTopViewCell)
    $0.register(Reusable.detailWhatsNewCell)
    $0.register(Reusable.detailPreviewCell)
  }
  
  
  // MARK: Property
  private func dataSource(this: AppDetailViewController)
    -> RxTableViewSectionedReloadDataSource<AppDetailSection> {
    return RxTableViewSectionedReloadDataSource<AppDetailSection>(
      configureCell: { [weak self] (ds, tableView, index, item) in
        switch item {
        case .topView(let reactor):
          let cell = tableView.dequeue(Reusable.detailTopViewCell, for: index)
          cell.reactor = reactor
          return cell
        case .whatsNew(let reactor):
          let cell = tableView.dequeue(Reusable.detailWhatsNewCell, for: index)
          self?.whatsNewCellBind(subject: cell.readMoreSubject)
          cell.reactor = reactor
          return cell
        case .preview(let reactor):
           let cell = tableView.dequeue(Reusable.detailPreviewCell, for: index)
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
    // Input
    rx.viewDidLoad
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
      .bind(to: tableView.rx.items(dataSource: self.dataSource(this: self)))
      .disposed(by: disposeBag)
  }
  
  private func whatsNewCellBind(subject: PublishSubject<Void>) {
    subject.observeOn(MainScheduler.instance)
      .do(onNext: { [weak self] in
        self?.tableView.reloadData()
      })
      .map { Reactor.Action.updateWhatsAppCell }
      .bind(to: reactor!.action)
      .disposed(by: disposeBag)
  }
}
