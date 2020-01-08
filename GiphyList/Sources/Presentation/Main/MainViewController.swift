//
//  ViewController.swift
//  GiphyList
//
//  Created by 민쓰 on 02/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import RxGesture
import RxAppState
import RxRealm
import RealmSwift

protocol MainViewBindable {
    var realmManager:RealmManager { get }
}

class MainViewController: ViewController <MainViewBindable> {

    let tableView = UITableView()
    let tableHeaderView = TableHeaderView()
    let tablebackgroundView = UIView()
    
    var favorites: Results<FavoriteCharacter>!

    // MARK: - Binding
    override func bind(_ viewModel: MainViewBindable) {
        self.disposeBag = DisposeBag()
        
        // 상단 검색 바를 터치했을 때, 검색 화면으로 이동하기
        tableHeaderView.searchView.inputContainerView.rx
            .tapGesture()
            .when(.recognized)
            .throttle(0.5, latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                let searchViewController = SearchViewController()
                let searchViewModel = SearchViewModel()
                searchViewController.bind(searchViewModel)
                
                let transition = CATransition()
                transition.duration = 0.2
                transition.type = CATransitionType.fade
                self?.navigationController?.view.layer.add(transition, forKey:nil)
                self?.navigationController?.pushViewController(searchViewController, animated: false)
            })
            .disposed(by: disposeBag)
        
        guard let realm = try? Realm() else { return }
        favorites = realm.objects(FavoriteCharacter.self).sorted(byKeyPath: "time", ascending: false)

        Observable.changeset(from: favorites)
            .subscribe(onNext: { [unowned self] _, changes in
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Attribute
    override func attribute() {
        self.do {
            $0.view.backgroundColor = .white
        }
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(FavoriteCell.self, forCellReuseIdentifier: String(describing: FavoriteCell.self))
            $0.backgroundColor = .clear
            $0.separatorStyle = .none
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 500
            $0.contentInset = UIEdgeInsets(top: self.view.bounds.width, left: 0, bottom: 20, right: 0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            if #available(iOS 11.0, *) {
                $0.contentInsetAdjustmentBehavior = .never
            }
        }
        tableHeaderView.do {
            $0.backgroundColor = .clear
            $0.frame.size = CGSize(width: self.view.bounds.width, height: self.view.bounds.width)
        }

    }
    
    // MARK: - Layout
    override func layout() {
        self.view.addSubview(tableView)
        tableView.backgroundView = tablebackgroundView
        tablebackgroundView.addSubview(tableHeaderView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tableHeaderView.imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0)
            $0.height.equalTo(tableHeaderView.snp.width)
        }
    }

}

// MAKR: - UI Animation
extension MainViewController {
    func animHeaderView(by offset:CGFloat) {
        guard self.view.snp.target != nil else { return }
    
        let degree = offset - self.view.bounds.width
        tableHeaderView.imageView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(degree > 0 ? 0 : degree)
            $0.height.equalTo(tableHeaderView.snp.width).offset(degree > 0 ? degree : 0)
        }
    }
}
// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FavoriteCell.self), for: indexPath) as! FavoriteCell
        
        guard (favorites?.count ?? 0) > indexPath.row else { return cell }
        
        let favoriteData = favorites[indexPath.row]
        cell.setData(data: favoriteData)
        cell.titleLabel.do {
            $0.text = indexPath.row == 0 ? "" : ""
        }
    
        return cell
    }
}
// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    /*
     테이블 뷰의 contentOffset의 변화를 감지하여,
     해더뷰에 parallax effect 적용
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.animHeaderView(by: -scrollView.contentOffset.y)
    }
    /*
     테이블 뷰의 셀을 터치 시,
     선택한 GIF의 상세화면으로 이동
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard (favorites?.count ?? 0) > indexPath.row else { return }
        let favoriteData = favorites[indexPath.row]
        
        let imageDetailViewController = ImageDetailViewController()
        let imageDetailViewModel = ImageDetailViewModel()
        imageDetailViewController.bind(imageDetailViewModel)
        imageDetailViewModel.imageData.onNext(favoriteData)
        
        imageDetailViewController.modalPresentationStyle = .overCurrentContext
        self.present(imageDetailViewController, animated: true)
    }
    
    
}
