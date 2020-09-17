//
//  APIType.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/17.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

enum HTTPMethods : String {
    case options    = "OPTIONS"
    case get        = "GET"
    case head       = "HEAD"
    case post       = "POST"
    case put        = "PUT"
    case patch      = "PATCH"
    case delete     = "DELETE"
    case trace      = "TRACE"
    case connect    = "CONNECT"
    case multipart  = "MULTIPART"
}

protocol APIType {
  var baseURL: String { get }
  var path: String { get }
  var methods: HTTPMethods { get }
}

extension APIType {
  var baseURL: String {
    return "http://itunes.apple.com"
  }
  
  func request<T: Decodable>(type: T.Type) -> Observable<ApiResult<T, Error>> {
    guard let urlString = (baseURL + path).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
      return .error(APPError.networkError)
    }
    guard let dataURL = URL(string: urlString) else { return .error(APPError.networkError)}
    var urlRequest = URLRequest(url: dataURL)
    urlRequest.httpMethod = methods.rawValue
    
    return URLSession.shared.rx.responseTo(request: urlRequest).asObservable()
   }
}
