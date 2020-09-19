//
//  RecentSearchCell.swift
//  AppStoreSearch
//
//  Created by RIH on 2020/09/16.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class RecentSearchCell: BaseTableViewCell, View {
  
  // MARK: UI
  
  private let stackView = UIStackView().then {
    $0.spacing = 5
    $0.axis = .horizontal
  }
  
  private let searchIconImageView = UIImageView().then {
    $0.isHidden = true
    $0.tintColor = .label
    $0.contentMode = .scaleAspectFit
    $0.image = UIImage(systemName: "magnifyingglass")
  }
  
  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 18)
  }
  
  private let underLine = UIView().then {
    $0.backgroundColor = .systemGray6
  }
  
  
  // MARK: Initializing

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    self.addSubview(self.stackView)
    self.addSubview(self.underLine)
    self.stackView.addArrangedSubview(self.searchIconImageView)
    self.stackView.addArrangedSubview(self.titleLabel)
    self.setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func bind(reactor: RecentSearchCellReactor) {
    let isRecentSearch = reactor.currentState.isRecentSearch
    self.titleLabel.textColor = isRecentSearch ? .label : .systemBlue
    
    reactor.state
      .map { !$0.isRecentSearch }
      .bind(to: self.searchIconImageView.rx.isHidden)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.title }
      .bind(to: self.titleLabel.rx.text)
      .disposed(by: disposeBag)
  }
  
  private func setupConstraints() {
    self.stackView.snp.makeConstraints {
      $0.top.trailing.bottom.equalToSuperview()
      $0.leading.equalTo(20)
      $0.height.equalTo(45)
    }
    
    self.searchIconImageView.snp.makeConstraints {
      $0.width.equalTo(23)
    }
    
    self.underLine.snp.makeConstraints {
      $0.leading.equalTo(20)
      $0.trailing.equalTo(-20)
      $0.bottom.equalToSuperview()
      $0.height.equalTo(1)
    }
  }
}
