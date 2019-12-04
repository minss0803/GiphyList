//
//  SearchView.swift
//  GiphyList
//
//  Created by 민쓰 on 03/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Then

class SearchView: UIView {
    
    let inputContainerView = UIView()
    let iconImage = UIImageView()
    let searchTextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attribute() {
        inputContainerView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 5.0
            $0.clipsToBounds = true
        }
        
        iconImage.do {
            $0.image = UIImage(named: "icon_search")
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentHuggingPriority(.required, for: .vertical)
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .black
        }
        
        searchTextField.do {
            $0.textColor = .black
            $0.returnKeyType = UIReturnKeyType.search
            $0.clearButtonMode = .whileEditing
            $0.placeholder = "검색어를 입력해주세요"
        }
    }
    
    
    func layout() {
        addSubview(inputContainerView)
        inputContainerView.addSubview(iconImage)
        inputContainerView.addSubview(searchTextField)
        
        inputContainerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().priority(100)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        iconImage.snp.makeConstraints {
            $0.top.bottom.left.equalToSuperview().inset(10)
            $0.width.equalTo(iconImage.snp.height)
        }
        
        searchTextField.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.left.equalTo(iconImage.snp.right).offset(10)
        }
    }
}
