//
//  DetailExpandCell.swift
//  AppStoreSearch
//
//  Created by RIH on 2020/09/20.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class DetailExpandCell: BaseTableViewCell, View {

  // MARK: UI
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var arrowImageView: UIImageView! // 숨기는조건 폴딩이 펄스이거나 타입이 호환성아니고 연령등급아니면
  @IBOutlet weak var expandView: UIView!
  @IBOutlet weak var contentLabel: UILabel!
  
  
  func bind(reactor: DetailExpandCellReactor) {
    // State
    reactor.state
      .map { $0.type.rawValue }
      .bind(to: self.titleLabel.rx.text)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.subTitle }
      .bind(to: self.subtitleLabel.rx.text)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { (isFolding: $0.isFolding, isFoldingView: $0.type.isFoldingView) }
      .map { (isFolding, isFoldingView) in
        if isFolding && isFoldingView { return false }
        return true
      }
      .bind(to: self.arrowImageView.rx.isHidden, self.expandView.rx.isHidden)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.isFolding }
      .bind(to: self.expandView.rx.isHidden)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { !$0.isFolding }
      .bind(to: self.subtitleLabel.rx.isHidden)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.content?.attributeString }
      .bind(to: self.contentLabel.rx.attributedText)
      .disposed(by: disposeBag)
  }
}
