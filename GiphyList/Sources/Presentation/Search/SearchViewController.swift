//
//  SearchViewController.swift
//  GiphyList
//
//  Created by 민쓰 on 03/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Toaster

protocol SearchViewBindable {
    
    // View -> ViewModel
    var searchKeyword: PublishSubject<String> { get }
    var willDisplayCell: PublishRelay<IndexPath> { get }
    var clearBtnPressed: PublishRelay<Void> { get }
    
    // ViewModel -> View
    var cellData: Driver<[DataModel]> { get }
    var reloadList: Signal<Void> { get }
    var errorMessage: Signal<String> { get }
    var cells: BehaviorRelay<[DataModel]> { get }
}

class SearchViewController: ViewController <SearchViewBindable> {
    
    // MARK: - Properties
    let headerView = UIView()
    let cancelButton = UIButton()
    let searchView = SearchView()
    let borderLineView = UIView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var viewModel: SearchViewBindable?
    
    // MARK: - UI Setting
    private struct UI {
        static let inputBarColor = UIColor(white: 240.0 / 255.0, alpha: 1.0)
        static let borderColor = UIColor(white: 220.0 / 255.0, alpha: 1.0)
    }
    
    // MARK: - Binding
    override func bind(_ viewModel: SearchViewBindable) {
        self.viewModel = viewModel
        
        self.rx.viewWillAppear
            .subscribe(onNext: { [weak self] _ in
                self?.searchView.searchTextField.becomeFirstResponder()
            })
        .   disposed(by: disposeBag)

        self.rx.viewWillDisappear
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        /*
         검색하기 버튼을 터치 시,
         기존 검색된 내역을 CLEAR 시키고, 키워드 검색 API 호출
        */
        searchView.searchTextField.rx.controlEvent([.editingDidEndOnExit])
           .do(onNext: {
                viewModel.clearBtnPressed.accept(Void())
            })
            .map { [weak self] _ in
                self?.searchView.searchTextField.text ?? ""
            }
            .bind(to: viewModel.searchKeyword)
            .disposed(by: disposeBag)
        
        /*
         취소 버튼 터치 시, 이전화면으로 이동
        */
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let transition = CATransition()
                transition.duration = 0.2
                transition.type = CATransitionType.fade
                self?.navigationController?.view.layer.add(transition, forKey:nil)
                self?.navigationController?.popViewController(animated: false)
            })
            .disposed(by: disposeBag)
            
        
        /*
         ListItem을 터치하여, GIF 상세화면으로 이동하기
         */
        collectionView.rx.modelSelected(DataModel.self)
            .subscribe(onNext: { [weak self] (model) in
                let imageDetailViewController = ImageDetailViewController()
                let imageDetailViewModel = ImageDetailViewModel()
                imageDetailViewController.bind(imageDetailViewModel)
                
                let favoriteModel = FavoriteCharacter(imageId: model.id ?? "",
                                                      imageUrl: model.images?.downsized?.url ?? "",
                                                      width: model.images?.downsized?.width ?? "",
                                                      height: model.images?.downsized?.height ?? "")
                imageDetailViewModel.imageData.onNext(favoriteModel)
                
                imageDetailViewController.modalPresentationStyle = .overCurrentContext
                self!.present(imageDetailViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        /*
         현재 보여지는 셀이 가장 마지막 셀인 경우,
         데이터 fetch 가능 여부 판단 후 페이징 처리하기
        */
        collectionView.rx.willDisplayCell
            .map { $1 }
            .bind(to: viewModel.willDisplayCell)
            .disposed(by: disposeBag)
            
        
        // API를 통해 전달된 데이트를 콜렉션뷰에 표시합니다.
        viewModel.cellData
            .drive(collectionView.rx.items) { cv, row, data in
                let index = IndexPath(row: row, section: 0)
                let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: SearchCell.self), for: index) as! SearchCell
                cell.setData(data: data)
                return cell
            }
            .disposed(by: disposeBag)
        
        // API 연동 성공 시, 테이블 뷰를 리로딩 합니다.
        viewModel.reloadList
            .emit(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        // API 연동 실패 시, 토스트 메시지를 띄웁니다.
        viewModel.errorMessage
            .emit(onNext: { (msg) in
                Toast(text: msg, delay: 0, duration: 0.5).show()
            })
            .disposed(by: disposeBag)
        
    }
    
    // MARK: - Attribute
    override func attribute() {
        
        headerView.do {
            $0.backgroundColor = .white
        }
        
        searchView.inputContainerView.do {
            $0.backgroundColor = UI.inputBarColor
        }
        cancelButton.do {
            $0.setTitle("취소", for: .normal)
            $0.setTitleColor(.purple, for: .normal)
            $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
            $0.setContentHuggingPriority(.required, for: .horizontal)
        }
        
        collectionView.do {
            $0.register(SearchCell.self, forCellWithReuseIdentifier: String(describing: SearchCell.self))
            $0.backgroundColor = .white
            $0.showsHorizontalScrollIndicator = false
            $0.isPagingEnabled = false
            
            let layout = WaterfallLayout()
            layout.delegate = self
            layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            layout.minimumLineSpacing = 8.0
            layout.minimumInteritemSpacing = 8.0
            
            $0.collectionViewLayout = layout
        }
        
        borderLineView.do {
            $0.backgroundColor = UI.borderColor
        }
    
    }
    
    // MARK: - Layout
    override func layout() {
        view.addSubview(headerView)
        view.addSubview(collectionView)
        headerView.addSubview(searchView)
        headerView.addSubview(cancelButton)
        headerView.addSubview(borderLineView)
        
        headerView.makeConstraints.do {
            $0.top()
            $0.leading()
            $0.trailing()
        }
        
        searchView.makeConstraints.do {
            $0.top(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10)
            $0.leading(constant: 20)
            $0.bottom(constant: -20)
            $0.height(constant: 50)
        }
        
        cancelButton.makeConstraints.do {
            $0.top(equalTo: searchView.topAnchor)
            $0.bottom(equalTo: searchView.bottomAnchor)
            $0.leading(equalTo: searchView.trailingAnchor)
            $0.trailing()
        }
        
        borderLineView.makeConstraints.do {
            $0.bottom()
            $0.leading()
            $0.trailing()
            $0.height(constant: 1)
        }
        
        collectionView.makeConstraints.do {
            $0.top(equalTo: headerView.bottomAnchor)
            $0.bottom()
            $0.leading()
            $0.trailing()
        }
    }
    
}

// MARK: - WaterfallLayoutDelegate
extension SearchViewController: WaterfallLayoutDelegate {
    func collectionViewLayout(for section: Int) -> WaterfallLayout.Layout {
        return .waterfall(column: 2, distributionMethod: .balanced)
    }

    func collectionView(_ collectionView: UICollectionView, layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let cells = viewModel?.cells.value,
            cells.count > indexPath.row else { return CGSize.zero }
        
        let item = cells[indexPath.row]
        let imageWidth = Int(item.images?.previewGif?.width ?? "") ?? 0
        let imageHeight = Int(item.images?.previewGif?.height ?? "") ?? 0
        return CGSize(width: imageWidth, height: imageHeight)
    }
}
