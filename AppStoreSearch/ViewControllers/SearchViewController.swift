//
//  SearchViewController.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/16.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class SearchViewController: BaseViewController, View {

  // MARK: UI
  
  private let searchBarController = UISearchController(searchResultsController: nil).then {
    $0.searchBar.placeholder = "게임, 앱, 스토리 등"
    $0.obscuresBackgroundDuringPresentation = false
  }
  
  private var searchBar: UISearchBar {
    return self.searchBarController.searchBar
  }
  
  private let tableView = UITableView().then {
    $0.register(RecentSearchCell.self, forCellReuseIdentifier: RecentSearchCell.Identifier)
    $0.register(RecentSearchHeaderCell.self, forCellReuseIdentifier: RecentSearchHeaderCell.Identifier)
  }
  
  
  // MARK: Property
  
  private let dataSource: RxTableViewSectionedReloadDataSource<RecentSearchSection> = {
    return RxTableViewSectionedReloadDataSource<RecentSearchSection>(
      configureCell: { (ds, tableView, index, item) -> UITableViewCell in
        switch item {
        case .header:
          let cell = RecentSearchHeaderCell(style: .default, reuseIdentifier: RecentSearchHeaderCell.Identifier)
          return cell
        case .item(let reactor):
          let cell = RecentSearchCell(style: .default, reuseIdentifier: RecentSearchCell.Identifier)
          cell.reactor = reactor
          return cell
        }
      }
    )
  }()
  
  private func setupConstraints() {
    view.addSubview(tableView)
    
    self.tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  func bind(reactor: SearchViewReactor) {
    // Input
    self.rx.viewDidLoad
      .do(onNext: { [weak self] _ in
        self?.tableView.separatorStyle = .none
        self?.navigationItem.hidesSearchBarWhenScrolling = false
        self?.navigationItem.searchController = self?.searchBarController
        self?.setupConstraints()
      })
      .map{ _ in Reactor.Action.togglePresented(false) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    
    // Action
    self.searchBar.rx.text.orEmpty
      .map { $0.isEmpty ? nil : $0 }
      .map(Reactor.Action.recentSearchWord)
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    self.searchBar.rx.searchButtonClicked
      .withLatestFrom(self.searchBar.rx.text.orEmpty)
      .map(Reactor.Action.searchWord)
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    self.searchBarController.rx.willPresent
      .map { true }
      .map(Reactor.Action.togglePresented)
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    self.searchBarController.rx.willDismiss
      .map { false }
      .map(Reactor.Action.togglePresented)
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    
    // State
    reactor.state
      .map { $0.sections }
      .bind(to: tableView.rx.items(dataSource: self.dataSource))
      .disposed(by: disposeBag)
  }
}
