//
//  DetailTopViewCellReactor.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/18.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class DetailTopViewCell: BaseTableViewCell, View {
  
  @IBOutlet weak var appIconImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var ratingView: CosmosView!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var ratingCountLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  
  
  func bind(reactor: DetailTopViewCellReactor) {
    // State
    reactor.state
      .map { $0.app.icon }
      .bind(to: self.appIconImageView.rx.setImage)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.app.name }
      .bind(to: self.nameLabel.rx.text)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.app.genre }
      .bind(to: self.genreLabel.rx.text)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.app.averageRating }
      .subscribe(onNext: { [weak self] rating in
        self?.ratingView.rating = rating
      })
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.app }
      .map { String(format: "%0.1f", Float($0.averageRating))}
      .bind(to: self.ratingLabel.rx.text)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.app.totalRatingCount }
      .map { "\($0.ratingString)개의 평가" }
      .bind(to: self.ratingCountLabel.rx.text)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.app.trackContentRating }
      .bind(to: self.ageLabel.rx.text)
      .disposed(by: disposeBag)
  }
}
