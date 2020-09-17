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
  var parameters: [String: Any] { get }
}

extension APIType {
  var baseURL: String {
    return "https://itunes.apple.com"
  }
  
  func request<T: Decodable>(type: T.Type) -> Observable<ApiResult<T, Error>> {
    guard let urlString = (baseURL + path).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
      return .error(APPError.networkError)
    }
    guard let dataURL = URL(string: urlString) else { return .error(APPError.networkError)}
    var urlRequest = URLRequest(url: dataURL)
    
    if methods == .get,
      var urlComponents = URLComponents(url: dataURL, resolvingAgainstBaseURL: false),
      !parameters.isEmpty {
      let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(self.parameters)
        urlComponents.percentEncodedQuery = percentEncodedQuery
        urlRequest.url = urlComponents.url
    }
    
    urlRequest.httpMethod = methods.rawValue
    
    return URLSession.shared.rx.responseTo(request: urlRequest).asObservable()
   }
  
  private func query(_ parameters: [String: Any]) -> String {
    var components: [(String, String)] = []
    
    for key in parameters.keys.sorted(by: <) {
      let value = parameters[key]!
      components += queryComponents(fromKey: key, value: value)
    }
    return components.map { "\($0)=\($1)" }.joined(separator: "&")
  }
  
   public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
     var components: [(String, String)] = []
     
     if let dictionary = value as? [String: Any] {
       for (nestedKey, value) in dictionary {
           components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
       }
     } else if let array = value as? [Any] {
       for value in array {
           components += queryComponents(fromKey: "\(key)[]", value: value)
       }
     } else if let value = value as? NSNumber {
       if value.isBool {
           components.append((escape(key), escape(value.boolValue ? "1" : "0")))
       } else {
           components.append((escape(key), escape("\(value)")))
       }
     } else if let bool = value as? Bool {
       components.append((escape(key), escape(bool ? "1" : "0")))
     } else {
       components.append((escape(key), escape("\(value)")))
     }
     
     return components
   }
  
  
  public func escape(_ string: String) -> String {
      let generalDelimitersToEncode = ":#[]@"
      let subDelimitersToEncode = "!$&'()*+,;="
      
      var allowedCharacterSet = CharacterSet.urlQueryAllowed
      allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
     
      return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
  }
}

extension NSNumber {
  var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}
