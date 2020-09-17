//
//  AppModel.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/17.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class AppModel: Decodable {
    var resultCount: Int
    var results: [AppData]
}

final class AppData: Decodable {
    var artworkUrl100: String
    var trackName: String
    var screenshotUrls : [String]
}
