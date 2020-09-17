//
//  UITableView+Rx.swift
//  AppStoreSearch
//
//  Created by RIH on 2020/09/17.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

extension Reactive where Base: UITableView {
  func itemSelected<S>(dataSource: TableViewSectionedDataSource<S>) -> ControlEvent<S.Item> {
    let source = self.itemSelected.map { indexPath in
      dataSource[indexPath]
    }
    return ControlEvent(events: source)
  }
}
