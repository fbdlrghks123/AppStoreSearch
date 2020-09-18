//
//  BaseTableViewCell.swift
//  AppStoreSearch
//
//  Created by RIH on 2020/09/16.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

class BaseTableViewCell: UITableViewCell {
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  // MARK: Rx
  
  var disposeBag = DisposeBag()
  

  // MARK: Initializing
  
  override class func awakeFromNib() {
    super.awakeFromNib()
  }
}
