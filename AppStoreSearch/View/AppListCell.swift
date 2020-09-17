//
//  AppListCell.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/17.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class AppListCell: BaseTableViewCell, View {
  
  // MARK: UI
  
  private let iconImageView = UIImageView().then {
    $0.cornerRadius = 12
    $0.borderWidth = 0.15
    $0.borderColor = .lightGray
    $0.clipsToBounds = true
  }

  private let descriptionStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 2
  }
  
  private let nameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 16)
  }
  
  private let genreLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14, weight: .light)
    $0.textColor = .systemGray
  }
  
  private let getButton = UIButton(type: .custom).then {
    $0.cornerRadius = 15
    $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
    $0.setTitle("GET", for: .normal)
    $0.setTitleColor(.systemBlue, for: .normal)
    $0.backgroundColor = .fromRed(238, green: 241, blue: 249)
  }
  
  private let screenshotStackView = UIStackView().then { stackView in
    stackView.axis = .horizontal
    stackView.spacing = 10
    
    (0...2).forEach { _ in
      let imageView = UIImageView().then { imageView in
        imageView.cornerRadius = 6
        imageView.borderWidth = 0.15
        imageView.clipsToBounds = true
        imageView.borderColor = .lightGray
        imageView.snp.makeConstraints { make in
          make.size.equalTo(CGSize(width: 100, height: 190))
        }
      }
      stackView.addArrangedSubview(imageView)
    }
  }
  
  
  // MARK: Property
  
  var screenshotImageViews: [UIImageView] {
      return screenshotStackView.arrangedSubviews as! [UIImageView]
  }
  
  
  // MARK: Initializing
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    setupConstraints()
  }
  
  private func setupConstraints() {
    addSubview(iconImageView)
    addSubview(getButton)
    addSubview(descriptionStackView)
    addSubview(screenshotStackView)
    
    descriptionStackView.addArrangedSubview(nameLabel)
    descriptionStackView.addArrangedSubview(genreLabel)
    descriptionStackView.addArrangedSubview(UIView())
    
    iconImageView.snp.makeConstraints {
      $0.top.equalTo(20)
      $0.leading.equalTo(20)
      $0.size.equalTo(CGSize(width: 60, height: 60))
    }
    
    descriptionStackView.snp.makeConstraints {
      $0.top.equalTo(20)
      $0.leading.equalTo(iconImageView.snp.trailing).offset(10)
      $0.trailing.equalTo(getButton.snp.leading).offset(-15)
    }
    
    getButton.snp.makeConstraints {
      $0.trailing.equalTo(-20)
      $0.centerY.equalTo(descriptionStackView.snp.centerY)
      $0.size.equalTo(CGSize(width: 65, height: 30))
    }
    
    screenshotStackView.snp.makeConstraints {
      $0.top.equalTo(iconImageView.snp.bottom).offset(18)
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(-20)
    }
  }
  
  func bind(reactor: AppListCellReactor) {
    // State
    reactor.state
      .map { $0.app.name }
      .bind(to: nameLabel.rx.text)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.app.genre }
      .bind(to: genreLabel.rx.text)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.app.icon }
      .bind(to: iconImageView.rx.setImage)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.app.screenshots }
      .subscribe(onNext: { [weak self] screenshots in
        screenshots.enumerated().forEach { (index, element) in
          self?.screenshotImageViews[safe: index]?.setImage(url: element)
        }
      })
      .disposed(by: disposeBag)
  }
}
