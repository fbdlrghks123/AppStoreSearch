//
//  RecentSearchCell.swift
//  AppStoreSearch
//
//  Created by RIH on 2020/09/16.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class RecentSearchHeaderCell: BaseTableViewCell, View {
  
  static let Identifier = "recentSearchHeaderCell"
  
  // MARK: UI
  
  private let titleLabel = UILabel().then {
    $0.text = "최근 검색어"
    $0.textColor = .black
    $0.font = .systemFont(ofSize: 21, weight: .bold)
  }
  
  
  // MARK: Initializing
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    addSubview(titleLabel)
    setupConstraints()
  }
  
  func bind(reactor: RecentSearchCellReactor) {
    
  }
  
  private func setupConstraints() {
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(30)
      $0.leading.equalTo(20)
      $0.bottom.equalTo(-10)
    }
  }
}
