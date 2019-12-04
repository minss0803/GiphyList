//
//  SearchGif.swift
//  GiphyList
//
//  Created by 민쓰 on 02/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import Foundation

struct SearchGif: Codable {
    let data: [DataModel]?
    let pagination: Pagination?
    let meta: MetaInfo?
}

struct DataModel: Codable {
    let type: String?
    let id: String?
    let images: ImagesModel?
    
}

struct ImagesModel: Codable {
    let previewGif: ImageData?
    let downsized: ImageData?
    
    enum CodingKeys: String, CodingKey {
        case previewGif = "preview_gif"
        case downsized
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.previewGif = try? values.decode(ImageData.self, forKey: .previewGif)
        self.downsized = try? values.decode(ImageData.self, forKey: .downsized)
    }
}

// MARK: - 이미지 데이터
/**
 - note: APP에서 사용 중인 값은, preview와 downsized만 사용하고 있음
 - parameter width : 이미지의 넓이 값
 - parameter height: 이미지의 높이 값
 - parameter size : 이미지 크기
 - parameter url : 이미지 URL
 */
struct ImageData: Codable {
    let width: String
    let height: String?
    let size: String?
    let url: String?
}
// MARK: - 페이지 정보
/**
- note: 페이징 처리를 하기 위해, 필요한 정보
- parameter totalCount : 전체 아이템 총 갯수
- parameter count: 현재까지 불러온 데이터 갯수
- parameter offset : 몇번째 아이템 부터 데이터를 받을 지 판단
*/
struct Pagination: Codable {
    let totalCount: Int?
    let count: Int?
    let offset: Int?
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count, offset
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.totalCount = try? values.decode(Int.self, forKey: .totalCount)
        self.count = try? values.decode(Int.self, forKey: .count)
        self.offset = try? values.decode(Int.self, forKey: .offset)
    }
}

// MARK: - 메타 정보
struct MetaInfo: Codable {
    let status: Int?
    let mesg: String?
    let responnse_id: String?
}
