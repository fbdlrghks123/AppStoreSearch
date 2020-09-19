//
//  DetailPreviewCollectionCell.swift
//  AppStoreSearch
//
//  Created by RIH on 2020/09/18.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

class DetailPreviewCollectionCell: BaseCollectionViewCell, View {
  
  // MARK: UI
  
  @IBOutlet weak var screenshotImageView: UIImageView!
  
  func bind(reactor: DetailPreviewCollectionViewCellReactor) {
    // State
    reactor.state
      .map { $0.url }
      .bind(to: screenshotImageView.rx.setImage)
      .disposed(by: disposeBag)
  }
}
