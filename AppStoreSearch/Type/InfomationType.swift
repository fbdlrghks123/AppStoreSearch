//
//  InfomationType.swift
//  AppStoreSearch
//
//  Created by RIH on 2020/09/20.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

enum InfomationType: String {
  case seller = "제공자"
  case appSize = "크기"
  case category = "카테고리"
  case compatibility = "호환성"
  case language = "언어"
  case age = "연령 등급"
  case copyright = "저작권"
}

extension InfomationType {
  var isFoldingView: Bool {
    switch self {
    case .compatibility, .language, .age:
      return true
    default:
      return false
    }
  }
}
