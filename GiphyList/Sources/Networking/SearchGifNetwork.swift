//
//  SearchGifNetwork.swift
//  GiphyList
//
//  Created by 민쓰 on 02/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/// API Key
let apiKey = "GySNZZrCfAWOl4WLuhrPUhyCHgQLGwjz"

enum SearchGifNetworkError: Error {
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
protocol SearchGifNetwork {
    func getSearchGifList(_ params: [String:Any]) -> Observable<Result<SearchGif, SearchGifNetworkError>>
}

class SearchGifNetworkImpl: SearchGifNetwork {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getSearchGifList(_ params: [String:Any]) -> Observable<Result<SearchGif, SearchGifNetworkError>> {
        guard let url = makeGetAppListComponents(params).url else {
            let error = SearchGifNetworkError.error("올바르지 않은 URL입니다.")
            return .just(.failure(error))
        }
        return session.rx.data(request: URLRequest(url: url))
            .map { data in
                do {
                    let result = try JSONDecoder().decode(SearchGif.self, from: data)
                    return .success(result)
                } catch {
                    return .failure(.error("Giphy Search API 에러"))
                }
        }
    }

}

private extension SearchGifNetworkImpl {
    struct SearchGifAPI {
        static let scheme = "https"
        static let host = "api.giphy.com"
        static let path = "/v1/gifs/search"
    }
    
    // URLComponents 생성
    func makeGetAppListComponents(_ params: [String:Any]) -> URLComponents {
        var components = URLComponents()
        components.scheme = SearchGifAPI.scheme
        components.host = SearchGifAPI.host
        components.path = SearchGifAPI.path
        
        guard let keyword = params["keyword"] as? String else { return components }
        guard let pageCount = params["pageCount"] as? Int else { return components }
        
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "q", value: keyword),
            URLQueryItem(name: "limit", value: "25"),
            URLQueryItem(name: "offset", value: String(pageCount)),
        ]
        
        return components
    }
}
