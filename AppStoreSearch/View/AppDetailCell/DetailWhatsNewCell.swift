//
//  DetailWhatsNewCell.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/18.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class DetailWhatsNewCell: BaseTableViewCell, View {
  
  // MARK: UI
  
  @IBOutlet weak var versionLabel: UILabel!
  @IBOutlet weak var releaseTimeLabel: UILabel!
  @IBOutlet weak var releaseNoteLabel: UILabel!
  @IBOutlet weak var readMoreButton: UIButton!
  
  
  // MARK: Property
  
  let readMoreSubject = PublishSubject<Void>()
  
  func bind(reactor: DetailWhatsNewCellReactor) {
    // Action
    self.readMoreButton.rx.tap
      .do(onNext: { [weak self] _ in
        self?.releaseNoteLabel.numberOfLines = 0
        self?.readMoreSubject.onNext(())
      })
      .map { Reactor.Action.toggleReadMore }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    
    // State
    reactor.state
      .map { $0.app.version }
      .map { "버전 \($0)" }
      .bind(to: self.versionLabel.rx.text)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.app.releaseDate }
      .map { Date.appleStringToDate($0) }
      .map { Date.timeAgoSince($0) }
      .bind(to: self.releaseTimeLabel.rx.text)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.app.releaseNotes }
      .map {
        let paragraphyStyle = NSMutableParagraphStyle().then {
          $0.lineSpacing = 5
        }
        let attributes: [NSAttributedString.Key: Any] = [
          .font : UIFont.systemFont(ofSize: 14),
          .foregroundColor : UIColor.label,
          .paragraphStyle : paragraphyStyle
        ]
        return NSAttributedString(string: $0, attributes: attributes)
      }
      .bind(to: self.releaseNoteLabel.rx.attributedText)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.readMore }
      .bind(to: self.readMoreButton.rx.isHidden)
      .disposed(by: disposeBag)
  }
}
