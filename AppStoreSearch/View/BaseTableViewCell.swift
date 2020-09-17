//
//  BaseTableViewCell.swift
//  AppStoreSearch
//
//  Created by RIH on 2020/09/16.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

protocol ReusableView: class  {
  static var defaultIdentifier: String { get }
}

extension ReusableView where Self: UIView {
  static var defaultIdentifier: String {
      return NSStringFromClass(self)
  }
}

class BaseTableViewCell: UITableViewCell, ReusableView {

  // MARK: Rx
  
  var disposeBag = DisposeBag()
  

  // MARK: Initializing

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }

  required convenience init?(coder aDecoder: NSCoder) {
    self.init(style: .default, reuseIdentifier: nil)
  }
}
