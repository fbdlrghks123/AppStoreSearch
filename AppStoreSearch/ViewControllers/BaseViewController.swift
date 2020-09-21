//
//  BaseViewController.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/16.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

class BaseViewController: UIViewController {
  
  // MARK: UI
  
  var navigation: BaseNavigationController? {
    return self.navigationController as? BaseNavigationController
  }
  
  
  // MARK: RX
  
  var disposeBag = DisposeBag()
  
  deinit {
    print("deinit \(self)")
  }
}
