
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
        searchView.searchTextField.do {
            $0.isUserInteractionEnabled = false
        }
    }
    
    func layout() {
        addSubview(searchView)
        
        searchView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(25)
        }
        
        
    }
}
