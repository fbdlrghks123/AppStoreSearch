//
//  BaseTableViewCell.swift
//  AppStoreSearch
//
//  Created by RIH on 2020/09/16.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

class BaseTableViewCell: UITableViewCell {
  
  // MARK: Rx
  
  var disposeBag = DisposeBag()
  

  // MARK: Initializing
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
