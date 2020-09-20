//
//  AppModel.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/17.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class AppResponse: Decodable {
  let resultCount: Int
  let results: [App]
}

final class App: Decodable {
  var name: String
  var genre: String
  var icon: String
  var screenshots: [String]
  var totalRatingCount: Int
  var averageRating: Double
  var bundleId: String?
  var trackContentRating: String?
  var version: String?
  var releaseDate: String?
  var releaseNotes: String?
  var description: String?
  var sellerName: String?
  var fileSizeBytes: String?
  var genres: [String]?
  var supportedDevices: [String]?
  var languageCodesISO2A: [String]?
  var advisories: [String]?
  var minimumOsVersion: String
  
  
  enum CodingKeys: String, CodingKey {
    case name = "trackName"
    case genre = "primaryGenreName"
    case icon = "artworkUrl512"
    case screenshots = "screenshotUrls"
    case totalRatingCount = "userRatingCount"
    case averageRating = "averageUserRating"
    case bundleId = "bundleId"
    case trackContentRating = "trackContentRating"
    case version = "version"
    case releaseDate = "releaseDate"
    case releaseNotes = "releaseNotes"
    case description = "description"
    case sellerName = "sellerName"
    case fileSizeBytes = "fileSizeBytes"
    case genres = "genres"
    case supportedDevices = "supportedDevices"
    case languageCodesISO2A = "languageCodesISO2A"
    case advisories = "advisories"
    case minimumOsVersion = "minimumOsVersion"
  }
}
