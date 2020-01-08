//
//  FavoriteCell.swift
//  GiphyList
//
//  Created by 민쓰 on 04/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import SnapKit

class FavoriteCell: UITableViewCell {
    typealias Data = (FavoriteCharacter)
    
    let titleLabel = UILabel()
    let containerView = UIView()
    let previewImageView = UIImageView() // 미리보기 이미지
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        shrink(down: highlighted)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        attribute()
        layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(data: Data) {
        previewImageView.do {
            $0.kf.setImage(with: URL(string: data.imageUrl))
        }
    }
    
    func attribute() {
        self.do {
            $0.selectionStyle = .none
        }
        titleLabel.do {
            $0.font = .systemFont(ofSize: 20, weight: .regular)
            $0.textColor = .black
        }
        containerView.do {
            $0.layer.shadowOpacity = 0.2
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0.layer.shadowRadius = 10
            $0.layer.shadowColor = UIColor.black.cgColor
        }
        previewImageView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 20.0
            $0.contentMode = .scaleAspectFill
        }
    }
    
    func layout() {
        addSubview(titleLabel)
        addSubview(containerView)
        containerView.addSubview(previewImageView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.right.equalToSuperview().inset(20)
        }
        containerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.left.right.equalToSuperview().inset(20)
        }
        previewImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(300)
        }
    }
    
}
extension FavoriteCell {
    func shrink(down: Bool) {
        UIView.animate(withDuration: 0.2,
                       delay: 0.0,
                       options: [.allowUserInteraction, .curveEaseInOut], animations: {
            if down {
                self.containerView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            } else {
                self.containerView.transform = .identity
            }
        })
    }
}
