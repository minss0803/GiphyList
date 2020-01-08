//
//  ImageLoadNetwork.swift
//  GiphyList
//
//  Created by 민쓰 on 09/01/2020.
//  Copyright © 2020 민쓰. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ImageLoadNetworkError: Error {
    case error(String)
    case defaultError
    
    var message: String? {
        switch self {
        case let .error(msg):
            return msg
        case .defaultError:
            return "잠시 후에 다시 시도해주세요."
        }
    }
}

protocol ImageLoadNetwork {
    func getImage(_ url: URL) -> Observable<Result<UIImage, ImageLoadNetworkError>>
}

class ImageLoadNetworkImpl: ImageLoadNetwork {
    private let session: URLSession
    private let cache: ImageCacheProtocol = ImageCache()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getImage(_ url: URL) -> Observable<Result<UIImage, ImageLoadNetworkError>> {
        if let image = cache.image(for: url) {
            return .just(.success(image))
        }
        return session.rx.data(request: URLRequest(url: url))
            .map { data in
                let result = UIImage(data: data)
                if let image = result {
                    self.cache.saveImage(image, for: url)
                    return .success(image)
                } else {
                    return .failure(.error("Image Loading 데이터 파싱 오류"))
                }
        }
    }
}
