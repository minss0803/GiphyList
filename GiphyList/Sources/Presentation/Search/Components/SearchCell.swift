//
//  SearchCell.swift
//  GiphyList
//
//  Created by 민쓰 on 03/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class SearchCell: UICollectionViewCell {
    typealias Data = (DataModel)
    
    override var isHighlighted: Bool {
        didSet {
            shrink(down: isHighlighted)
        }
    }
    let imageView = UIImageView()  // 스크린샷 파일
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(data: Data) {
        imageView.do {
            $0.kf.setImage(with: URL(string: data.images?.previewGif?.url ?? ""))
        }
    }
    
    func attribute() {
        
        imageView.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }
    }
    
    func layout() {
        addSubview(imageView)
        
        imageView.makeConstraints.do {
            $0.equalToSuperView()
        }

    }
}
extension SearchCell {
    func shrink(down: Bool) {
        UIView.animate(withDuration: 0.15) {
            if down {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            } else {
                self.transform = .identity
            }
        }
    }
}
