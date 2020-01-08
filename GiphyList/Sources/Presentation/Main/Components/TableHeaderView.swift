
//
//  TableHeaderView.swift
//  GiphyList
//
//  Created by 민쓰 on 03/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Then

class TableHeaderView: UIView {
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let searchView = SearchView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attribute() {
        imageView.do {
            $0.image = UIImage(named: "watchaTheme")
            $0.contentMode = .scaleAspectFill
        }
        titleLabel.do {
            $0.font = .systemFont(ofSize: 50, weight: .bold)
            $0.textColor = .white
            $0.textAlignment = .center
            $0.text = "GIPHY"
        }
        searchView.searchTextField.do {
            $0.isUserInteractionEnabled = false
        }
    }
    
    func layout() {
        addSubview(imageView)
        addSubview(searchView)
        imageView.addSubview(titleLabel)

        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0).priority(999)
            $0.left.right.equalToSuperview().offset(0)
        }
        titleLabel.snp.makeConstraints {
            $0.left.right.lessThanOrEqualToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        searchView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalTo(self.imageView.snp.bottom).inset(25)
        }
        
        
        
    }
}
