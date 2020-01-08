//
//  SearchCell.swift
//  GiphyList
//
//  Created by 민쓰 on 03/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Kingfisher

protocol SearchCellBindable {
    // ViewModel -> View
    var setImage: PublishRelay<UIImage> { get }
}

class SearchCell: UICollectionViewCell {
    typealias Data = (DataModel)
    
    override var isHighlighted: Bool {
        didSet {
            shrink(down: isHighlighted)
        }
    }
    let imageView = UIImageView()  // 스크린샷 파일
    var disposeBag = DisposeBag()
    var viewModel: SearchCellViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cancelLoadImage()
    }
    
    func setData(data: Data) {
        self.viewModel?.data.onNext(data)
    }
    
    func bind(_ viewModel: SearchCellViewModel) {
        self.viewModel = viewModel
        
        cancelLoadImage()
        
        viewModel.setImage
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (image) in
                self?.imageView.image = image
            })
            .disposed(by: disposeBag)
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
    func cancelLoadImage() {
        self.imageView.image = nil
        disposeBag = DisposeBag()
    }
    
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
