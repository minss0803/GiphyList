//
//  SearchCellModel.swift
//  GiphyList
//
//  Created by 민쓰 on 09/01/2020.
//  Copyright © 2020 민쓰. All rights reserved.
//

import Foundation
import RxSwift

// TODO: - https://stackoverflow.com/questions/27919620/how-to-load-gif-image-in-swift
// 이미지 데이터를 GIF 이미지로 변경하기

struct SearchCellModel {
    let imageLoadNetwork: ImageLoadNetwork
    
    init(imageLoadNetwork: ImageLoadNetwork = ImageLoadNetworkImpl()) {
        self.imageLoadNetwork = imageLoadNetwork
    }
    
    func loadImage(_ url:String) -> Observable<Result<UIImage, ImageLoadNetworkError>> {
        if let url = URL(string: url) {
            return imageLoadNetwork.getImage(url)
        }else {
            return .just(.failure(.error("올바르지 않은 이미지 URL 입니다.")))
        }
        
    }

}
