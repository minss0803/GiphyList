//
//  ImageDetailViewModel.swift
//  GiphyList
//
//  Created by 민쓰 on 04/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct ImageDetailViewModel: ImageDetailViewBinable {
    let imageData = PublishSubject<FavoriteCharacter>()
    let realmManager = RealmManager()

    
}
