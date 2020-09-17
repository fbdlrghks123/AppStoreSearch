//
//  Network.swift
//  SearchExample
//
//  Created by ryuickhwan on 23/07/2019.
//  Copyright © 2019 ryuickhwan. All rights reserved.
//

enum APPError: Error {
  case networkError
  case dataNotFound
  case jsonParsingError
  case invalidStatusCode(Int)
}

struct ApiResult<Success: Decodable, Fail> where Fail: Error {
  let result: Result<Success, Fail>
  
  var success: Success? {
    guard case .success(let value) = result else { return nil }
    return value
  }
  
  var fail: Fail? {
    guard case .failure(let error) = result else { return nil }
    return error
  }
  
  init(result: Result<Success, Fail>) {
    self.result = result
  }
}

extension Reactive where Base: URLSession {
  func responseTo<T: Decodable>(request: URLRequest) -> Single<ApiResult<T, Error>> {
    return self.response(request: request)
      .take(1)
      .asSingle()
      .flatMap { (response, data) -> Single<ApiResult<T, Error>> in
        return Single.create { single in
          if response.statusCode >= 200 && response.statusCode < 300 {
            do {
              let decodedObject = try JSONDecoder().decode(T.self, from: data)
              single(.success(ApiResult(result: .success(decodedObject))))
            } catch let error {
              single(.success(ApiResult(result: .failure(error))))
            }
          }
          return Disposables.create()
        }
    }
  }
}
