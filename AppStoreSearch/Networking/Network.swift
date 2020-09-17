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

extension Reactive where Base: URLSession {
  public func responseTo<T: Decodable>(request: URLRequest) -> Single<T>{
    return self.response(request: request)
      .retry(3)
      .asSingle()
      .flatMap { (response, data) -> PrimitiveSequence<SingleTrait, T> in
        return Single.create { single in
          if response.statusCode >= 200 && response.statusCode < 300 {
            do {
              let decodedObject = try JSONDecoder().decode(T.self, from: data)
              single(.success(decodedObject))
            } catch {
              single(.error(APPError.jsonParsingError))
            }
          }
          return Disposables.create()
        }
    }
  }
}

extension PrimitiveSequence where Trait == SingleTrait, Element: Decodable {
    @discardableResult
    public func onResponse(
      _ onNext: @escaping (Element) -> Void,
      onError: @escaping (Error) -> Void
    ) -> Disposable {
        return self.observeOn(MainScheduler.instance)
          .subscribe(onSuccess: onNext, onError: onError)
    }
}
