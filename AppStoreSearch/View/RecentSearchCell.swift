//
//  RecentSearchCell.swift
//  AppStoreSearch
//
//  Created by RIH on 2020/09/16.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class RecentSearchCell: BaseTableViewCell, View {
  
  static let Identifier = "recentSearchCell"
  
  // MARK: UI
  
  private let titleLabel = UILabel().then {
    $0.textColor = .systemBlue
    $0.font = .systemFont(ofSize: 16)
  }
  
  
  // MARK: Initializing
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    addSubview(titleLabel)
    setupConstraints()
  }
  
  func bind(reactor: RecentSearchCellReactor) {
    reactor.state
      .map { $0.title }
      .bind(to: titleLabel.rx.text)
      .disposed(by: disposeBag)
  }
  
  private func setupConstraints() {
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(10)
      $0.leading.equalTo(20)
      $0.bottom.equalTo(-10)
    }
  }
}
