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
  
 
  func bind(reactor: SearchViewReactor) {
    // Input
    rx.viewDidLoad
      .subscribe(onNext: { [weak self] _ in
        self?.navigationItem.hidesSearchBarWhenScrolling = false
        self?.navigationItem.searchController = self?.searchBarController
        
        self?.searchBarController.searchBar.placeholder = "게임, 앱, 스토리 등"
      })
      .disposed(by: disposeBag)
  }
}
