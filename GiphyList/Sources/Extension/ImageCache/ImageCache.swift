//
//  ImageCache.swift
//  GiphyList
//
//  Created by 민쓰 on 09/01/2020.
//  Copyright © 2020 민쓰. All rights reserved.
//

import Foundation
import UIKit
import ImageIO

protocol ImageCacheProtocol: class {
    // URL을 기준으로, Cache Memory에서 이미지를 불러온다
    func image(for url: URL) -> UIImage?
    // 특정 URL을 키값으로 설정하여, Cahce Memory에 이미지를 저장한다.
    func saveImage(_ image: UIImage?, for url: URL)
}

class ImageCache: ImageCacheProtocol {
    
    struct Config {
        /**
         NSCache는 캐싱하는 데이터의 개수를 제한할 수 있습니다.
         만약 countLimit이 10으로 설정되어 있는데, 11개의 데이터를 NSCache에 넣게 되면 1개는 자동으로 버립니다.
         */
        let count: Int
        /**
        . 즉, NSCache에 추가된 데이터들의 cost가 totalCostLimit에 도달하거나 넘게 되면 NSCache는 데이터를 버립니다.
        */
        let memory: Int
        static let defaultSet = Config(count: 100, memory: 1024 * 1024 * 100) // 100 MB
    }
    
   static private var cache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = Config.defaultSet.count
        cache.totalCostLimit = Config.defaultSet.memory
        return cache
    }()
    
    func image(for url: URL) -> UIImage? {
        if let image = ImageCache.cache.object(forKey: url as AnyObject) as? UIImage {
            return image
        }
        return nil
    }

    func saveImage(_ image: UIImage?, for url: URL) {
        guard let image = image else { return removeImage(for: url) }
        
        ImageCache.cache.setObject(image, forKey: url as AnyObject, cost: 1)
    }

    func removeImage(for url: URL) {
        
        ImageCache.cache.removeObject(forKey: url as AnyObject)
    }
}
