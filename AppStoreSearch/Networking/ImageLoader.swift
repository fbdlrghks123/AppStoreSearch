//
//  ImageLoader.swift
//  AppStoreSearch
//
//  Created by Ickhwan Ryu on 2020/09/17.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

fileprivate let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
  func setImage(url: String) {
    downloadImage(url) { image in
      DispatchQueue.main.async {
        self.image = image
      }
    }
  }
  
  func downloadImage(_ url: String, completed: @escaping ((UIImage?) -> Void)) {
    DispatchQueue.global(qos: .background).async {
      guard let imageURL = URL(string: url) else { return }
      if let cachedImage = imageCache.object(forKey: NSString(string: url)) {
        completed(cachedImage)
      }
        
      let task = URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) in
        if error != nil { return }
        
        if let data = data, let downloadedImage = UIImage(data: data) {
          imageCache.setObject(downloadedImage, forKey: NSString(string: url))
          completed(downloadedImage)
        }
      })
      task.resume()
    }
  }
}

extension Reactive where Base: UIImageView {
  var setImage: Binder<String> {
    return Binder(self.base) { imageView, url in
      imageView.downloadImage(url) { image in
        DispatchQueue.main.async {
          imageView.image = image
        }
      }
    }
  }
}
