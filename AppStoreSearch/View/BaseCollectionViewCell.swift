//
//  BaseCollectionViewCell.swift
//  AppStoreSearch
//
//  Created by RIH on 2020/09/18.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

class BaseCollectionViewCell: UICollectionViewCell {
   
  // MARK: Rx
  
  var disposeBag = DisposeBag()
  

  // MARK: Initializing
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
