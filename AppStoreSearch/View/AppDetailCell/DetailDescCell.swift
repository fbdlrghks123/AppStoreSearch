//
//  DetailDescCell.swift
//  AppStoreSearch
//
//  Created by RIH on 2020/09/19.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class DetailDescCell: BaseTableViewCell, View {
  
  // MARK: UI
  
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var sellerNameLabel: UILabel!
  
  
  func bind(reactor: DetailDescCellReactor) {
    // action
    reactor.state
      .map { $0.app.description?.attributeString }
      .bind(to: self.descriptionLabel.rx.attributedText)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.app.sellerName }
      .bind(to: self.sellerNameLabel.rx.text)
      .disposed(by: disposeBag)
  }
}
