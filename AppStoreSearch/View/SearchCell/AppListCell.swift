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
    $0.font = .systemFont(ofSize: 15)
  }
  
  private let genreLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 13, weight: .light)
    $0.textColor = .systemGray
  }
  
  private let ratingParentView = UIView()
  
  private let ratingView = CosmosView().then {
    $0.settings.fillMode = .precise
    $0.settings.filledColor = .systemGray
    $0.settings.emptyBorderWidth = 1
    $0.settings.emptyBorderColor = .systemGray
    $0.settings.filledBorderWidth = 1
    $0.settings.filledBorderColor = .systemGray
    $0.settings.starMargin = 0
    $0.settings.starSize = 15
    $0.settings.disablePanGestures = true
    $0.settings.updateOnTouch = false
  }
  
  private let ratingLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 12)
    $0.textColor = .systemGray3
  }
  
  private let getButton = UIButton(type: .custom).then {
    $0.cornerRadius = 14
    $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
    $0.setTitle("받기", for: .normal)
    $0.setTitleColor(.systemBlue, for: .normal)
    $0.backgroundColor = .systemGray6
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
      return self.screenshotStackView.arrangedSubviews as! [UIImageView]
  }
  
  
  // MARK: Initializing
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
     super.init(style: style, reuseIdentifier: reuseIdentifier)
     selectionStyle = .none
     self.setupConstraints()
   }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  private func setupConstraints() {
    addSubview(self.iconImageView)
    addSubview(self.getButton)
    addSubview(self.descriptionStackView)
    addSubview(self.screenshotStackView)
    
    self.ratingParentView.addSubview(self.ratingView)
    self.ratingParentView.addSubview(self.ratingLabel)
    
    self.descriptionStackView.addArrangedSubview(self.nameLabel)
    self.descriptionStackView.addArrangedSubview(self.genreLabel)
    self.descriptionStackView.addArrangedSubview(self.ratingParentView)
    
    self.iconImageView.snp.makeConstraints {
      $0.top.equalTo(20)
      $0.leading.equalTo(20)
      $0.size.equalTo(CGSize(width: 60, height: 60))
    }
    
    self.ratingView.snp.makeConstraints {
      $0.top.leading.bottom.equalToSuperview()
    }
    
    self.ratingLabel.snp.makeConstraints {
      $0.leading.equalTo(self.ratingView.snp.trailing).offset(3)
      $0.centerY.equalTo(self.ratingView.snp.centerY)
    }
    
    self.descriptionStackView.snp.makeConstraints {
      $0.top.equalTo(20)
      $0.leading.equalTo(iconImageView.snp.trailing).offset(10)
      $0.trailing.equalTo(getButton.snp.leading).offset(-10)
    }
    
    self.getButton.snp.makeConstraints {
      $0.trailing.equalTo(-20)
      $0.centerY.equalTo(self.descriptionStackView.snp.centerY)
      $0.size.equalTo(CGSize(width: 73, height: 28))
    }
    
    self.screenshotStackView.snp.makeConstraints {
      $0.top.equalTo(self.iconImageView.snp.bottom).offset(18)
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(-20)
    }
  }
  
  func bind(reactor: AppListCellReactor) {
    // State
    reactor.state
      .map { $0.app.name }
      .bind(to: self.nameLabel.rx.text)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.app.genre }
      .bind(to: self.genreLabel.rx.text)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.app.icon }
      .bind(to: self.iconImageView.rx.setImage)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.app.averageRating }
      .subscribe(onNext: { [weak self] rating in
        self?.ratingView.rating = rating
      })
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.app.totalRatingCount }
      .map { $0.ratingString }
      .bind(to: ratingLabel.rx.text)
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
