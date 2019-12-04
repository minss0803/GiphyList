//
//  RelamManager.swift
//  GiphyList
//
//  Created by 민쓰 on 04/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import Foundation
import RxSwift
import RxRealm
import RealmSwift

/**
   - note: ReamDB 에 넣고자 하는 값
   - parameter imageId: 이미지를 구분할 수 있는 유니크한 키 값
   - parameter imageUrl: (downSized) 이미지 URL
   - parameter width: (downSized) 이미지 넒이
   - parameter height: (downSized) 이미지 높이
   - parameter time: 데이터가 저장된 시간 (정렬할때 사용함)
*/
class FavoriteCharacter: Object {
    @objc dynamic var id = ""
    @objc dynamic var imageUrl = ""
    @objc dynamic var width  = ""
    @objc dynamic var height = ""
    @objc dynamic var time: TimeInterval = Date().timeIntervalSinceReferenceDate
    
    convenience init(imageId: String, imageUrl: String, width:String, height: String) {
        self.init()
        self.id = imageId
        self.width = width
        self.height = height
        self.imageUrl = imageUrl
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

struct RealmManager {
    
    let disposeBag = DisposeBag()
    
    func isFavorite(imageId: String) -> Observable<Results<FavoriteCharacter>>{
        return favorites(filter: "id == '\(imageId)'")
    }
    
    
    func favorite(imageId: String, imageUrl: String, width: String, height: String) {
        let favorite = FavoriteCharacter(imageId: imageId,
                                         imageUrl: imageUrl,
                                         width: width,
                                         height: height)
        Observable.just(favorite)
            .subscribe(Realm.rx.add())
            .disposed(by: disposeBag)
    }
    
    func favorites(filter predicateFormat: String? = nil) -> Observable<Results<FavoriteCharacter>> {
        guard let realm = try? Realm() else {
            return Observable.empty()
        }
        var results: Results<FavoriteCharacter> = realm.objects(FavoriteCharacter.self)
        if let predicate = predicateFormat {
            results = results.filter(predicate)
        }
        
        return Observable.collection(from: results)
    }
    
    func unfavorite(imageId: String) {
        favorites(filter: "id == '\(imageId)'")
            .subscribe(Realm.rx.delete())
            .dispose()
    }
    
}
