//
//  AppDetailViewController.swift
//  AppStoreSearch
//
//  Created by RIH on 2020/09/17.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class AppDetailViewController: BaseViewController, StoryboardView {
  
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  
  func bind(reactor: AppDetailViewReactor) {
    // State
    reactor.state
      .map { $0.app.icon }
      .bind(to: self.iconImageView.rx.setImage)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.app.name }
      .bind(to: self.nameLabel.rx.text)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.app.name }
      .bind(to: self.genreLabel.rx.text)
      .disposed(by: disposeBag)
  }
}
