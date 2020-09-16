//
//  SearchViewController.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/16.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Then

final class SearchViewController: UIViewController {

  // MARK: UI
  
  private let searchBar = UISearchBar()
  
  private let searchController = UISearchController(searchResultsController: nil).then {
    $0.searchBar.placeholder = "게임, 앱, 스토리 등"
  }
  
  
  // MARK: ViewCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.hidesSearchBarWhenScrolling = false
    navigationItem.searchController = searchController
  }
}
