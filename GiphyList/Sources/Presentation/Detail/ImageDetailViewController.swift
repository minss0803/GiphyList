//
//  ImageDetailViewController.swift
//  GiphyList
//
//  Created by 민쓰 on 04/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxAppState
import Then
import Kingfisher

protocol ImageDetailViewBinable {
    var imageData: PublishSubject<FavoriteCharacter> { get }
    var realmManager: RealmManager { get }
}

class ImageDetailViewController: ViewController<ImageDetailViewBinable> {
    
    var viewModel: ImageDetailViewBinable?
    let gifImageView = UIImageView()
    let favoriteButton = FavoriteButton()
    let closeButton = UIButton()
    
    override func bind(_ viewModel: ImageDetailViewBinable) {
        self.viewModel = viewModel
        
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.imageData
            .map { $0.id }
            .flatMap { viewModel.realmManager.isFavorite(imageId:$0) }
            .subscribe(onNext: { [weak self] (result) in
                if result.count > 0 {
                    self?.favoriteButton.favoriteState = .favorited
                } else {
                    self?.favoriteButton.favoriteState = .notFavorited
                }
            })
            .disposed(by: disposeBag)

        // 이미지 데이터가 올바르게 전달되고, 화면이 최초로 그려진 경우 실행
        Observable.combineLatest(viewModel.imageData, self.rx.viewDidLoad)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (model, action) in
                
                // 이미지뷰 사이즈 조정
                let imageWidth  = Float(model.width) ?? 0
                let imageHeight = Float(model.height) ?? 0
                let ratio = imageHeight / imageWidth
                
                self?.gifImageView.do {
                    $0.kf.setImage(with: URL(string: model.imageUrl))
                    $0.remakeConstraints.do {
                        $0.width()
                        $0.height(equalTo: self!.view.widthAnchor, multiplier: CGFloat(ratio))
                        $0.centerX()
                        $0.centerY()
                    }
                }
                // 좋아요 버튼 노출
                self?.favoriteButton.isHidden = false
            })
            .disposed(by: disposeBag)
        
        // 이미지 데이터가 올바르게 전달되고, 좋아요 버튼이 선택된 경우
        Observable.combineLatest(viewModel.imageData, favoriteButton.rx.tap)
            .subscribe(onNext: { [weak self] (model, action) in
                if self?.favoriteButton.favoriteState == .favorited {
                    viewModel.realmManager.unfavorite(imageId: model.id)
                }else{
                    viewModel.realmManager.favorite(imageId: model.id,
                                                    imageUrl: model.imageUrl,
                                                    width: model.width,
                                                    height: model.height)
                }
                
            })
            .disposed(by: disposeBag)

    }
    override func attribute() {
        view.do {
            $0.isOpaque = false
            $0.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        }
        closeButton.do {
            $0.setImage(UIImage(named: "icon_close"), for: .normal)
        }
        favoriteButton.do {
            $0.isHidden = true
        }
    }
    override func layout() {
        view.addSubview(gifImageView)
        view.addSubview(favoriteButton)
        view.addSubview(closeButton)
        
        gifImageView.makeConstraints.do {
            $0.width(constant:0)
            $0.height(constant:0)
            $0.centerX()
            $0.centerY()
        }

        favoriteButton.makeConstraints.do {
            $0.bottom(equalTo: gifImageView.bottomAnchor, constant: -20)
            $0.trailing(equalTo: gifImageView.trailingAnchor, constant: -20)
        }
        
        closeButton.makeConstraints.do {
            $0.top(constant: 30)
            $0.trailing(constant: -30)
        }
    }
}
