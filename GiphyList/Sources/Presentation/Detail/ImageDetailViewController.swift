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
import Then
import SnapKit
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
        self.view.layoutIfNeeded()
        self.viewModel = viewModel
        
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.imageData
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (model) in
                let imageWidth = Float(model.width) ?? 0
                let imageHeight = Float(model.height) ?? 0
                let ratio = imageHeight / imageWidth

                self?.gifImageView.do {
                    $0.kf.setImage(with: URL(string: model.imageUrl))
                    $0.snp.remakeConstraints {
                        $0.width.equalToSuperview()
                        $0.height.equalTo(self!.view.snp.width).multipliedBy(ratio)
                        $0.centerX.equalToSuperview()
                        $0.centerY.equalToSuperview()
                    }
                }
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
    }
    override func layout() {
        view.addSubview(gifImageView)
        view.addSubview(favoriteButton)
        view.addSubview(closeButton)
        
        gifImageView.snp.makeConstraints {
            $0.width.height.equalTo(0)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

        favoriteButton.snp.makeConstraints {
            $0.right.bottom.equalTo(gifImageView).inset(20)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(30)
        }
    }
}
