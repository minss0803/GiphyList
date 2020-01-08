//
//  SearchCellViewModel.swift
//  GiphyList
//
//  Created by 민쓰 on 09/01/2020.
//  Copyright © 2020 민쓰. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct SearchCellViewModel: SearchCellBindable {
    let disposeBag = DisposeBag()

    let data = PublishSubject<SearchCell.Data>()
    let setImage = PublishRelay<UIImage>()
    
    
    init(model: SearchCellModel = SearchCellModel()) {
        
        let imageLoadResult = data
            .map { return $0.images?.previewGif?.url }
            .filterNil()
            .flatMapLatest(model.loadImage(_:))
            .asObservable()

        let _ = imageLoadResult
            .map { result -> UIImage? in
                guard case .success(let value) = result else {
                    return nil
                }
                return value
            }
            .filterNil()
            .bind(to: setImage)
      
    }
}
