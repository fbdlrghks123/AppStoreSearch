//
//  SearchViewController.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/16.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class SearchViewController: BaseViewController, View {

  // MARK: UI
  
  private let searchBar = UISearchBar()
  private let searchBarController = UISearchController(searchResultsController: nil)
  
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
    
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  func bind(reactor: SearchViewReactor) {
    // Input
    rx.viewDidLoad
      .subscribe(onNext: { [weak self] _ in
        self?.tableView.separatorStyle = .none
        self?.searchBarController.searchBar.placeholder = "게임, 앱, 스토리 등"
        self?.navigationItem.hidesSearchBarWhenScrolling = false
        self?.navigationItem.searchController = self?.searchBarController
        self?.setupConstraints()
      })
      .disposed(by: disposeBag)
    
    
    // Action
    searchBarController.searchBar.rx
      .searchButtonClicked
      .withLatestFrom(searchBarController.searchBar.rx.text.orEmpty)
      .map(Reactor.Action.saveWord)
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    
    // State
    reactor.state
      .map { $0.sections }
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
}
