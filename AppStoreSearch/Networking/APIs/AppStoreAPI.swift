//
//  AppStoreAPI.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/17.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

enum AppStoreApi {
  case search(str: String)
  case lookUp(bundleId: String)
}

extension AppStoreApi: APIType {
  var path : String {
    switch self {
    case .search:
      return "/search"
    case .lookUp:
      return "/lookup"
    }
  }
  
  var parameters: [String: Any] {
    switch self {
    case .search(let str):
      return ["term" : str,
              "media" : "software",
              "country" : "kr"]
    case .lookUp(let bundleId):
      return ["country" : "kr",
              "media" : "software",
              "bundleId": bundleId]
    }
  }
  
  var methods: HTTPMethods {
    return .get
  }
}

