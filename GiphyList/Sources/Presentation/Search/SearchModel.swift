//
//  SearchModel.swift
//  GiphyList
//
//  Created by 민쓰 on 03/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import Foundation
import RxSwift

struct SearchModel {
    let searchGifNetwork: SearchGifNetwork
    
    init(searchGifNetwork: SearchGifNetwork = SearchGifNetworkImpl()) {
        self.searchGifNetwork = searchGifNetwork
    }
    
    func getSearchResult(_ data:String) -> Observable<Result<SearchGif, SearchGifNetworkError>> {
        let params = ["keyword": data,
                      "pageCount" : 0] as [String : Any]
        return searchGifNetwork.getSearchGifList(params)
    }
    func fetchMoreData(_ data:(String, Int)) -> Observable<Result<SearchGif, SearchGifNetworkError>> {
        let params = ["keyword": data.0,
                      "pageCount" : data.1 + 1] as [String : Any]
        return searchGifNetwork.getSearchGifList(params)
    }
    
    

}
