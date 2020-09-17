//
//  AppStoreAPI.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/17.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

enum AppStoreApi {
  case search(str: String)
}

extension AppStoreApi: APIType {
  var path : String {
    switch self {
    case .search(let str):
      return "/search?term=\(str)&media=software&country=kr"
    }
  }
  
  var methods: HTTPMethods {
    return .get
  }
}

