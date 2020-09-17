//
//  AppModel.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/17.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class AppResponse: Decodable {
    var resultCount: Int
    var results: [App]
}

final class App: Decodable {
    var name: String
    var genre: String
    var icon: String
    var screenshots: [String]
    
    var media: [String] {
        var images = self.screenshots
        images.insert(icon, at: 0)
        return images
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "trackName"
        case genre = "primaryGenreName"
        case icon = "artworkUrl512"
        case screenshots = "screenshotUrls"
    }
}
