//
//  MainViewModel.swift
//  GiphyList
//
//  Created by 민쓰 on 03/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct MainViewModel: MainViewBindable {
    let disposeBag = DisposeBag()
    
    let realmManager = RealmManager()

    init(model: MainModel = MainModel()) {
    }
}
