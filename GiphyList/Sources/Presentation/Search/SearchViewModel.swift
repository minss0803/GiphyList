//
//  SearchViewModel.swift
//  GiphyList
//
//  Created by 민쓰 on 03/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional

struct SearchViewModel: SearchViewBindable {
    let disposeBag = DisposeBag()

    let searchKeyword   = PublishSubject<String>()
    let willDisplayCell = PublishRelay<IndexPath>()
    var clearBtnPressed = PublishRelay<Void>()
    
    let cellData: Driver<[DataModel]>
    let reloadList: Signal<Void>
    let errorMessage: Signal<String>
    
    let cells = BehaviorRelay<[DataModel]>(value: [])
    private let pageInfo = PublishSubject<Pagination>()
    
    init(model: SearchModel = SearchModel()) {
    
        // 키워드 검색을 한 경우,
        // Page Count는 0으로 초기화
        let searchResult = searchKeyword
            .flatMapLatest(model.getSearchResult(_:))
            .asObservable()
            .share()
        
        let initList = searchResult
            .map { result -> [DataModel]? in
                guard case .success(let value) = result else {
                    return nil
                }
                return value.data
            }
            .filterNil()
        
        // 페이징 처리
        let shouldMoreFatch = Observable
            .combineLatest(
                willDisplayCell,
                cells,
                pageInfo,
                searchKeyword
            ) { (indexPath: $0, list: $1, pageInfo: $2, keyword: $3) }
            .throttle(0.5, latest: true, scheduler: MainScheduler.instance)
            .map { data -> (String, Int)? in
                let count = data.list.count
                let totalCount = data.pageInfo.totalCount ?? 0
                guard count < totalCount-1 else {
                    return nil
                }
                if data.indexPath.row == count-1  {
                    return (data.keyword, count)
                }
                return nil
            }
        
        let fetchedResult = shouldMoreFatch
            .filterNil()
            .flatMapLatest(model.fetchMoreData)
            .asObservable()
            .share()
        
        let _ = Observable
            .merge(searchResult, fetchedResult)
            .map { result -> Pagination? in
                guard case .success(let value) = result else {
                    return nil
                }
                return value.pagination
            }
            .filterNil()
            .bind(to: pageInfo)
        
        let fetchedList = fetchedResult
            .map { result -> [DataModel]? in
                guard case .success(let value) = result else {
                    return nil
                }
                print("패치 한방")
                return value.data
            }
            .filterNil()
        
        let clearList = clearBtnPressed.asObservable()
                  .map { [DataModel]() }

       // 처음 불러온 데이터와, paging 처리된 데이터를 결합
        let _ = Observable
            .merge(
                initList,
                fetchedList,
                clearList
            )
            .scan([]){ prev, newList in
                return newList.isEmpty ? [] : prev + newList
            }
            .bind(to: cells)
        
        // error Handler
        let searchError = searchResult
            .map { result -> String? in
                guard case .failure(let error) = result else {
                    return nil
                }
                return error.message
            }
            .filterNil()
        
        errorMessage = searchError
            .asSignal(onErrorJustReturn: "서비스가 불안정 합니다. 잠시 후 다시 이용해주세요.")
        
        // Result Handler
        cellData = cells
            .asDriver(onErrorDriveWith: .empty())
        
        reloadList = searchResult
            .map { _ in Void() }
            .asSignal(onErrorSignalWith: .empty())
    }

}
