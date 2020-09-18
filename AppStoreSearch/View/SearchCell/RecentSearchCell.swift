//
//  RecentSearchCell.swift
//  AppStoreSearch
//
//  Created by RIH on 2020/09/16.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class RecentSearchCell: BaseTableViewCell, View {
  
  // MARK: UI
  
  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 18)
  }
  
  private let underLine = UIView().then {
    $0.backgroundColor = .systemGray6
  }
  
  
  // MARK: Initializing

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    addSubview(self.titleLabel)
    addSubview(self.underLine)
    self.setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func bind(reactor: RecentSearchCellReactor) {
    let isRecentSearch = reactor.currentState.isRecentSearch
    
    self.titleLabel.textColor = isRecentSearch ? .label : .systemBlue
    
    self.titleLabel.snp.makeConstraints {
      $0.top.equalTo(isRecentSearch ? 20 : 10)
      $0.leading.equalTo(20)
      $0.bottom.equalTo(-10)
    }
    
    reactor.state
      .map { $0.title }
      .bind(to: self.titleLabel.rx.text)
      .disposed(by: disposeBag)
  }
  
  private func setupConstraints() {
    self.underLine.snp.makeConstraints {
      $0.leading.equalTo(20)
      $0.trailing.bottom.equalToSuperview()
      $0.height.equalTo(1)
    }
  }
}
