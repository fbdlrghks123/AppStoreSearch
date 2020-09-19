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
  @IBOutlet weak var readmoreLabel: UILabel!
  
  
  // MARK: Property
  
  let readMoreSubject = PublishSubject<Void>()
  
  func settingReleaseNoteLine(readMore: Bool) {
    releaseNoteLabel.numberOfLines = readMore ? 0 : 3
  }
  
  func bind(reactor: DetailWhatsNewCellReactor) {
    // State
    reactor.state
      .map { $0.app.version }
      .map { "버전 \($0 ?? "")" }
      .bind(to: self.versionLabel.rx.text)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.app.releaseDate }
      .map { Date.appleStringToDate($0) }
      .map { Date.timeAgoSince($0) }
      .bind(to: self.releaseTimeLabel.rx.text)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.app.releaseNotes?.attributeString }
      .bind(to: self.releaseNoteLabel.rx.attributedText)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.readMore }
      .bind(to: self.readmoreLabel.rx.isHidden)
      .disposed(by: disposeBag)
  }
}
