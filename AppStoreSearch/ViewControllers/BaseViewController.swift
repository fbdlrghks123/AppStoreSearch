//
//  BaseViewController.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/16.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

class BaseViewController: UIViewController {
  
  // MARK: RX
  
  var disposeBag = DisposeBag()
  
  
  // MARK: Layout Constraints

  private(set) var didSetupConstraints = false
  
  override func viewDidLoad() {
    self.view.setNeedsUpdateConstraints()
  }

  override func updateViewConstraints() {
    if !self.didSetupConstraints {
      self.setupConstraints()
      self.didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
  func setupConstraints() {
    // Override
  }
  
  deinit {
    print("deinit \(self)")
  }
  
  func setNavigationItems(url: String?) {
    guard self.navigationItem.titleView == nil else { return }
    guard let urlString = url else { return }
    let imageViewFrame = CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0)
    let imageView = UIImageView.init(frame: imageViewFrame).then {
      $0.setImage(url: urlString)
      $0.clipsToBounds = true
      $0.layer.cornerRadius = 8.0
      $0.backgroundColor = UIColor.clear
    }
    
    let buttonFrame = CGRect(x: 0, y: 0, width: 73, height: 28)
    let getButton = UIButton(frame: buttonFrame).then {
      $0.cornerRadius = 14
      $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
      $0.setTitle("받기", for: .normal)
      $0.setTitleColor(.white, for: .normal)
      $0.backgroundColor = .systemBlue
    }
    
    self.navigationItem.titleView = imageView
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: getButton)
  }
  
  func clearNavigationItem() {
    self.navigationItem.titleView = nil
    self.navigationItem.rightBarButtonItem = nil
  }
}
