//
//  AppDelegate.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/16.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    guard let window = window else { return false }
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let tabbarController = storyboard.instantiateViewController(identifier: "tabbarController") as! UITabBarController
    
    if let navigationController = tabbarController.viewControllers?.last as? UINavigationController,
      let searchViewController = navigationController.visibleViewController as? SearchViewController {
      searchViewController.reactor = SearchViewReactor()
    }
    
    window.rootViewController = tabbarController
    
    return true
  }
  
}

