//
//  ImageLoader.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/17.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class ImageDownLoadManager {
  
  // MARK: Property
  
  private let urlCache = URLCache(
    memoryCapacity: 50 * 1024 * 1024,
    diskCapacity: 100 * 1024 * 1024,
    diskPath: "ImageDownloadCache"
  )
  
  private var imageSession: URLSession?
  private var timeoutInterval = TimeInterval(60)
  private let requestCachePolicy: NSURLRequest.CachePolicy = .useProtocolCachePolicy
  
  static let shared = ImageDownLoadManager()
  
  
  // MARK: Initializing
  
  init() {
    let operationQueue = OperationQueue().then {
      $0.name = "ImageOperation"
      $0.maxConcurrentOperationCount = 3
    }
    let sessionConfig = URLSessionConfiguration.default.then {
      $0.urlCache = self.urlCache
      $0.requestCachePolicy = self.requestCachePolicy
    }
    
    self.imageSession = URLSession(
      configuration: sessionConfig,
      delegate: nil,
      delegateQueue: operationQueue
    )
  }
  
  func downloadImage(_ url: String, completed: @escaping ((UIImage?) -> Void)) {
    guard let imageURL = URL(string: url) else { return }
    let request = URLRequest(
      url: imageURL,
      cachePolicy: self.requestCachePolicy,
      timeoutInterval: self.timeoutInterval
    )
    
    if let cacheResponse = urlCache.cachedResponse(for: request),
      let cachedImage = UIImage.init(data: cacheResponse.data) {
      DispatchQueue.main.async {
        completed(cachedImage)
      }
      return
    }
    
    let task = self.imageSession?.dataTask(
      with: imageURL,
      completionHandler: { (data, response, error) in
      if error != nil { return }
      
      let statusCode = (response as! HTTPURLResponse).statusCode
      guard 200..<300 ~= statusCode else { return }
      
      if let data = data, let response = response {
        let cacheResponse = CachedURLResponse(response: response, data: data)
        self.urlCache.storeCachedResponse(cacheResponse, for: request)
        
        DispatchQueue.main.async {
          if let image = UIImage.init(data: data) {
              completed(image)
          }
        }
      }
    })
    
    task?.resume()
  }
}

fileprivate let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
  func setImage(url: String) {
    ImageDownLoadManager.shared.downloadImage(url) { image in
      self.image = image
    }
  }
}

extension Reactive where Base: UIImageView {
  var setImage: Binder<String> {
    return Binder(self.base) { imageView, url in
      ImageDownLoadManager.shared.downloadImage(url) { image in
          imageView.image = image
      }
    }
  }
}
